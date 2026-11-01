import 'package:flutter_test/flutter_test.dart';
import 'package:radar/domain/stats/statistics.dart';

void main() {
  group('percentileSorted (p85)', () {
    test('linear interpolation between ranks', () {
      final values = [10.0, 20.0, 30.0, 40.0, 50.0];
      // rank = 0.85 * 4 = 3.4 -> 40 + 0.4 * 10 = 44
      expect(percentileSorted(values, 85), closeTo(44, 1e-9));
      expect(percentileSorted(values, 50), closeTo(30, 1e-9));
      expect(percentileSorted(values, 0), 10);
      expect(percentileSorted(values, 100), 50);
    });

    test('matches the Excel PERCENTILE.INC definition', () {
      final values = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
      // rank = 0.85 * 9 = 7.65 -> 8 + 0.65 * 1 = 8.65
      expect(percentileSorted(values, 85), closeTo(8.65, 1e-9));
    });

    test('single value returns that value for every percentile', () {
      expect(percentileSorted([42.0], 85), 42);
      expect(percentileSorted([42.0], 0), 42);
      expect(percentileSorted([42.0], 100), 42);
    });

    test('empty input throws', () {
      expect(() => percentileSorted(const [], 85), throwsArgumentError);
    });

    test('unsorted input is sorted by the convenience wrapper', () {
      expect(percentile([50, 10, 30, 20, 40], 85), closeTo(44, 1e-9));
    });
  });

  group('StatsSummary', () {
    test('computes mean, min, max, p50 and p85', () {
      final summary = StatsSummary.fromSpeeds(
        [10, 20, 30, 40, 50],
        totalCount: 7,
      );
      expect(summary.totalCount, 7);
      expect(summary.measuredCount, 5);
      expect(summary.mean, 30);
      expect(summary.min, 10);
      expect(summary.max, 50);
      expect(summary.p50, 30);
      expect(summary.p85, closeTo(44, 1e-9));
      expect(summary.measuredRatio, closeTo(5 / 7, 1e-9));
    });

    test('handles an empty list', () {
      final summary = StatsSummary.fromSpeeds(const [], totalCount: 3);
      expect(summary.totalCount, 3);
      expect(summary.measuredCount, 0);
      expect(summary.mean, isNull);
      expect(summary.p85, isNull);
    });
  });

  group('buildHistogram', () {
    test('buckets speeds in 5 km/h steps', () {
      final buckets = buildHistogram(
        [1, 4.9, 5, 12, 63.2, 199],
        bucketSize: 5,
        maxSpeed: 30,
      );
      expect(buckets, hasLength(6));
      expect(buckets[0].count, 2); // 1 and 4.9
      expect(buckets[1].count, 1); // 5
expect(buckets[2].count, 1); // 12
      expect(buckets.last.count, 2); // 63.2 and 199 folded into the last bucket
      expect(buckets[0].label, '0-5');
    });

    test('empty input produces zeroed buckets', () {
      final buckets = buildHistogram(const [], maxSpeed: 10);
      expect(buckets, hasLength(2));
      expect(buckets.every((b) => b.count == 0), isTrue);
    });
  });

  group('vehiclesPerHour', () {
    test('scales counts to a one hour window', () {
      expect(vehiclesPerHour(10, const Duration(minutes: 30)), 20);
      expect(vehiclesPerHour(0, Duration.zero), 0);
    });
  });
}
