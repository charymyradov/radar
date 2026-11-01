import 'dart:math' as math;

/// Descriptive statistics for a set of measured speeds.
///
/// Everything is computed with plain Dart so it can be unit tested without a
/// database; the SQL layer only feeds it sorted speed values.
class StatsSummary {
  const StatsSummary({
    required this.totalCount,
    required this.measuredCount,
    required this.mean,
    required this.min,
    required this.max,
    required this.p50,
    required this.p85,
  });

  static const StatsSummary empty = StatsSummary(
    totalCount: 0,
    measuredCount: 0,
    mean: null,
    min: null,
    max: null,
    p50: null,
    p85: null,
  );

  /// All counted vehicles (including the ones without a speed measurement).
  final int totalCount;

  /// Vehicles with a usable speed measurement.
  final int measuredCount;

  final double? mean;
  final double? min;
  final double? max;
  final double? p50;
  final double? p85;

  double get measuredRatio =>
      totalCount == 0 ? 0 : measuredCount / totalCount;

  factory StatsSummary.fromSpeeds(
    Iterable<double> speeds, {
    int? totalCount,
  }) {
    final values = speeds.where((v) => v.isFinite).toList()..sort();
    if (values.isEmpty) {
      return StatsSummary(
        totalCount: totalCount ?? 0,
        measuredCount: 0,
        mean: null,
        min: null,
        max: null,
        p50: null,
        p85: null,
      );
    }
    final sum = values.fold<double>(0, (acc, v) => acc + v);
    return StatsSummary(
      totalCount: totalCount ?? values.length,
      measuredCount: values.length,
      mean: sum / values.length,
      min: values.first,
      max: values.last,
      p50: percentileSorted(values, 50),
      p85: percentileSorted(values, 85),
    );
  }
}

/// 85th percentile with linear interpolation between the two closest ranks.
///
/// `index = p / 100 * (n - 1)`, then `value[floor] + frac * (value[ceil] -
/// value[floor])` - the same definition used by Excel's `PERCENTILE.INC` and
/// NumPy's default. [sorted] must be ascending.
double percentileSorted(List<double> sorted, double p) {
  if (sorted.isEmpty) {
    throw ArgumentError.value(sorted, 'sorted', 'must not be empty');
  }
  if (p <= 0) return sorted.first;
  if (p >= 100) return sorted.last;
  final rank = p / 100 * (sorted.length - 1);
  final lower = rank.floor();
  final upper = rank.ceil();
  if (lower == upper) return sorted[lower];
  final fraction = rank - lower;
  return sorted[lower] + (sorted[upper] - sorted[lower]) * fraction;
}

/// Convenience wrapper that sorts a copy first.
double percentile(Iterable<double> values, double p) {
  final sorted = values.toList()..sort();
  return percentileSorted(sorted, p);
}

/// One bucket of the 5 km/h speed histogram.
class HistogramBucket {
  const HistogramBucket({
    required this.lowerBound,
    required this.upperBound,
    required this.count,
  });

  final double lowerBound;
  final double upperBound;
  final int count;

  String get label => '${lowerBound.round()}-${upperBound.round()}';
}

/// Builds a fixed width histogram, e.g. `0-5, 5-10, ... 125-130`.
///
/// [values] are the measured speeds; values above [maxSpeed] are folded into
/// the last bucket so nothing silently disappears from the chart.
List<HistogramBucket> buildHistogram(
  Iterable<double> values, {
  double bucketSize = 5,
  double maxSpeed = 200,
}) {
  if (bucketSize <= 0) {
    throw ArgumentError.value(bucketSize, 'bucketSize', 'must be positive');
  }
  final bucketCount = (maxSpeed / bucketSize).ceil();
  final counts = List<int>.filled(bucketCount, 0);
  for (final value in values) {
    if (!value.isFinite || value < 0) continue;
    var index = (value / bucketSize).floor();
    if (index >= bucketCount) index = bucketCount - 1;
    counts[index] += 1;
  }
  return List<HistogramBucket>.generate(
    bucketCount,
    (i) => HistogramBucket(
      lowerBound: i * bucketSize,
      upperBound: (i + 1) * bucketSize,
      count: counts[i],
    ),
  );
}

/// Mean of a list, returning null for an empty input.
double? meanOf(Iterable<double> values) {
  var sum = 0.0;
  var count = 0;
  for (final value in values) {
    if (!value.isFinite) continue;
    sum += value;
    count += 1;
  }
  return count == 0 ? null : sum / count;
}

/// Vehicles per hour for a session lasting [elapsed]; 0 for zero duration.
double vehiclesPerHour(int count, Duration elapsed) {
  final seconds = elapsed.inMilliseconds / 1000;
  if (seconds <= 0) return 0;
  return count / seconds * 3600;
}

/// Rounds a speed for display, never returning `-0.0`.
double roundedSpeed(double value, {int decimals = 1}) {
  final factor = math.pow(10, decimals).toDouble();
  final rounded = (value * factor).roundToDouble() / factor;
  return rounded == 0 ? 0 : rounded;
}
