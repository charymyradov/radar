import '../../../domain/models/enums.dart';

/// A counted vehicle as shown in the history screens.
class VehicleEvent {
  const VehicleEvent({
    required this.id,
    required this.sessionId,
    required this.countedAt,
    required this.vehicleClass,
    required this.direction,
    required this.confidence,
    required this.trackId,
    required this.isValid,
    required this.isDeleted,
    this.calibrationId,
    this.speedKmh,
    this.speedMeasuredAt,
    this.violationStatus,
    this.violationImagePath,
  });

  final String id;
  final String sessionId;
  final String? calibrationId;
  final DateTime countedAt;
  final DateTime? speedMeasuredAt;
  final VehicleClass vehicleClass;
  final TravelDirection direction;
  final double? speedKmh;
  final double confidence;
  final int trackId;
  final bool isValid;
  final bool isDeleted;
  final ViolationStatus? violationStatus;
  final String? violationImagePath;

  bool get hasSpeed => speedKmh != null;
  bool get isViolation => violationStatus != null;

  /// Excluded from statistics either because the user flagged it as a wrong
  /// detection or because it was soft deleted.
  bool get excludedFromStats => !isValid || isDeleted;
}

/// Filters accepted by the history list.
class EventFilter {
  const EventFilter({
    this.sessionId,
    this.from,
    this.to,
    this.classes = const {},
    this.directions = const {},
    this.minSpeedKmh,
    this.maxSpeedKmh,
    this.onlyMeasured = false,
    this.includeInvalid = false,
    this.includeDeleted = false,
  });

  final String? sessionId;
  final DateTime? from;
  final DateTime? to;
  final Set<VehicleClass> classes;
  final Set<TravelDirection> directions;
  final double? minSpeedKmh;
  final double? maxSpeedKmh;
  final bool onlyMeasured;
  final bool includeInvalid;
  final bool includeDeleted;

  bool get isEmpty =>
      sessionId == null &&
      from == null &&
      to == null &&
      classes.isEmpty &&
      directions.isEmpty &&
      minSpeedKmh == null &&
      maxSpeedKmh == null &&
      !onlyMeasured &&
      !includeInvalid &&
      !includeDeleted;

  EventFilter copyWith({
    String? sessionId,
    DateTime? from,
    DateTime? to,
    Set<VehicleClass>? classes,
    Set<TravelDirection>? directions,
    double? minSpeedKmh,
    double? maxSpeedKmh,
    bool? onlyMeasured,
    bool? includeInvalid,
    bool? includeDeleted,
    bool clearSession = false,
    bool clearFrom = false,
    bool clearTo = false,
    bool clearSpeedRange = false,
  }) {
    return EventFilter(
      sessionId: clearSession ? null : (sessionId ?? this.sessionId),
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
      classes: classes ?? this.classes,
      directions: directions ?? this.directions,
      minSpeedKmh:
          clearSpeedRange ? null : (minSpeedKmh ?? this.minSpeedKmh),
      maxSpeedKmh:
          clearSpeedRange ? null : (maxSpeedKmh ?? this.maxSpeedKmh),
      onlyMeasured: onlyMeasured ?? this.onlyMeasured,
      includeInvalid: includeInvalid ?? this.includeInvalid,
      includeDeleted: includeDeleted ?? this.includeDeleted,
    );
  }
}
