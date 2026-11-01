import 'package:flutter_test/flutter_test.dart';
import 'package:radar/domain/geometry/geometry.dart';

void main() {
  group('LineSegment.crossing', () {
    // Horizontal line across the middle of the image, left -> right.
    const line = LineSegment(NormPoint(0, 0.5), NormPoint(1, 0.5));

    test('detects a top to bottom crossing inside the segment', () {
      final crossing = line.crossing(
        const NormPoint(0.5, 0.4),
        const NormPoint(0.5, 0.6),
      );
      expect(crossing, isNotNull);
      // Positive sign == moving towards increasing y (downwards on screen).
      expect(crossing!.sign, 1);
      expect(crossing.fraction, closeTo(0.5, 1e-9));
      expect(crossing.point.y, closeTo(0.5, 1e-9));
    });

    test('reports the opposite sign for a bottom to top crossing', () {
      final crossing = line.crossing(
        const NormPoint(0.5, 0.6),
        const NormPoint(0.5, 0.4),
      );
      expect(crossing!.sign, -1);
    });

    test('ignores movement that stays on one side', () {
      expect(
        line.crossing(const NormPoint(0.2, 0.1), const NormPoint(0.8, 0.2)),
        isNull,
      );
    });

    test('ignores crossings outside the drawn segment', () {
      // Vertical line is only in the left half of the image.
      const shortLine = LineSegment(NormPoint(0.1, 0), NormPoint(0.2, 1));
      expect(
        shortLine.crossing(const NormPoint(0.9, 0.4), const NormPoint(0.9, 0.6)),
        isNull,
      );
    });

    test('treats an exactly-on-line start as a crossing when moving away', () {
      final crossing = line.crossing(
        const NormPoint(0.5, 0.5),
        const NormPoint(0.5, 0.6),
      );
      expect(crossing, isNotNull);
      expect(crossing!.sign, 1);
    });

    test('a segment that is too short is invalid', () {
      const degenerate =
          LineSegment(NormPoint(0.5, 0.5), NormPoint(0.5001, 0.5));
      expect(degenerate.isValid, isFalse);
      expect(
        degenerate.crossing(const NormPoint(0, 0), const NormPoint(1, 1)),
        isNull,
      );
    });
  });

  group('BoundingBox.iou', () {
    test('identical boxes have IoU 1', () {
      const box = BoundingBox(0.1, 0.1, 0.3, 0.3);
      expect(box.iou(box), 1.0);
    });

    test('disjoint boxes have IoU 0', () {
      const a = BoundingBox(0, 0, 0.1, 0.1);
      const b = BoundingBox(0.5, 0.5, 0.6, 0.6);
      expect(a.iou(b), 0);
    });

    test('half overlap yields the expected value', () {
      const a = BoundingBox(0, 0, 0.2, 0.2);
      const b = BoundingBox(0.1, 0, 0.3, 0.2);
      // intersection 0.1*0.2 = .02, union .04 + .04 - .02 = .06
      expect(a.iou(b), closeTo(0.02 / 0.06, 1e-9));
    });
  });

  group('CalibrationGeometry.rotated', () {
    const geometry = CalibrationGeometry(
      lineA: LineSegment(NormPoint(0, 0.5), NormPoint(1, 0.5)),
      lineB: LineSegment(NormPoint(0, 0.7), NormPoint(1, 0.7)),
      distanceMeters: 10,
    );

    test('four quarter turns are a no-op', () {
      final rotated = geometry.rotated(4);
      expect(rotated.lineA, geometry.lineA);
      expect(rotated.distanceMeters, geometry.distanceMeters);
    });

    test('rotating by one turn keeps the geometry valid', () {
      final rotated = geometry.rotated(1);
      expect(rotated.lineA.isValid, isTrue);
      // A horizontal line becomes vertical.
      expect(rotated.lineA.a.x, closeTo(rotated.lineA.b.x, 1e-9));
    });
  });
}
