import 'dart:ui';

import 'package:camera/camera.dart';

/// Aspect ratio used while no camera information is available yet.
const double kFallbackPortraitAspectRatio = 0.62;

/// Aspect ratio (width / height) of the upright camera preview.
///
/// Detection boxes, calibration lines and the overlay all live in the upright
/// (rotated) frame space. The camera plugin reports [CameraValue.previewSize]
/// and [CameraValue.aspectRatio] in the sensor's landscape orientation, so
/// feeding them straight into an `AspectRatio` stretches the preview and shifts
/// every normalised coordinate on top of it.
double uprightPreviewAspectRatio(
  CameraController? controller, {
  double fallback = kFallbackPortraitAspectRatio,
}) {
  final value = controller?.value;
  if (value == null || !value.isInitialized) return fallback;
  return uprightAspectRatio(
    previewSize: value.previewSize,
    aspectRatio: value.aspectRatio,
    fallback: fallback,
  );
}

/// Converts a camera preview size or aspect ratio to the upright ratio.
double uprightAspectRatio({
  Size? previewSize,
  double aspectRatio = 0,
  double fallback = kFallbackPortraitAspectRatio,
}) {
  final size = previewSize;
  if (size != null && size.width > 0 && size.height > 0) {
    final shortSide = size.width < size.height ? size.width : size.height;
    final longSide = size.width < size.height ? size.height : size.width;
    return shortSide / longSide;
  }
  if (aspectRatio.isFinite && aspectRatio > 0) {
    return aspectRatio >= 1 ? 1 / aspectRatio : aspectRatio;
  }
  return fallback;
}
