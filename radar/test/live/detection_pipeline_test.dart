import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:radar/features/live/data/frame_source.dart';
import 'package:radar/features/live/data/letterbox.dart';
import 'package:radar/features/live/data/yolo_decoder.dart';

/// Builds a `[1, channels, anchors]` output buffer (channels first).
Float32List channelsFirstOutput({
  required int channels,
  required int anchors,
  required Map<int, List<double>> values,
}) {
  final data = Float32List(channels * anchors);
  values.forEach((channel, list) {
    for (var a = 0; a < anchors && a < list.length; a++) {
      data[channel * anchors + a] = list[a];
    }
  });
  return data;
}

void main() {
  group('LetterboxTransform', () {
    test('letterboxes a 16:9 frame into a square', () {
      final t = LetterboxTransform.fit(
        sourceWidth: 640,
        sourceHeight: 360,
        inputSize: 640,
      );
      expect(t.scale, 1.0);
      expect(t.padX, 0);
      expect(t.padY, 140);
    });

    test('scales a 1080p portrait frame down', () {
      final t = LetterboxTransform.fit(
        sourceWidth: 1080,
        sourceHeight: 1920,
        inputSize: 640,
      );
      expect(t.scale, closeTo(640 / 1920, 1e-9));
      expect(t.padY, 0);
      expect(t.padX, closeTo((640 - 1080 * 640 / 1920) / 2, 1e-9));
    });

    test('round trips normalised coordinates', () {
      final t = LetterboxTransform.fit(
        sourceWidth: 640,
        sourceHeight: 480,
        inputSize: 640,
      );
      for (final x in [0.0, 0.25, 0.5, 1.0]) {
        expect(t.xToNormalised(t.normalisedToX(x)), closeTo(x, 1e-9));
      }
    });
  });

  group('YoloDecoder', () {
    const transform = LetterboxTransform(
      sourceWidth: 640,
      sourceHeight: 640,
      inputSize: 640,
      scale: 1,
      padX: 0,
      padY: 0,
    );

    YoloDecoder decoder({Set<int>? ids}) => YoloDecoder(
      scoreThreshold: 0.35,
      iouThreshold: 0.45,
      maxDetections: 10,
      classIds: ids ?? {2, 3, 5, 7},
    );

    test('decodes a channels first anchor into a normalised box', () {
      final data = channelsFirstOutput(
        channels: 84,
        anchors: 1,
        values: {
          0: [320],
          1: [320],
          2: [200],
          3: [100],
          6: [0.9], // class 2 = car
        },
      );
      final result = decoder().decode(
        data: data,
        valuesPerAnchor: 84,
        anchors: 1,
        transform: transform,
      );
      expect(result, hasLength(1));
      final box = result.single.box;
      expect(result.single.classId, 2);
      expect(result.single.confidence, closeTo(0.9, 1e-6));
      expect(box.left, closeTo(220 / 640, 1e-6));
      expect(box.right, closeTo(420 / 640, 1e-6));
      expect(box.top, closeTo(270 / 640, 1e-6));
      expect(box.bottom, closeTo(370 / 640, 1e-6));
    });

    test('decodes a channels last tensor', () {
      const channels = 84;
      const anchors = 2;
      final data = Float32List(channels * anchors);
      // Anchor 1 is a truck with a high score; index = anchor * channels + c.
      final base = 1 * channels;
      data[base + 0] = 320;
      data[base + 1] = 320;
      data[base + 2] = 100;
      data[base + 3] = 100;
      data[base + 4 + 7] = 0.8;
      final result = decoder().decode(
        data: data,
        valuesPerAnchor: channels,
        anchors: anchors,
        transform: transform,
        layout: YoloOutputLayout.channelsLast,
      );
      expect(result.single.classId, 7);
    });

    test('ignores classes that are not vehicles', () {
      final data = channelsFirstOutput(
        channels: 84,
        anchors: 1,
        values: {
          0: [100],
          1: [100],
          2: [40],
          3: [40],
          4: [0.99], // class 0 = person
        },
      );
      expect(
        decoder().decode(
          data: data,
          valuesPerAnchor: 84,
          anchors: 1,
          transform: transform,
        ),
        isEmpty,
      );
    });

    test('suppresses overlapping boxes of the same class', () {
      final data = channelsFirstOutput(
        channels: 84,
        anchors: 2,
        values: {
          0: [320, 322],
          1: [320, 322],
          2: [200, 200],
          3: [100, 100],
          6: [0.9, 0.8],
        },
      );
      final result = decoder().decode(
        data: data,
        valuesPerAnchor: 84,
        anchors: 2,
        transform: transform,
      );
      expect(result, hasLength(1));
      expect(result.single.confidence, closeTo(0.9, 1e-6));
    });

    test('keeps overlapping boxes of different classes', () {
      final data = channelsFirstOutput(
        channels: 84,
        anchors: 2,
        values: {
          0: [320, 320],
          1: [320, 320],
          2: [200, 200],
          3: [100, 100],
          6: [0.9, 0.0], // car
          9: [0.0, 0.85], // bus (id 5 -> channel 9)
        },
      );
      final result = decoder().decode(
        data: data,
        valuesPerAnchor: 84,
        anchors: 2,
        transform: transform,
      );
      expect(result, hasLength(2));
      expect(result.map((d) => d.classId).toSet(), {2, 5});
    });

    test('handles normalised exports (coordinates 0..1)', () {
      final data = channelsFirstOutput(
        channels: 84,
        anchors: 1,
        values: {
          0: [0.5],
          1: [0.5],
          2: [0.2],
          3: [0.1],
          6: [0.7],
        },
      );
      final result = decoder().decode(
        data: data,
        valuesPerAnchor: 84,
        anchors: 1,
        transform: transform,
      );
      expect(result.single.box.left, closeTo(0.4, 1e-6));
      expect(result.single.box.right, closeTo(0.6, 1e-6));
    });

    test('applies the letterbox offset when mapping back', () {
      final t = LetterboxTransform.fit(
        sourceWidth: 640,
        sourceHeight: 360,
        inputSize: 640,
      );
      // Box in the vertical middle of the model input.
      final data = channelsFirstOutput(
        channels: 84,
        anchors: 1,
        values: {
          0: [320],
          1: [320],
          2: [64],
          3: [36],
          6: [0.9],
        },
      );
      final result = decoder().decode(
        data: data,
        valuesPerAnchor: 84,
        anchors: 1,
        transform: t,
      );
      expect(result.single.box.top, closeTo(0.45, 1e-6));
    });

    test('quantised output is dequantised before decoding', () {
      final raw = Int8List(84).buffer.asUint8List();
      final values = dequantize(
        raw,
        elementCount: 84,
        scale: 0.01,
        zeroPoint: 0,
        isInt8: true,
      );
      expect(values, hasLength(84));
      expect(values[10], 0);
    });
  });

  group('FramePixelSource', () {
    test('rotates a YUV frame by one quarter turn', () {
      // 2x4 raw: left column bright luma 200, right column 50.
      const rawWidth = 2;
      const rawHeight = 4;
      final y = Uint8List(rawWidth * rawHeight);
      for (var row = 0; row < rawHeight; row++) {
        y[row * rawWidth] = 200;
        y[row * rawWidth + 1] = 50;
      }
      final u = Uint8List(rawWidth * rawHeight ~/ 2)..fillRange(0, 4, 128);
      final v = Uint8List(rawWidth * rawHeight ~/ 2)..fillRange(0, 4, 128);
      final source = Yuv420FrameSource(
        rawWidth: rawWidth,
        rawHeight: rawHeight,
        yPlane: y,
        uPlane: u,
        vPlane: v,
        yStride: rawWidth,
        uvStride: rawWidth,
        uvPixelStride: 1,
        rotationQuarterTurns: 1,
      );
      expect(source.width, rawHeight);
      expect(source.height, rawWidth);

      final out = Uint8List(3);
      // Upright top-left maps to raw bottom-left (bright).
      source.writeRgb(0, 0, out, 0);
      expect(out[0], closeTo(200, 2));
      // Upright top-right maps to raw top-left (bright).
      source.writeRgb(source.width - 1, 0, out, 0);
      expect(out[0], closeTo(200, 2));
      // Upright bottom-right maps to raw top-right (dark).
      source.writeRgb(source.width - 1, source.height - 1, out, 0);
      expect(out[0], closeTo(50, 2));
      // Upright bottom-left maps to raw bottom-right (dark).
      source.writeRgb(0, source.height - 1, out, 0);
      expect(out[0], closeTo(50, 2));
    });

    test('BGRA source reads channels in the right order', () {
      final bytes = Uint8List.fromList([10, 20, 30, 255]);
      final source = BgraFrameSource(
        rawWidth: 1,
        rawHeight: 1,
        bytes: bytes,
        bytesPerRow: 4,
      );
      final out = Uint8List(3);
      source.writeRgb(0, 0, out, 0);
      expect(out[0], 30); // R
      expect(out[1], 20); // G
      expect(out[2], 10); // B
    });

    test('preprocessor fills the padded border with grey', () {
      final rgb = Uint8List(4 * 2 * 3)..fillRange(0, 4 * 2 * 3, 0);
      final source = RgbFrameSource(width: 4, height: 2, rgb: rgb);
      final transform = LetterboxTransform.fit(
        sourceWidth: 4,
        sourceHeight: 2,
        inputSize: 4,
      );
      final input = Float32List(4 * 4 * 3);
      const LetterboxPreprocessor().fill(source, input, transform);
      // Top row is padding (grey 114/255), middle row is the image (black).
      expect(input[0], closeTo(114 / 255, 1e-6));
      expect(input[2 * 4 * 3], closeTo(0, 1e-6));
    });

    test('preprocessor quantises model input using tensor parameters', () {
      final source = RgbFrameSource(
        width: 1,
        height: 1,
        rgb: Uint8List.fromList([0, 127, 255]),
      );
      final transform = LetterboxTransform.fit(
        sourceWidth: 1,
        sourceHeight: 1,
        inputSize: 1,
      );
      final unsigned = Uint8List(3);
      const LetterboxPreprocessor().fillBytes(
        source,
        unsigned,
        transform,
        scale: 1 / 255,
      );
      expect(unsigned, [0, 127, 255]);

      final signed = Uint8List(3);
      const LetterboxPreprocessor().fillBytes(
        source,
        signed,
        transform,
        scale: 1 / 255,
        zeroPoint: -128,
        isInt8: true,
      );
      expect(signed, [128, 255, 127]);
    });
  });
}
