import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../domain/models/enums.dart';

/// Score above which a detection is considered "high confidence" for the
/// first association stage of the tracker (ByteTrack style).
const double kHighConfidence = 0.45;

/// Configuration for the bundled detector, parsed from
/// `assets/config/detection.json` so the model can be swapped without code
/// changes.
@immutable
class DetectionConfig {
  const DetectionConfig({
    required this.assetPath,
    required this.inputSize,
    required this.scoreThreshold,
    required this.iouThreshold,
    required this.maxDetections,
    required this.numThreads,
    required this.vehicleClasses,
    this.forceLayout,
  });

  final String assetPath;
  final int inputSize;
  final double scoreThreshold;
  final double iouThreshold;
  final int maxDetections;
  final int numThreads;

  /// COCO class id -> app class.
  final Map<int, VehicleClass> vehicleClasses;

  /// When null the decoder inspects the output tensor shape.
  final TensorLayout? forceLayout;

  static const DetectionConfig fallback = DetectionConfig(
    assetPath: 'assets/models/yolov8n.tflite',
    inputSize: 640,
    scoreThreshold: 0.35,
    iouThreshold: 0.45,
    maxDetections: 30,
    numThreads: 4,
    vehicleClasses: {
      2: VehicleClass.car,
      3: VehicleClass.motorcycle,
      5: VehicleClass.bus,
      7: VehicleClass.truck,
    },
  );

  static DetectionConfig fromJsonString(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final model = (json['model'] as Map<String, dynamic>?) ?? const {};
    final classes = (json['vehicleClasses'] as Map<String, dynamic>?) ??
        const {
          '2': 'car',
          '3': 'motorcycle',
          '5': 'bus',
          '7': 'truck',
        };
    final mapped = <int, VehicleClass>{};
    classes.forEach((key, value) {
      final classId = int.tryParse(key);
      final vehicleClass = VehicleClass.fromName(value as String);
      if (classId != null && vehicleClass != null) {
        mapped[classId] = vehicleClass;
      }
    });
    final layoutName = model['layout'] as String?;
    return DetectionConfig(
      assetPath: model['asset'] as String? ?? fallback.assetPath,
      inputSize: (model['inputSize'] as num?)?.toInt() ?? fallback.inputSize,
      scoreThreshold:
          (model['scoreThreshold'] as num?)?.toDouble() ?? fallback.scoreThreshold,
      iouThreshold:
          (model['iouThreshold'] as num?)?.toDouble() ?? fallback.iouThreshold,
      maxDetections:
          (model['maxDetections'] as num?)?.toInt() ?? fallback.maxDetections,
      numThreads: (model['numThreads'] as num?)?.toInt() ?? fallback.numThreads,
      vehicleClasses: mapped.isEmpty ? fallback.vehicleClasses : mapped,
      forceLayout: TensorLayout.parse(layoutName),
    );
  }
}

/// How the YOLO output tensor is laid out.
enum TensorLayout {
  /// `[1, 4 + classes, anchors]` - Ultralytics default export.
  channelsFirst,

  /// `[1, anchors, 4 + classes]` - some conversions/quantised exports.
  channelsLast;

  static TensorLayout? parse(String? value) {
    switch (value?.toLowerCase()) {
      case 'channels_first':
      case 'channelsfirst':
        return TensorLayout.channelsFirst;
      case 'channels_last':
      case 'channelslast':
        return TensorLayout.channelsLast;
      default:
        return null;
    }
  }
}
