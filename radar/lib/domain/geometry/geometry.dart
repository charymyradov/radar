import 'dart:math' as math;

/// A point in normalised image space: both coordinates are in `[0, 1]`.
class NormPoint {
  const NormPoint(this.x, this.y);

  final double x;
  final double y;

  NormPoint lerp(NormPoint other, double t) =>
      NormPoint(x + (other.x - x) * t, y + (other.y - y) * t);

  double distanceTo(NormPoint other) {
    final dx = other.x - x;
    final dy = other.y - y;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool operator ==(Object other) =>
      other is NormPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'NormPoint(${x.toStringAsFixed(4)}, '
      '${y.toStringAsFixed(4)})';
}

/// An axis aligned box in normalised image space.
///
/// The coordinate system is the *raw* camera image (sensor orientation), which
/// is what the detection isolate reports. Keeping one space for detections,
/// calibration lines and rendering avoids a whole class of mirroring bugs.
class BoundingBox {
  const BoundingBox(this.left, this.top, this.right, this.bottom);

  factory BoundingBox.fromCorners(double x1, double y1, double x2, double y2) {
    return BoundingBox(
      math.min(x1, x2),
      math.min(y1, y2),
      math.max(x1, x2),
      math.max(y1, y2),
    );
  }

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;
  double get area => math.max(0, width) * math.max(0, height);
  NormPoint get center =>
      NormPoint((left + right) / 2, (top + bottom) / 2);

  /// The box shifted by a normalised delta (used for motion prediction).
  BoundingBox translate(double dx, double dy) =>
      BoundingBox(left + dx, top + dy, right + dx, bottom + dy);

  BoundingBox clampUnit() => BoundingBox(
        left.clamp(0.0, 1.0),
        top.clamp(0.0, 1.0),
        right.clamp(0.0, 1.0),
        bottom.clamp(0.0, 1.0),
      );

  double intersectionArea(BoundingBox other) {
    final x1 = math.max(left, other.left);
    final y1 = math.max(top, other.top);
    final x2 = math.min(right, other.right);
    final y2 = math.min(bottom, other.bottom);
    if (x2 <= x1 || y2 <= y1) return 0;
    return (x2 - x1) * (y2 - y1);
  }

  double iou(BoundingBox other) {
    final intersection = intersectionArea(other);
    if (intersection <= 0) return 0;
    final union = area + other.area - intersection;
    if (union <= 0) return 0;
    return intersection / union;
  }

  @override
  bool operator ==(Object other) =>
      other is BoundingBox &&
      other.left == left &&
      other.top == top &&
      other.right == right &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  String toString() => 'BoundingBox(${left.toStringAsFixed(3)}, '
      '${top.toStringAsFixed(3)}, ${right.toStringAsFixed(3)}, '
      '${bottom.toStringAsFixed(3)})';
}

/// Result of a segment crossing test.
class LineCrossing {
  const LineCrossing({
    required this.fraction,
    required this.sign,
    required this.point,
  });

  /// Position of the crossing along the movement segment, in `[0, 1]`.
  final double fraction;

  /// `+1` when the object moved from the negative to the positive side of the
  /// line, `-1` for the opposite direction.
  final int sign;

  final NormPoint point;
}

/// A line drawn over the camera image, stored in normalised coordinates.
class LineSegment {
  const LineSegment(this.a, this.b);

  final NormPoint a;
  final NormPoint b;

  double get length => a.distanceTo(b);

  /// Segments shorter than 2% of the image diagonal are considered unset.
  bool get isValid => length >= 0.02;

  /// Signed area of the triangle (a, b, point); its sign identifies the side
  /// of the infinite line the point lies on.
  double signedSide(NormPoint p) =>
      (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);

  /// Tests whether a point moved from one side of this segment to the other
  /// between two samples.
  ///
  /// Returns null when both samples are on the same side, when the movement is
  /// degenerate, or when the intersection happens outside the segment (with a
  /// small tolerance so objects crossing exactly at an endpoint still count).
  LineCrossing? crossing(
    NormPoint from,
    NormPoint to, {
    double endpointTolerance = 0.02,
  }) {
    if (!isValid) return null;
    final s0 = signedSide(from);
    final s1 = signedSide(to);

    final bool crossed;
    if (s0 <= 0 && s1 > 0) {
      crossed = true;
    } else if (s0 >= 0 && s1 < 0) {
      crossed = true;
    } else {
      crossed = false;
    }
    if (!crossed) return null;

    final denominator = s0 - s1;
    if (denominator == 0) return null;
    final t = (s0 / denominator).clamp(0.0, 1.0);
    final point = from.lerp(to, t);

    // Project the intersection onto the segment to verify it lies on it.
    final abx = b.x - a.x;
    final aby = b.y - a.y;
    final lengthSquared = abx * abx + aby * aby;
    if (lengthSquared == 0) return null;
    final u = ((point.x - a.x) * abx + (point.y - a.y) * aby) / lengthSquared;
    if (u < -endpointTolerance || u > 1 + endpointTolerance) return null;

    return LineCrossing(
      fraction: t,
      sign: s1 > 0 ? 1 : -1,
      point: point,
    );
  }

  /// Linear interpolation used by the calibration editor.
  LineSegment withA(NormPoint point) => LineSegment(point, b);
  LineSegment withB(NormPoint point) => LineSegment(a, point);

  @override
  bool operator ==(Object other) =>
      other is LineSegment && other.a == a && other.b == b;

  @override
  int get hashCode => Object.hash(a, b);

  @override
  String toString() => 'LineSegment($a -> $b)';
}

/// Two calibration lines plus the real world distance between them.
class CalibrationGeometry {
  const CalibrationGeometry({
    required this.lineA,
    required this.lineB,
    required this.distanceMeters,
  });

  final LineSegment lineA;
  final LineSegment lineB;
  final double distanceMeters;

  bool get isValid =>
      lineA.isValid && lineB.isValid && distanceMeters > 0.1;

  /// Rotates the whole geometry by a number of quarter turns, used when the
  /// camera image orientation changes between sessions.
  CalibrationGeometry rotated(int quarterTurns) {
    NormPoint rotate(NormPoint p) {
      switch (quarterTurns % 4) {
        case 1:
          return NormPoint(1 - p.y, p.x);
        case 2:
          return NormPoint(1 - p.x, 1 - p.y);
        case 3:
          return NormPoint(p.y, 1 - p.x);
        default:
          return p;
      }
    }

    return CalibrationGeometry(
      lineA: LineSegment(rotate(lineA.a), rotate(lineA.b)),
      lineB: LineSegment(rotate(lineB.a), rotate(lineB.b)),
      distanceMeters: distanceMeters,
    );
  }
}
