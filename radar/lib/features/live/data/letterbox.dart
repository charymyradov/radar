import 'dart:math' as math;

/// Maps between the model input (letterboxed square) and the upright camera
/// image, in normalised image coordinates.
///
/// Kept pure so the mapping can be unit tested without a model.
class LetterboxTransform {
  const LetterboxTransform({
    required this.sourceWidth,
    required this.sourceHeight,
    required this.inputSize,
    required this.scale,
    required this.padX,
    required this.padY,
  });

  /// Fits [sourceWidth] x [sourceHeight] into a square of [inputSize] keeping
  /// the aspect ratio (centre padded).
  factory LetterboxTransform.fit({
    required int sourceWidth,
    required int sourceHeight,
    required int inputSize,
  }) {
    if (sourceWidth <= 0 || sourceHeight <= 0) {
      throw ArgumentError('source dimensions must be positive');
    }
    final scale = math.min(
      inputSize / sourceWidth,
      inputSize / sourceHeight,
    );
    final scaledWidth = sourceWidth * scale;
    final scaledHeight = sourceHeight * scale;
    return LetterboxTransform(
      sourceWidth: sourceWidth,
      sourceHeight: sourceHeight,
      inputSize: inputSize,
      scale: scale,
      padX: (inputSize - scaledWidth) / 2,
      padY: (inputSize - scaledHeight) / 2,
    );
  }

  final int sourceWidth;
  final int sourceHeight;
  final int inputSize;
  final double scale;
  final double padX;
  final double padY;

  /// Model input pixel -> normalised upright image coordinate.
  double xToNormalised(double x) =>
      ((x - padX) / scale / sourceWidth).clamp(0.0, 1.0);

  double yToNormalised(double y) =>
      ((y - padY) / scale / sourceHeight).clamp(0.0, 1.0);

  /// Normalised upright coordinate -> model input pixel.
  double normalisedToX(double x) => padX + x * sourceWidth * scale;
  double normalisedToY(double y) => padY + y * sourceHeight * scale;

  @override
  String toString() => 'LetterboxTransform(${sourceWidth}x$sourceHeight -> '
      '$inputSize, scale: ${scale.toStringAsFixed(3)})';
}
