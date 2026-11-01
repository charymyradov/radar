import 'package:radar/domain/models/enums.dart';

import '../geometry/geometry.dart';

/// A single object detected in one frame, in normalised raw-image space.
class Detection {
  const Detection({
    required this.box,
    required this.classId,
    required this.confidence,
  });

  final BoundingBox box;
  final int classId;
  final double confidence;

  @override
  String toString() =>
      'Detection(class: $classId, conf: ${confidence.toStringAsFixed(2)}, '
      '$box)';
}

/// A tracked object reported to the UI for drawing.
class TrackedObject {
  const TrackedObject({
    required this.id,
    required this.box,
    required this.vehicleClass,
    required this.confidence,
    required this.confirmed,
    required this.missingFrames,
    this.speedKmh,
  });

  final int id;
  final BoundingBox box;
  final VehicleClass vehicleClass;
  final double confidence;

  /// False while the track is still tentative (fewer than `minHits` matches).
  final bool confirmed;
  final int missingFrames;

  /// Measured speed once the vehicle crossed the second line.
  final double? speedKmh;

  @override
  String toString() => 'TrackedObject(#$id, $vehicleClass, $box)';
}

/// A vehicle that crossed line A and has therefore been counted.
class CountedVehicle {
  const CountedVehicle({
    required this.id,
    required this.trackId,
    required this.countedAtUtc,
    required this.vehicleClass,
    required this.direction,
    required this.speedKmh,
    required this.confidence,
  });

  /// Stable UUID shared with the database row (also used for later speed
  /// updates of the same event).
  final String id;
  final int trackId;
  final DateTime countedAtUtc;
  final VehicleClass vehicleClass;
  final TravelDirection direction;

  /// Null when the vehicle never made it across line B (or the measurement
  /// failed sanity checks). The vehicle is still counted.
  final double? speedKmh;
  final double confidence;
}

/// A late speed measurement belonging to an already counted vehicle.
class SpeedMeasurement {
  const SpeedMeasurement({
    required this.eventId,
    required this.trackId,
    required this.speedKmh,
    required this.measuredAtUtc,
  });

  final String eventId;
  final int trackId;
  final double speedKmh;
  final DateTime measuredAtUtc;
}

/// Everything the counter produced for one processed frame.
class FrameOutcome {
  const FrameOutcome({
    required this.tracks,
    required this.counted,
    required this.measured,
  });

  static const FrameOutcome empty =
      FrameOutcome(tracks: [], counted: [], measured: []);

  final List<TrackedObject> tracks;
  final List<CountedVehicle> counted;
  final List<SpeedMeasurement> measured;

  bool get isEmpty => counted.isEmpty && measured.isEmpty;
}

