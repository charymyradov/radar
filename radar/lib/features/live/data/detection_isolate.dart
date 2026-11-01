import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../core/config/detection_config.dart';
import '../../../domain/models/detection_models.dart';
import 'frame_source.dart';
import 'letterbox.dart';
import 'yolo_decoder.dart';

/// One frame handed to the detection isolate.
///
/// Planes are transferred (not copied) with [TransferableTypedData] so a
/// 720p YUV frame does not get copied twice.
class DetectionFrameRequest {
  const DetectionFrameRequest({
    required this.seq,
    required this.timestampMicros,
    required this.rawWidth,
    required this.rawHeight,
    required this.rotationQuarterTurns,
    this.y,
    this.u,
    this.v,
    this.bgra,
    this.yStride = 0,
    this.uvStride = 0,
    this.uvPixelStride = 0,
    this.bytesPerRow = 0,
    this.wantSnapshot = false,
  });

  final int seq;
  final int timestampMicros;
  final int rawWidth;
  final int rawHeight;
  final int rotationQuarterTurns;
  final TransferableTypedData? y;
  final TransferableTypedData? u;
  final TransferableTypedData? v;
  final TransferableTypedData? bgra;
  final int yStride;
  final int uvStride;
  final int uvPixelStride;
  final int bytesPerRow;
  final bool wantSnapshot;

  bool get isBgra => bgra != null;

  /// Upright dimensions after rotation.
  int get displayWidth => rotationQuarterTurns.isOdd ? rawHeight : rawWidth;
  int get displayHeight => rotationQuarterTurns.isOdd ? rawWidth : rawHeight;
}

/// Result of one detection pass.
class DetectionFrameResult {
  const DetectionFrameResult({
    required this.seq,
    required this.detections,
    required this.inferenceMicros,
    required this.displayWidth,
    required this.displayHeight,
    this.snapshotJpeg,
    this.error,
  });

  final int seq;
  final List<Detection> detections;
  final int inferenceMicros;
  final int displayWidth;
  final int displayHeight;
  final Uint8List? snapshotJpeg;
  final String? error;
}

/// Runs the YOLO interpreter on a background isolate.
///
/// The model bytes are loaded on the main isolate (asset access needs the
/// Flutter engine) and transferred once at spawn time.
class DetectionIsolate {
  DetectionIsolate._(this._isolate, this._receivePort);

  final Isolate _isolate;
  final ReceivePort _receivePort;

  late final SendPort _sendPort;
  final Map<int, Completer<DetectionFrameResult>> _pending = {};
  bool _disposed = false;

  static Future<DetectionIsolate> start({
    required Uint8List modelBytes,
    required DetectionConfig config,
  }) async {
    final receivePort = ReceivePort();
    final ready = Completer<SendPort>();

    final isolate = await Isolate.spawn(
      _workerMain,
      _InitMessage(
        modelBytes: modelBytes,
        config: config,
        replyPort: receivePort.sendPort,
      ),
      debugName: 'yolo-detector',
      onError: receivePort.sendPort,
      onExit: receivePort.sendPort,
    );

    final instance = DetectionIsolate._(isolate, receivePort);

    receivePort.listen((message) {
      if (message is SendPort) {
        if (!ready.isCompleted) ready.complete(message);
        return;
      }
      if (message is DetectionFrameResult) {
        instance._complete(message);
        return;
      }
      if (message is _WorkerError) {
        if (!ready.isCompleted) {
          ready.completeError(StateError(message.message));
        } else {
          instance._failAll(message.message);
        }
        return;
      }
      if (message is List && message.isNotEmpty) {
        final detail = message.first?.toString() ?? 'detection isolate failed';
        if (!ready.isCompleted) {
          ready.completeError(StateError(detail));
        } else {
          instance._failAll(detail);
        }
      }
    });

    instance._sendPort = await ready.future.timeout(
      const Duration(seconds: 25),
      onTimeout: () => throw StateError('Detection isolate did not start'),
    );
    return instance;
  }

  void _complete(DetectionFrameResult result) {
    final completer = _pending.remove(result.seq);
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
  }

  void _failAll(String message) {
    final pending = List.of(_pending.values);
    _pending.clear();
    for (final completer in pending) {
      if (!completer.isCompleted) {
        completer.completeError(StateError(message));
      }
    }
  }

  /// Sends a frame and resolves when the isolate returns detections.
  Future<DetectionFrameResult> detect(DetectionFrameRequest request) {
    if (_disposed) {
      return Future.error(StateError('Detector has been disposed'));
    }
    final completer = Completer<DetectionFrameResult>();
    _pending[request.seq] = completer;
    _sendPort.send(request);
    return completer.future;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _failAll('Detector disposed');
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}

class _InitMessage {
  const _InitMessage({
    required this.modelBytes,
    required this.config,
    required this.replyPort,
  });

  final Uint8List modelBytes;
  final DetectionConfig config;
  final SendPort replyPort;
}

class _WorkerError {
  const _WorkerError(this.message);

  final String message;
}

// ---------------------------------------------------------------------------
// Worker side
// ---------------------------------------------------------------------------

void _workerMain(_InitMessage init) {
  final Interpreter interpreter;
  final options = InterpreterOptions()
    ..threads = math.max(1, init.config.numThreads);

  try {
    interpreter = Interpreter.fromBuffer(init.modelBytes, options: options);
  } catch (error) {
    init.replyPort.send(_WorkerError('Model could not be loaded: $error'));
    return;
  }

  final inputTensor = interpreter.getInputTensor(0);
  final inputShape = inputTensor.shape;
  if (inputShape.length != 4) {
    init.replyPort.send(_WorkerError('Unsupported input shape: $inputShape'));
    return;
  }
  final inputWidth = inputShape[2];
  final isFloatInput = inputTensor.type == TensorType.float32;
  final inputElements = inputTensor.numElements();
  final Float32List? inputFloat = isFloatInput
      ? Float32List(inputElements)
      : null;
  final Uint8List? inputUint8 = isFloatInput ? null : Uint8List(inputElements);

  final outputTensor = interpreter.getOutputTensor(0);
  final outputShape = outputTensor.shape;
  if (outputShape.length != 3) {
    init.replyPort.send(_WorkerError('Unsupported output shape: $outputShape'));
    return;
  }
  final channelsFirst = outputShape[1] < outputShape[2];
  final valuesPerAnchor = channelsFirst ? outputShape[1] : outputShape[2];
  final anchors = channelsFirst ? outputShape[2] : outputShape[1];

  final configuredLayout = init.config.forceLayout;
  final YoloOutputLayout layout = configuredLayout == null
      ? (channelsFirst
            ? YoloOutputLayout.channelsFirst
            : YoloOutputLayout.channelsLast)
      : (configuredLayout == TensorLayout.channelsFirst
            ? YoloOutputLayout.channelsFirst
            : YoloOutputLayout.channelsLast);

  final decoder = YoloDecoder(
    scoreThreshold: init.config.scoreThreshold,
    iouThreshold: init.config.iouThreshold,
    maxDetections: init.config.maxDetections,
    classIds: init.config.vehicleClasses.keys.toSet(),
    forcedLayout: layout,
  );

  const preprocessor = LetterboxPreprocessor();
  final receive = ReceivePort();
  init.replyPort.send(receive.sendPort);

  receive.listen((message) {
    if (message is! DetectionFrameRequest) return;
    try {
      final watch = Stopwatch()..start();
      final FramePixelSource source = message.isBgra
          ? BgraFrameSource(
              rawWidth: message.rawWidth,
              rawHeight: message.rawHeight,
              bytes: message.bgra!.materialize().asUint8List(),
              bytesPerRow: message.bytesPerRow,
              rotationQuarterTurns: message.rotationQuarterTurns,
            )
          : Yuv420FrameSource(
              rawWidth: message.rawWidth,
              rawHeight: message.rawHeight,
              yPlane: message.y!.materialize().asUint8List(),
              uPlane: message.u!.materialize().asUint8List(),
              vPlane: message.v!.materialize().asUint8List(),
              yStride: message.yStride,
              uvStride: message.uvStride,
              uvPixelStride: message.uvPixelStride,
              rotationQuarterTurns: message.rotationQuarterTurns,
            );

      final transform = LetterboxTransform.fit(
        sourceWidth: source.width,
        sourceHeight: source.height,
        inputSize: inputWidth,
      );

      if (isFloatInput) {
        preprocessor.fill(source, inputFloat!, transform);
        inputTensor.data = Uint8List.view(
          inputFloat.buffer,
          inputFloat.offsetInBytes,
          inputFloat.lengthInBytes,
        );
      } else {
        final params = inputTensor.params;
        preprocessor.fillBytes(
          source,
          inputUint8!,
          transform,
          scale: params.scale,
          zeroPoint: params.zeroPoint,
          isInt8: inputTensor.type == TensorType.int8,
        );
        inputTensor.data = inputUint8;
      }

      interpreter.invoke();

      final tensor = interpreter.getOutputTensor(0);
      final elementCount = valuesPerAnchor * anchors;
      final outputBytes = tensor.data;
      final Float32List output;
      if (tensor.type == TensorType.float32) {
        output = outputBytes.buffer.asFloat32List(
          outputBytes.offsetInBytes,
          elementCount,
        );
      } else {
        final params = tensor.params;
        output = dequantize(
          outputBytes,
          elementCount: elementCount,
          scale: params.scale,
          zeroPoint: params.zeroPoint,
          isInt8: tensor.type == TensorType.int8,
        );
      }

      final detections = decoder.decode(
        data: output,
        valuesPerAnchor: valuesPerAnchor,
        anchors: anchors,
        transform: transform,
      );

      Uint8List? snapshot;
      if (message.wantSnapshot) {
        snapshot = encodeSnapshot(source);
      }

      init.replyPort.send(
        DetectionFrameResult(
          seq: message.seq,
          detections: detections,
          inferenceMicros: watch.elapsedMicroseconds,
          displayWidth: source.width,
          displayHeight: source.height,
          snapshotJpeg: snapshot,
        ),
      );
    } catch (error, stack) {
      init.replyPort.send(
        DetectionFrameResult(
          seq: message.seq,
          detections: const <Detection>[],
          inferenceMicros: 0,
          displayWidth: message.displayWidth,
          displayHeight: message.displayHeight,
          error: '$error\n$stack',
        ),
      );
    }
  });
}
