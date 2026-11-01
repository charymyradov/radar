import '../../../domain/models/enums.dart';
import '../../../domain/stats/statistics.dart';

/// Time window used by the statistics screen.
class StatsQuery {
  const StatsQuery({
    this.from,
    this.to,
    this.sessionId,
    this.label = '',
  });

  final DateTime? from;
  final DateTime? to;
  final String? sessionId;
  final String label;

  bool get isAllTime => from == null && to == null && sessionId == null;

  StatsQuery copyWith({
    DateTime? from,
    DateTime? to,
    String? sessionId,
    String? label,
    bool clearRange = false,
  }) =>
      StatsQuery(
        from: clearRange ? null : (from ?? this.from),
        to: clearRange ? null : (to ?? this.to),
        sessionId: clearRange ? null : (sessionId ?? this.sessionId),
        label: label ?? this.label,
      );

  /// Rolls the window back by its own length, used for the "compare" card.
  StatsQuery previousPeriod() {
    if (from == null || to == null) return this;
    final length = to!.difference(from!);
    return StatsQuery(
      from: from!.subtract(length),
      to: from,
      label: 'previous',
    );
  }
}

/// One bar of a time series.
class TimeBucket {
  const TimeBucket({required this.key, required this.count});

  /// Hour of day (`0..23`) or day key (`yyyy-MM-dd`).
  final String key;
  final int count;
}

/// Everything the statistics screen shows for one window.
class PeriodStats {
  const PeriodStats({
    required this.totalCount,
    required this.measuredCount,
    required this.violationCount,
    required this.summary,
    required this.hourly,
    required this.daily,
    required this.classCounts,
    required this.directionCounts,
    required this.histogram,
  });

  static const PeriodStats empty = PeriodStats(
    totalCount: 0,
    measuredCount: 0,
    violationCount: 0,
    summary: StatsSummary.empty,
    hourly: [],
    daily: [],
    classCounts: {},
    directionCounts: {},
    histogram: [],
  );

  final int totalCount;
  final int measuredCount;
  final int violationCount;
  final StatsSummary summary;

  /// 24 entries, `00`..`23` in local time.
  final List<TimeBucket> hourly;

  /// Ascending day buckets in local time.
  final List<TimeBucket> daily;

  final Map<VehicleClass, int> classCounts;
  final Map<TravelDirection, int> directionCounts;
  final List<HistogramBucket> histogram;

  bool get isEmpty => totalCount == 0;

  double? get meanSpeed => summary.mean;
  double? get maxSpeed => summary.max;
  double? get minSpeed => summary.min;
  double? get p85 => summary.p85;

  /// The hour with the largest number of vehicles, if any.
  TimeBucket? get busiestHour {
    TimeBucket? best;
    for (final bucket in hourly) {
      if (best == null || bucket.count > best.count) best = bucket;
    }
    return best != null && best.count > 0 ? best : null;
  }
}
