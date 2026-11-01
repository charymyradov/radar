/// Aggregated row for the session list.
class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.stationId,
    required this.startedAt,
    required this.totalCount,
    required this.measuredCount,
    required this.violationCount,
    this.calibrationId,
    this.endedAt,
    this.note,
  });

  final String id;
  final String stationId;
  final String? calibrationId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? note;
  final int totalCount;
  final int measuredCount;
  final int violationCount;

  bool get isRunning => endedAt == null;

  Duration durationAt(DateTime now) =>
      (endedAt ?? now).difference(startedAt);

  double? get meanSpeed => null; // computed by the statistics layer
}
