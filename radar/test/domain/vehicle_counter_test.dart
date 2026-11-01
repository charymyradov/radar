import 'package:flutter_test/flutter_test.dart';
import 'package:radar/domain/models/enums.dart';
import 'package:radar/domain/counting/vehicle_counter.dart';
import 'package:radar/domain/geometry/geometry.dart';
import 'package:radar/domain/models/detection_models.dart';

/// 20 metres between a line at 40% height and one at 60% height.
const CalibrationGeometry geometry = CalibrationGeometry(
  lineA: LineSegment(NormPoint(0, 0.4), NormPoint(1, 0.4)),
  lineB: LineSegment(NormPoint(0, 0.6), NormPoint(1, 0.6)),
  distanceMeters: 20,
);

const int frameInterval = 100000; // 100 ms -> 10 fps
const int startTs = 1000000;

/// Vertical positions from 0.20 to 0.65 in 0.025 steps. Line A (0.40) is hit
/// exactly on frame 8, line B (0.60) on frame 16, i.e. 800 ms apart.
List<double> downwardTrack() =>
    List.generate(19, (i) => 0.20 + i * 0.025);

class Harness {
  Harness({
    CalibrationGeometry calibration = geometry,
    CounterConfig? config,
  }) : counter = VehicleCounter(
          calibration: calibration,
          idGenerator: _IdFactory().next,
          config: config,
        );

  final VehicleCounter counter;
  int _frame = 0;
  final List<CountedVehicle> counted = [];
  final List<SpeedMeasurement> measured = [];

  FrameOutcome step(double cx, double cy, {int classId = 2, double conf = 0.9}) {
    final ts = startTs + _frame * frameInterval;
    _frame += 1;
    final outcome = counter.process(
      detections: [
        Detection(
          box: BoundingBox(cx - 0.06, cy - 0.06, cx + 0.06, cy + 0.06),
          classId: classId,
          confidence: conf,
        ),
      ],
      timestampMicros: ts,
      nowUtc: DateTime.utc(2026, 1, 1, 12, 0, 0)
          .add(Duration(microseconds: ts - startTs)),
    );
    counted.addAll(outcome.counted);
    measured.addAll(outcome.measured);
    return outcome;
  }

  /// Feeds an empty frame (no detections).
  FrameOutcome emptyFrame() {
    final ts = startTs + _frame * frameInterval;
    _frame += 1;
    final outcome = counter.process(
      detections: const [],
      timestampMicros: ts,
      nowUtc: DateTime.utc(2026, 1, 1),
    );
    counted.addAll(outcome.counted);
    measured.addAll(outcome.measured);
    return outcome;
  }
}

class _IdFactory {
  int _value = 0;
  String next() => 'evt-${_value++}';
}

void main() {
  group('VehicleCounter counting', () {
    test('counts once when line A is crossed and measures speed at line B', () {
      final h = Harness();
      for (final y in downwardTrack()) {
        h.step(0.5, y);
      }
      expect(h.counted, hasLength(1));
      expect(h.measured, hasLength(1));
      // 20 m in 800 ms -> 25 m/s -> 90 km/h.
      expect(h.measured.single.speedKmh, closeTo(90, 0.6));
      expect(h.counted.single.direction, TravelDirection.inbound);
      expect(h.measured.single.eventId, h.counted.single.id);
    });

    test('the opposite direction is reported as outbound', () {
      final h = Harness();
      for (final y in downwardTrack().reversed) {
        h.step(0.5, y);
      }
      expect(h.counted, hasLength(1));
      expect(h.counted.single.direction, TravelDirection.outbound);
      expect(h.measured.single.speedKmh, closeTo(90, 0.6));
    });

    test('flipDirection swaps the reported directions', () {
      final h = Harness(
        config: const CounterConfig(distanceMeters: 20, flipDirection: true),
      );
      for (final y in downwardTrack()) {
        h.step(0.5, y);
      }
      expect(h.counted.single.direction, TravelDirection.outbound);
    });

    test('a vehicle that never reaches line B is still counted (null speed)',
        () {
      final h = Harness();
      for (final y in downwardTrack().take(10)) {
        h.step(0.5, y);
      }
      for (var i = 0; i < 15; i++) {
        h.emptyFrame();
      }
      expect(h.counted, hasLength(1));
      expect(h.counted.single.speedKmh, isNull);
      expect(h.measured, isEmpty);
    });

    test('a track younger than 3 frames is never counted', () {
      final h = Harness();
      // Two frames only, both already past line A.
      h.step(0.5, 0.395);
      h.step(0.5, 0.425);
      expect(h.counted, isEmpty);
    });

    test('a vehicle that appears between the lines is not counted', () {
      final h = Harness();
      for (final y in downwardTrack().skip(10)) {
        h.step(0.5, y);
      }
      expect(h.counted, isEmpty);
      expect(h.measured, isEmpty);
    });

    test('a single track is counted at most once even when it turns back', () {
      final h = Harness();
      final down = downwardTrack();
      final ys = [
        ...down,
        ...down.reversed.where((y) => y >= 0.30),
      ];
      for (final y in ys) {
        h.step(0.5, y);
      }
      expect(h.counted, hasLength(1));
      expect(h.measured, hasLength(1));
    });

    test('implausible speed is rejected but the vehicle is still counted', () {
      final h = Harness(
        calibration: const CalibrationGeometry(
          lineA: LineSegment(NormPoint(0, 0.4), NormPoint(1, 0.4)),
          lineB: LineSegment(NormPoint(0, 0.6), NormPoint(1, 0.6)),
          distanceMeters: 1000,
        ),
      );
      for (final y in downwardTrack()) {
        h.step(0.5, y);
      }
      expect(h.counted, hasLength(1));
      // 1000 m in 0.8 s is 4500 km/h, above the sanity cap.
      expect(h.measured, isEmpty);
    });

    test('a vehicle that stops between the lines yields no speed', () {
      final h = Harness(
        config: const CounterConfig(
          distanceMeters: 20,
          speedSanity: SpeedSanityConfig(maxCrossingSpan: Duration(seconds: 1)),
        ),
      );
      for (final y in downwardTrack()) {
        h.step(0.5, y);
      }
      expect(h.counted, hasLength(1));
      // 800 ms is inside the 1 s window, so this one still measures.
      expect(h.measured, hasLength(1));

      final slow = Harness(
        config: const CounterConfig(
          distanceMeters: 20,
          speedSanity: SpeedSanityConfig(maxCrossingSpan: Duration(seconds: 1)),
        ),
      );
      // Same geometry but 2 s per line pair (20 frames of 100 ms).
      var y = 0.20;
      for (var i = 0; i < 40; i++) {
        slow.step(0.5, y);
        y += 0.0125;
      }
      expect(slow.counted, hasLength(1));
      expect(slow.measured, isEmpty);
    });

    test('class comes from the mapped COCO id', () {
      final h = Harness();
      for (final y in downwardTrack().take(10)) {
        h.step(0.3, y, classId: 3);
      }
      expect(h.counted.single.vehicleClass, VehicleClass.motorcycle);
      // Second vehicle in another lane.
      for (final y in downwardTrack().take(10)) {
        h.step(0.7, y, classId: 5);
      }
      expect(h.counted.last.vehicleClass, VehicleClass.bus);
    });

    test('the live overlay receives the measured speed', () {
      final h = Harness();
      FrameOutcome? last;
      for (final y in downwardTrack()) {
        last = h.step(0.5, y);
      }
      expect(last!.tracks.single.speedKmh, isNotNull);
      expect(last.tracks.single.speedKmh, closeTo(90, 0.6));
    });

    test('reset clears tracking state between sessions', () {
      final h = Harness();
      for (final y in downwardTrack().take(12)) {
        h.step(0.5, y);
      }
      h.counter.reset();
      final outcome = h.step(0.5, 0.20);
      expect(outcome.tracks.single.id, 1);
      expect(outcome.tracks.single.confirmed, isFalse);
    });
  });
}

