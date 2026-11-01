import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'letterbox.dart';

/// A camera frame that can be sampled in *upright* (display) coordinates.
///
/// The whole app stores geometry in this space: detection boxes, calibration
/// lines and the overlay all agree, regardless of the sensor orientation.
abstract class FramePixelSource {
  /// Upright width (after rotation).
  int get width;

  /// Upright height (after rotation).
  int get height;

  /// Writes RGB bytes for the upright pixel ([x], [y]) into
  /// `out[offset], out[offset+1], out[offset+2]`.
  void writeRgb(int x, int y, Uint8List out, int offset);
}

/// Android `ImageFormatGroup.yuv420` frame with optional rotation.
class Yuv420FrameSource implements FramePixelSource {
  Yuv420FrameSource({
    required this.rawWidth,
    required this.rawHeight,
    required this.yPlane,
    required this.uPlane,
    required this.vPlane,
    required this.yStride,
    required this.uvStride,
    required this.uvPixelStride,
    this.rotationQuarterTurns = 0,
  });

  final int rawWidth;
  final int rawHeight;
  final Uint8List yPlane;
  final Uint8List uPlane;
  final Uint8List vPlane;
  final int yStride;
  final int uvStride;
  final int uvPixelStride;
  final int rotationQuarterTurns;

  int get _turns => rotationQuarterTurns % 4;

  @override
  int get width => _turns.isOdd ? rawHeight : rawWidth;

  @override
  int get height => _turns.isOdd ? rawWidth : rawHeight;

  @override
  void writeRgb(int x, int y, Uint8List out, int offset) {
    final int sx, sy;
    switch (_turns) {
      case 1:
        sx = y;
        sy = rawHeight - 1 - x;
      case 2:
        sx = rawWidth - 1 - x;
        sy = rawHeight - 1 - y;
      case 3:
        sx = rawWidth - 1 - y;
        sy = x;
      default:
        sx = x;
        sy = y;
    }
    if (sx < 0 || sy < 0 || sx >= rawWidth || sy >= rawHeight) {
      out[offset] = 0;
      out[offset + 1] = 0;
      out[offset + 2] = 0;
      return;
    }
    final yIndex = sy * yStride + sx;
    final uvIndex = (sy >> 1) * uvStride + (sx >> 1) * uvPixelStride;
    final luma = yPlane[yIndex];
    final u = uPlane[uvIndex] - 128;
    final v = vPlane[uvIndex] - 128;
    final r = luma + 1.402 * v;
    final g = luma - 0.344136 * u - 0.714136 * v;
    final b = luma + 1.772 * u;
    out[offset] = _clamp8(r);
    out[offset + 1] = _clamp8(g);
    out[offset + 2] = _clamp8(b);
  }
}

/// iOS / desktop BGRA8888 frame with optional rotation.
class BgraFrameSource implements FramePixelSource {
  BgraFrameSource({
    required this.rawWidth,
    required this.rawHeight,
    required this.bytes,
    required this.bytesPerRow,
    this.rotationQuarterTurns = 0,
  });

  final int rawWidth;
  final int rawHeight;
  final Uint8List bytes;
  final int bytesPerRow;
  final int rotationQuarterTurns;

  int get _turns => rotationQuarterTurns % 4;

  @override
  int get width => _turns.isOdd ? rawHeight : rawWidth;

  @override
  int get height => _turns.isOdd ? rawWidth : rawHeight;

  @override
  void writeRgb(int x, int y, Uint8List out, int offset) {
    final int sx, sy;
    switch (_turns) {
      case 1:
        sx = y;
        sy = rawHeight - 1 - x;
      case 2:
        sx = rawWidth - 1 - x;
        sy = rawHeight - 1 - y;
      case 3:
        sx = rawWidth - 1 - y;
        sy = x;
      default:
        sx = x;
        sy = y;
    }
    if (sx < 0 || sy < 0 || sx >= rawWidth || sy >= rawHeight) {
      out[offset] = 0;
      out[offset + 1] = 0;
      out[offset + 2] = 0;
      return;
    }
    final index = sy * bytesPerRow + sx * 4;
    out[offset] = bytes[index + 2];
    out[offset + 1] = bytes[index + 1];
    out[offset + 2] = bytes[index];
  }
}

/// In-memory RGB source used by tests and by the synthetic calibration grid.
class RgbFrameSource implements FramePixelSource {
  RgbFrameSource({
    required this.width,
    required this.height,
    required this.rgb,
  });

  @override
  final int width;

  @override
  final int height;

  /// Row major RGB triples, `width * height * 3` bytes.
  final Uint8List rgb;

  @override
  void writeRgb(int x, int y, Uint8List out, int offset) {
    final index = (y * width + x) * 3;
    out[offset] = rgb[index];
    out[offset + 1] = rgb[index + 1];
    out[offset + 2] = rgb[index + 2];
  }
}

int _clamp8(num value) {
  final rounded = value.round();
  if (rounded < 0) return 0;
  if (rounded > 255) return 255;
  return rounded;
}

/// Fills the model input tensor with a letterboxed, normalised copy of the
/// frame.
class LetterboxPreprocessor {
  const LetterboxPreprocessor({this.padValue = 114});

  /// Fill value for the padded border, matching the YOLO training pipeline.
  final int padValue;

  void fill(
    FramePixelSource source,
    Float32List input,
    LetterboxTransform transform,
  ) {
    final size = transform.inputSize;
    final scratch = Uint8List(3);
    final pad = padValue / 255.0;
    var index = 0;
    for (var y = 0; y < size; y++) {
      final sourceY = ((y - transform.padY) / transform.scale).floor();
      final yValid = sourceY >= 0 && sourceY < source.height;
      for (var x = 0; x < size; x++) {
        final sourceX = ((x - transform.padX) / transform.scale).floor();
        if (yValid && sourceX >= 0 && sourceX < source.width) {
          source.writeRgb(sourceX, sourceY, scratch, 0);
          input[index++] = scratch[0] / 255.0;
          input[index++] = scratch[1] / 255.0;
          input[index++] = scratch[2] / 255.0;
        } else {
          input[index++] = pad;
          input[index++] = pad;
          input[index++] = pad;
        }
      }
    }
  }

  /// Same as [fill] but for quantised (uint8) model inputs.
  void fillBytes(
    FramePixelSource source,
    Uint8List input,
    LetterboxTransform transform, {
    double scale = 1,
    int zeroPoint = 0,
    bool isInt8 = false,
  }) {
    final size = transform.inputSize;
    final scratch = Uint8List(3);
    var index = 0;
    int encode(int value) {
      final quantized = scale == 0
          ? value
          : ((value / 255.0) / scale + zeroPoint).round();
      final minValue = isInt8 ? -128 : 0;
      final maxValue = isInt8 ? 127 : 255;
      return quantized.clamp(minValue, maxValue).toInt().toUnsigned(8);
    }

    for (var y = 0; y < size; y++) {
      final sourceY = ((y - transform.padY) / transform.scale).floor();
      final yValid = sourceY >= 0 && sourceY < source.height;
      for (var x = 0; x < size; x++) {
        final sourceX = ((x - transform.padX) / transform.scale).floor();
        if (yValid && sourceX >= 0 && sourceX < source.width) {
          source.writeRgb(sourceX, sourceY, scratch, 0);
          input[index++] = encode(scratch[0]);
          input[index++] = encode(scratch[1]);
          input[index++] = encode(scratch[2]);
        } else {
          final pad = encode(padValue);
          input[index++] = pad;
          input[index++] = pad;
          input[index++] = pad;
        }
      }
    }
  }
}

/// Creates a compact JPEG of the current frame, written only for violations.
Uint8List encodeSnapshot(
  FramePixelSource source, {
  int targetWidth = 360,
  int quality = 70,
}) {
  final scale = math.min(1.0, targetWidth / source.width);
  final width = math.max(1, (source.width * scale).round());
  final height = math.max(1, (source.height * scale).round());
  final image = img.Image(width: width, height: height);
  final scratch = Uint8List(3);
  for (var y = 0; y < height; y++) {
    final sourceY = (y / scale).floor().clamp(0, source.height - 1);
    for (var x = 0; x < width; x++) {
      final sourceX = (x / scale).floor().clamp(0, source.width - 1);
      source.writeRgb(sourceX, sourceY, scratch, 0);
      image.setPixelRgba(x, y, scratch[0], scratch[1], scratch[2], 255);
    }
  }
  return Uint8List.fromList(img.encodeJpg(image, quality: quality));
}
