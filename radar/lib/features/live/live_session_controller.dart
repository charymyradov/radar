import 'dart:async';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/config/detection_config.dart';
import '../../core/providers.dart';
import '../../domain/counting/vehicle_counter.dart';
import '../../domain/geometry/geometry.dart';
import '../../domain/models/detection_models.dart';
import '../../domain/models/enums.dart';
import '../calibration/domain/calibration.dart';
import '../history/data/event_repository.dart';
import '../settings/domain/app_settings.dart';
import 'data/detection_isolate.dart';

enum LiveSessionStatus { idle, starting, running, stopping }

class LiveVehicle {
  const LiveVehicle({
    required this.id,
    required this.vehicleClass,
    required this.direction,
    required this.countedAt,
    this.speedKmh,
  });

  final String id;
  final VehicleClass vehicleClass;
  final TravelDirection direction;
  final DateTime countedAt;
  final double? speedKmh;
}

class LiveSessionState {
  const LiveSessionState({
    this.status = LiveSessionStatus.idle,
    this.error,
    this.sessionId,
    this.cameraReady = false,
    this.processedFrames = 0,
    this.lastDetectionCount = 0,
    this.totalCount = 0,
    this.classCounts = const {},
    this.directionCounts = const {},
    this.recent = const [],
    this.tracks = const [],
    this.inferenceFps = 0,
  });

  final LiveSessionStatus status;
  final String? error;
  final String? sessionId;
  final bool cameraReady;
  final int processedFrames;
  final int lastDetectionCount;
  final int totalCount;
  final Map<VehicleClass, int> classCounts;
  final Map<TravelDirection, int> directionCounts;
  final List<LiveVehicle> recent;
  final List<TrackedObject> tracks;
  final double inferenceFps;

  bool get isRunning => status == LiveSessionStatus.running;

  LiveSessionState copyWith({
    LiveSessionStatus? status,
    String? error,
    bool clearError = false,
    String? sessionId,
    bool clearSessionId = false,
    bool? cameraReady,
    int? processedFrames,
    int? lastDetectionCount,
    int? totalCount,
    Map<VehicleClass, int>? classCounts,
    Map<TravelDirection, int>? directionCounts,
    List<LiveVehicle>? recent,
    List<TrackedObject>? tracks,
    double? inferenceFps,
  }) => LiveSessionState(
    status: status ?? this.status,
    error: clearError ? null : (error ?? this.error),
    sessionId: clearSessionId ? null : (sessionId ?? this.sessionId),
    cameraReady: cameraReady ?? this.cameraReady,
    processedFrames: processedFrames ?? this.processedFrames,
    lastDetectionCount: lastDetectionCount ?? this.lastDetectionCount,
    totalCount: totalCount ?? this.totalCount,
    classCounts: classCounts ?? this.classCounts,
    directionCounts: directionCounts ?? this.directionCounts,
    recent: recent ?? this.recent,
    tracks: tracks ?? this.tracks,
    inferenceFps: inferenceFps ?? this.inferenceFps,
  );
}

final liveSessionProvider =
    NotifierProvider<LiveSessionController, LiveSessionState>(
      LiveSessionController.new,
    );

class LiveSessionController extends Notifier<LiveSessionState> {
  CameraController? _camera;
  DetectionIsolate? _detector;
  VehicleCounter? _counter;
  EventRepository? _events;
  AppSettings? _settings;
  Calibration? _calibration;
  String? _sessionId;
  bool _processingFrame = false;
  bool _openingPreview = false;
  int _sequence = 0;
  int _lastFrameMicros = 0;
  int _lastResultMicros = 0;
  int _snapshotFrame = 0;
  Uint8List? _latestSnapshot;
  final Stopwatch _monotonicClock = Stopwatch();

  CameraController? get cameraController => _camera;
  CalibrationGeometry? get calibrationGeometry => _calibration?.geometry;

  @override
  LiveSessionState build() {
    ref.onDispose(() {
      unawaited(_releaseResources(closeSession: true));
    });
    return const LiveSessionState();
  }

  Future<void> preparePreview() async {
    if (_camera?.value.isInitialized == true ||
        _openingPreview ||
        (state.status != LiveSessionStatus.idle &&
            state.status != LiveSessionStatus.starting)) {
      return;
    }
    _openingPreview = true;
    try {
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        throw StateError('CAMERA_PERMISSION_DENIED');
      }
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('CAMERA_UNAVAILABLE');
      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final cameraController = CameraController(
        camera,
        _resolutionFor(
          ref.read(settingsProvider).value?.cameraQuality ?? CameraQuality.high,
        ),
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      _camera = cameraController;
      await cameraController.initialize();
      if (state.status != LiveSessionStatus.idle &&
          state.status != LiveSessionStatus.starting) {
        await cameraController.dispose();
        _camera = null;
        return;
      }
      state = state.copyWith(cameraReady: true, clearError: true);
    } catch (error) {
      final failedCamera = _camera;
      _camera = null;
      if (failedCamera != null) {
        await failedCamera.dispose();
      }
      state = state.copyWith(error: _presentError(error));
    } finally {
      _openingPreview = false;
    }
  }

  Future<void> start() async {
    if (state.status != LiveSessionStatus.idle) return;
    state = state.copyWith(
      status: LiveSessionStatus.starting,
      clearError: true,
    );
    try {
      final settings = ref.read(settingsProvider).requireValue;
      final calibration = await ref
          .read(calibrationRepositoryProvider)
          .active(kDefaultStationId);
      if (calibration == null || !calibration.geometry.isValid) {
        throw StateError('CALIBRATION_REQUIRED');
      }
      _settings = settings;
      _calibration = calibration;

      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        throw StateError('CAMERA_PERMISSION_DENIED');
      }

      await preparePreview();
      if (state.error == 'CAMERA_PERMISSION_DENIED' ||
          state.error == 'CAMERA_UNAVAILABLE') {
        throw StateError(state.error!);
      }
      final cameraController = _camera;
      if (cameraController == null || !cameraController.value.isInitialized) {
        throw StateError(state.error ?? 'CAMERA_UNAVAILABLE');
      }

      final configJson = await rootBundle.loadString(
        'assets/config/detection.json',
      );
      final config = DetectionConfig.fromJsonString(configJson);
      final modelData = await rootBundle.load(config.assetPath);
      _detector = await DetectionIsolate.start(
        modelBytes: modelData.buffer.asUint8List(
          modelData.offsetInBytes,
          modelData.lengthInBytes,
        ),
        config: config,
      );

      final events = ref.read(eventRepositoryProvider);
      _events = events;
      final session = await ref
          .read(sessionRepositoryProvider)
          .start(
            id: const Uuid().v4(),
            stationId: kDefaultStationId,
            calibrationId: calibration.id,
          );
      _sessionId = session.id;
      _counter = VehicleCounter(
        calibration: calibration.geometry,
        idGenerator: const Uuid().v4,
        config: CounterConfig(
          distanceMeters: calibration.geometry.distanceMeters,
          flipDirection: settings.flipDirection,
        ),
      );
      _counter!.reset();
      _monotonicClock
        ..reset()
        ..start();
      await WakelockPlus.enable();
      await cameraController.startImageStream(_processFrame);
      state = state.copyWith(
        status: LiveSessionStatus.running,
        sessionId: session.id,
        clearError: true,
        processedFrames: 0,
        lastDetectionCount: 0,
        totalCount: 0,
        classCounts: const {},
        directionCounts: const {},
        recent: const [],
        tracks: const [],
        inferenceFps: 0,
      );
    } catch (error) {
      await _releaseResources(closeSession: true);
      state = state.copyWith(
        status: LiveSessionStatus.idle,
        cameraReady: false,
        error: _presentError(error),
        clearSessionId: true,
      );
    }
  }

  Future<void> stop() async {
    if (state.status == LiveSessionStatus.idle && _camera == null) return;
    state = state.copyWith(status: LiveSessionStatus.stopping);
    await _releaseResources(closeSession: true);
    state = const LiveSessionState();
  }

  Future<void> _processFrame(CameraImage image) async {
    final detector = _detector;
    final counter = _counter;
    final events = _events;
    final sessionId = _sessionId;
    final settings = _settings;
    final calibration = _calibration;
    if (_processingFrame ||
        detector == null ||
        counter == null ||
        events == null ||
        sessionId == null ||
        settings == null ||
        calibration == null) {
      return;
    }

    final nowMicros = _monotonicClock.elapsedMicroseconds;
    final minimumInterval = 1000000 ~/ settings.targetFps;
    if (nowMicros - _lastFrameMicros < minimumInterval) return;
    _lastFrameMicros = nowMicros;
    _processingFrame = true;
    final timestampUtc = DateTime.now().toUtc();

    try {
      final request = _requestFor(image, nowMicros);
      final result = await detector.detect(request);
      if (result.error != null) {
        throw StateError(result.error!);
      }
      if (result.snapshotJpeg != null) {
        _latestSnapshot = result.snapshotJpeg;
      }
      final outcome = counter.process(
        detections: result.detections,
        timestampMicros: nowMicros,
        nowUtc: timestampUtc,
      );

      for (final vehicle in outcome.counted) {
        events.enqueueCounted(
          vehicle: vehicle,
          sessionId: sessionId,
          calibrationId: calibration.id,
        );
      }
      for (final measurement in outcome.measured) {
        String? imagePath;
        if (measurement.speedKmh > settings.speedLimitKmh &&
            _latestSnapshot != null) {
          try {
            imagePath = await ref
                .read(mediaStoreProvider.future)
                .then(
                  (store) => store.saveJpeg(
                    _latestSnapshot!,
                    name: 'violation-${measurement.eventId}',
                  ),
                );
          } catch (error) {
            ref.read(appErrorProvider.notifier).report(error);
          }
        }
        events.enqueueMeasured(
          measurement,
          speedLimitKmh: settings.speedLimitKmh,
          imagePath: imagePath,
        );
      }
      if (outcome.counted.isNotEmpty || outcome.measured.isNotEmpty) {
        final recent = List<LiveVehicle>.of(state.recent);
        for (final counted in outcome.counted) {
          recent.insert(
            0,
            LiveVehicle(
              id: counted.id,
              vehicleClass: counted.vehicleClass,
              direction: counted.direction,
              countedAt: counted.countedAtUtc,
              speedKmh: counted.speedKmh,
            ),
          );
        }
        for (final measured in outcome.measured) {
          final index = recent.indexWhere(
            (item) => item.id == measured.eventId,
          );
          if (index >= 0) {
            final item = recent[index];
            recent[index] = LiveVehicle(
              id: item.id,
              vehicleClass: item.vehicleClass,
              direction: item.direction,
              countedAt: item.countedAt,
              speedKmh: measured.speedKmh,
            );
          }
        }
        final classes = Map<VehicleClass, int>.of(state.classCounts);
        final directions = Map<TravelDirection, int>.of(state.directionCounts);
        for (final counted in outcome.counted) {
          classes.update(
            counted.vehicleClass,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
          directions.update(
            counted.direction,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
        state = state.copyWith(
          totalCount: state.totalCount + outcome.counted.length,
          classCounts: classes,
          directionCounts: directions,
          recent: recent.take(5).toList(),
        );
      }
      final completedMicros = _monotonicClock.elapsedMicroseconds;
      final elapsed = completedMicros - _lastResultMicros;
      _lastResultMicros = completedMicros;
      state = state.copyWith(
        tracks: outcome.tracks,
        processedFrames: state.processedFrames + 1,
        lastDetectionCount: result.detections.length,
        inferenceFps: elapsed <= 0 ? 0 : 1000000 / elapsed,
      );
    } catch (error) {
      state = state.copyWith(error: error.toString());
    } finally {
      _processingFrame = false;
    }
  }

  DetectionFrameRequest _requestFor(CameraImage image, int timestampMicros) {
    final camera = _camera!.description;
    final turns = (camera.sensorOrientation ~/ 90) % 4;
    final seq = _sequence++;
    final wantSnapshot = _snapshotFrame++ % 5 == 0;
    final planes = image.planes;
    if (image.format.group != ImageFormatGroup.yuv420 || planes.length < 3) {
      throw StateError(
        'Unsupported camera image format: ${image.format.group}',
      );
    }
    return DetectionFrameRequest(
      seq: seq,
      timestampMicros: timestampMicros,
      rawWidth: image.width,
      rawHeight: image.height,
      rotationQuarterTurns: turns,
      y: TransferableTypedData.fromList([planes[0].bytes]),
      u: TransferableTypedData.fromList([planes[1].bytes]),
      v: TransferableTypedData.fromList([planes[2].bytes]),
      yStride: planes[0].bytesPerRow,
      uvStride: planes[1].bytesPerRow,
      uvPixelStride: planes[1].bytesPerPixel ?? 1,
      wantSnapshot: wantSnapshot,
    );
  }

  ResolutionPreset _resolutionFor(CameraQuality quality) => switch (quality) {
    CameraQuality.low => ResolutionPreset.low,
    CameraQuality.medium => ResolutionPreset.medium,
    CameraQuality.high => ResolutionPreset.high,
  };

  String _presentError(Object error) {
    final value = error.toString();
    if (value.contains('CALIBRATION_REQUIRED')) return 'CALIBRATION_REQUIRED';
    if (value.contains('CAMERA_PERMISSION_DENIED')) {
      return 'CAMERA_PERMISSION_DENIED';
    }
    if (value.contains('CAMERA_UNAVAILABLE')) return 'CAMERA_UNAVAILABLE';
    if (value.startsWith('CAMERA_ERROR:')) return value;
    if (error is CameraException) {
      return 'CAMERA_ERROR:${error.description ?? error.code}';
    }
    return value;
  }

  Future<void> _releaseResources({required bool closeSession}) async {
    final camera = _camera;
    _camera = null;
    if (camera != null) {
      try {
        if (camera.value.isStreamingImages) await camera.stopImageStream();
      } finally {
        await camera.dispose();
      }
    }
    _detector?.dispose();
    _detector = null;
    _counter = null;
    _processingFrame = false;
    _openingPreview = false;
    await WakelockPlus.disable();

    final sessionId = _sessionId;
    _sessionId = null;
    if (closeSession && sessionId != null) {
      await _events?.flush();
      await ref.read(sessionRepositoryProvider).end(sessionId);
    }
    _events = null;
  }
}
