import 'dart:typed_data';

import '../../../domain/geometry/geometry.dart';
import '../../../domain/models/detection_models.dart';
import 'letterbox.dart';

/// Layout of the YOLO output tensor.
enum YoloOutputLayout {
  /// `[1, 4 + classes, anchors]` (Ultralytics default).
  channelsFirst,

  /// `[1, anchors, 4 + classes]`.
  channelsLast,
}

/// Decodes YOLOv8/v11 style output into detections.
///
/// The decoder is deliberately independent of tflite: the isolate hands it a
/// flat float buffer plus its shape, which makes it fully unit testable.
class YoloDecoder {
  const YoloDecoder({
    required this.scoreThreshold,
    required this.iouThreshold,
    required this.maxDetections,
    required this.classIds,
    this.forcedLayout,
  });

  final double scoreThreshold;
  final double iouThreshold;
  final int maxDetections;

  /// COCO ids that map to a vehicle class; every other class is ignored.
  final Set<int> classIds;
  final YoloOutputLayout? forcedLayout;

  /// Decodes [data] (a `[1, channels, anchors]` or `[1, anchors, channels]`
  /// tensor) into normalised image boxes via [transform].
  ///
  /// [valuesPerAnchor] is `4 + numClasses`. Values are expected in model pixel
  /// space (0..inputSize); a model that emits normalised boxes is detected
  /// automatically.
  List<Detection> decode({
    required Float32List data,
    required int valuesPerAnchor,
    required int anchors,
    required LetterboxTransform transform,
    YoloOutputLayout? layout,
  }) {
    if (valuesPerAnchor <= 4 || anchors <= 0) return const [];
    final resolved = layout ?? forcedLayout ?? YoloOutputLayout.channelsFirst;
    final numClasses = valuesPerAnchor - 4;
    if (classIds.any((id) => id >= numClasses)) {
      // Model has fewer classes than the mapping expects; keep going, the
      // out-of-range ids simply never match.
    }

    final channelsFirst = resolved == YoloOutputLayout.channelsFirst;
    double value(int anchor, int channel) => channelsFirst
        ? data[channel * anchors + anchor]
        : data[anchor * valuesPerAnchor + channel];

    // Auto detect normalised exports (all coordinates <= 2).
    var maxCoordinate = 0.0;
    for (var i = 0; i < anchors; i++) {
      for (var c = 0; c < 4; c++) {
        final v = value(i, c);
        if (v > maxCoordinate) maxCoordinate = v;
      }
    }
    final normalised = maxCoordinate <= 2.0;

    final candidates = <Detection>[];
    for (var i = 0; i < anchors; i++) {
      var bestClass = -1;
      var bestScore = 0.0;
      for (final id in classIds) {
        if (id >= numClasses) continue;
        final score = value(i, 4 + id);
        if (score > bestScore) {
          bestScore = score;
          bestClass = id;
        }
      }
      if (bestClass < 0 || bestScore < scoreThreshold) continue;

      final cx = value(i, 0);
      final cy = value(i, 1);
      final w = value(i, 2);
      final h = value(i, 3);
      if (!cx.isFinite || !cy.isFinite || !w.isFinite || !h.isFinite) {
        continue;
      }
      final double x1Model, y1Model, x2Model, y2Model;
      if (normalised) {
        // Values are 0..1 of the model input.
        x1Model = (cx - w / 2) * transform.inputSize;
        y1Model = (cy - h / 2) * transform.inputSize;
        x2Model = (cx + w / 2) * transform.inputSize;
        y2Model = (cy + h / 2) * transform.inputSize;
      } else {
        x1Model = cx - w / 2;
        y1Model = cy - h / 2;
        x2Model = cx + w / 2;
        y2Model = cy + h / 2;
      }

      final box = BoundingBox.fromCorners(
        transform.xToNormalised(x1Model),
        transform.yToNormalised(y1Model),
        transform.xToNormalised(x2Model),
        transform.yToNormalised(y2Model),
      );
      if (box.area <= 0) continue;
      candidates.add(Detection(
        box: box,
        classId: bestClass,
        confidence: bestScore,
      ));
    }

    return _nonMaxSuppression(candidates);
  }

  List<Detection> _nonMaxSuppression(List<Detection> input) {
    if (input.isEmpty) return input;
    final sorted = List<Detection>.of(input)
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    final kept = <Detection>[];
    final suppressed = List<bool>.filled(sorted.length, false);
    for (var i = 0; i < sorted.length; i++) {
      if (suppressed[i]) continue;
      final candidate = sorted[i];
      kept.add(candidate);
      if (kept.length >= maxDetections) break;
      for (var j = i + 1; j < sorted.length; j++) {
        if (suppressed[j]) continue;
        if (sorted[j].classId != candidate.classId) continue;
        if (candidate.box.iou(sorted[j].box) > iouThreshold) {
          suppressed[j] = true;
        }
      }
    }
    return kept;
  }
}

/// Copies a tensor buffer (possibly quantised) into a float list.
Float32List dequantize(
  Uint8List bytes, {
  required int elementCount,
  required double scale,
  required int zeroPoint,
  required bool isInt8,
}) {
  final result = Float32List(elementCount);
  if (scale == 0) {
    // Not quantised: reinterpret the raw bytes.
    final view = bytes.buffer.asFloat32List(bytes.offsetInBytes, elementCount);
    result.setAll(0, view);
    return result;
  }
  for (var i = 0; i < elementCount; i++) {
    final raw = isInt8 ? bytes[i].toSigned(8) : bytes[i];
    result[i] = (raw - zeroPoint) * scale;
  }
  return result;
}
