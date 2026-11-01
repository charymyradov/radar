import '../geometry/geometry.dart';
import '../models/detection_models.dart';
import '../models/enums.dart';
import '../tracking/iou_tracker.dart';

/// Generates the UUIDs attached to counted vehicles; injectable for tests.
typedef IdGenerator = String Function();

/// Sanity bounds applied to every measured speed. Vehicles outside the window
/// are still counted, but with `speedKmh == null` so bad measurements never
/// pollute the statistics.
class SpeedSanityConfig {
  const SpeedSanityConfig({
    this.minSpeedKmh = 1.0,
    this.maxSpeedKmh = 300.0,
    this.minCrossingSpan = const Duration(milliseconds: 120),
    this.maxCrossingSpan = const Duration(seconds: 8),
  });

  final double minSpeedKmh;
  final double maxSpeedKmh;

  /// Faster than this means the two crossings were effectively simultaneous
  /// and the measurement is noise.
  final Duration minCrossingSpan;

  /// Slower than this means the vehicle stopped between the lines; the
  /// average would not be meaningful.
  final Duration maxCrossingSpan;
}

/// Everything needed to turn detections into counted, speed measured vehicles.
class CounterConfig {
  const CounterConfig({
    required this.distanceMeters,
    this.flipDirection = false,
    this.speedSanity = const SpeedSanityConfig(),
  });

  /// Real world distance between line A and line B, in metres.
  final double distanceMeters;

  /// Swaps inbound/outbound when the camera is mounted facing the other way.
  final bool flipDirection;

  final SpeedSanityConfig speedSanity;
}

/// Converts the tracker output into counted vehicles + speed measurements.
///
/// The counter is deliberately independent of Flutter and of the DB: it is a
/// pure state machine that is unit tested frame by frame.
class VehicleCounter {
  VehicleCounter({
    required CalibrationGeometry calibration,
    required this.idGenerator,
    CounterConfig? config,
    TrackerConfig trackerConfig = const TrackerConfig(),
    IoUTracker? tracker,
  })  : geometry = calibration,
        config = config ??
            CounterConfig(distanceMeters: calibration.distanceMeters),
        tracker = tracker ?? IoUTracker(config: trackerConfig, startId: 1);

  final CalibrationGeometry geometry;
  final CounterConfig config;
  final IoUTracker tracker;
  final IdGenerator idGenerator;

  final Map<int, _TrackMotion> _motions = {};
  final Map<int, double> _speedByTrack = {};

  /// {@template counter_reset}
  /// Clears all tracking state. Called when a session starts.
  /// {@endtemplate}
  void reset() {
    tracker.reset();
    _motions.clear();
    _speedByTrack.clear();
  }

  /// Handles one processed frame.
  ///
  /// [timestampMicros] must come from a monotonic clock; wall clock time is
  /// only used to stamp the recorded event.
  FrameOutcome process({
    required List<Detection> detections,
    required int timestampMicros,
    required DateTime nowUtc,
  }) {
    final tracks = tracker.update(detections);
    final counted = <CountedVehicle>[];
    final measured = <SpeedMeasurement>[];

    for (final track in tracks) {
      if (!track.confirmed) {
        _motions.putIfAbsent(track.id, () => _TrackMotion());
        continue;
      }

      final motion = _motions.putIfAbsent(track.id, () => _TrackMotion());
      motion.vehicleClass = track.vehicleClass;
      motion.confidence = track.confidence;

      final previous = motion.lastPoint;
      final previousTs = motion.lastTimestampMicros;
      if (previous == null || previousTs == null) {
        motion.lastPoint = track.centroid;
        motion.lastTimestampMicros = timestampMicros;
        continue;
      }
      if (timestampMicros <= previousTs) {
        // Out of order frame, ignore it for kinematics.
        continue;
      }

      final current = track.centroid;
      final crossingA = geometry.lineA.crossing(previous, current);
      final crossingB = geometry.lineB.crossing(previous, current);

      if (crossingA != null) {
        _handleLineA(
          track: track,
          motion: motion,
          crossing: crossingA,
          previousTs: previousTs,
          timestampMicros: timestampMicros,
          nowUtc: nowUtc,
          counted: counted,
          measured: measured,
        );
      }

      if (crossingB != null) {
        final crossing = _Crossing(
          timestampMicros: _interpolate(
            previousTs,
            timestampMicros,
            crossingB.fraction,
          ),
          direction: _directionFor(crossingB.sign),
        );
        // Remember the earliest B crossing; it is only used once line A has
        // also been crossed (a vehicle that appears between the lines and
        // drives away must not be counted).
        motion.crossingB ??= crossing;
        if (motion.crossedA != null && !motion.speedResolved) {
          final result = _tryMeasure(track.id, motion, nowUtc);
          if (result != null) measured.add(result);
        }
      }

      motion.lastPoint = current;
      motion.lastTimestampMicros = timestampMicros;
    }

    _prune(tracks);

    final objects = <TrackedObject>[];
    for (final track in tracks) {
      objects.add(TrackedObject(
        id: track.id,
        box: track.box,
        vehicleClass: motionClass(track),
        confidence: track.confidence,
        confirmed: track.confirmed,
        missingFrames: track.misses,
        speedKmh: _speedByTrack[track.id],
      ));
    }

    return FrameOutcome(
      tracks: objects,
      counted: counted,
      measured: measured,
    );
  }

  VehicleClass motionClass(Track track) =>
      _motions[track.id]?.vehicleClass ?? track.vehicleClass;

  void _handleLineA({
    required Track track,
    required _TrackMotion motion,
    required LineCrossing crossing,
    required int previousTs,
    required int timestampMicros,
    required DateTime nowUtc,
    required List<CountedVehicle> counted,
    required List<SpeedMeasurement> measured,
  }) {
    final direction = _directionFor(crossing.sign);
    final timestamp = _interpolate(previousTs, timestampMicros, crossing.fraction);

    if (!motion.counted) {
      motion.counted = true;
      motion.direction = direction;
      motion.eventId = idGenerator();
      motion.crossedA = _Crossing(
        timestampMicros: timestamp,
        direction: direction,
      );
      counted.add(CountedVehicle(
        id: motion.eventId!,
        trackId: track.id,
        countedAtUtc: nowUtc,
        vehicleClass: motion.vehicleClass,
        direction: direction,
        speedKmh: null,
        confidence: motion.confidence,
      ));

      // In case line B was already crossed (vehicle entered the scene between
      // the two lines), measure now that the vehicle has been counted.
      final result = _tryMeasure(track.id, motion, nowUtc);
      if (result != null) measured.add(result);
      return;
    }

    // A single track id is counted at most once; a reverse crossing is either
    // the same vehicle backing up or a tracker glitch and is ignored.
    if (!motion.speedResolved &&
        motion.crossedA == null &&
        motion.direction == direction) {
      motion.crossedA = _Crossing(
        timestampMicros: timestamp,
        direction: direction,
      );
      final result = _tryMeasure(track.id, motion, nowUtc);
      if (result != null) measured.add(result);
    }
  }

  SpeedMeasurement? _tryMeasure(
    int trackId,
    _TrackMotion motion,
    DateTime nowUtc,
  ) {
    final a = motion.crossedA;
    final b = motion.crossingB;
    if (a == null || b == null) return null;
    if (motion.eventId == null) return null;
    if (a.direction != b.direction) {
      motion.speedResolved = true;
      return null;
    }

    motion.speedResolved = true;
    final span = Duration(
      microseconds: (b.timestampMicros - a.timestampMicros).abs(),
    );
    final sanity = config.speedSanity;
    if (span < sanity.minCrossingSpan || span > sanity.maxCrossingSpan) {
      return null;
    }

    final speed =
        config.distanceMeters / (span.inMicroseconds / 1e6) * 3.6;
    if (speed < sanity.minSpeedKmh || speed > sanity.maxSpeedKmh) {
      return null;
    }

    final rounded = (speed * 10).roundToDouble() / 10;
    _speedByTrack[trackId] = rounded;
    return SpeedMeasurement(
      eventId: motion.eventId!,
      trackId: trackId,
      speedKmh: rounded,
      measuredAtUtc: nowUtc,
    );
  }

  TravelDirection _directionFor(int sign) {
    final inbound = sign > 0;
    final flipped = config.flipDirection ? !inbound : inbound;
    return flipped ? TravelDirection.inbound : TravelDirection.outbound;
  }

  int _interpolate(int previousTs, int currentTs, double fraction) {
    final delta = currentTs - previousTs;
    return previousTs + (delta * fraction).round();
  }

  void _prune(List<Track> tracks) {
    if (_motions.length <= 64) return;
    final alive = tracks.map((t) => t.id).toSet();
    _motions.removeWhere((id, _) => !alive.contains(id));
    _speedByTrack.removeWhere((id, _) => !alive.contains(id));
  }

  /// Measured speeds kept for the live overlay.
  Map<int, double> get speedByTrack => Map.unmodifiable(_speedByTrack);
}

class _TrackMotion {
  NormPoint? lastPoint;
  int? lastTimestampMicros;
  _Crossing? crossedA;
  _Crossing? crossingB;
  String? eventId;
  TravelDirection? direction;
  bool counted = false;
  bool speedResolved = false;
  VehicleClass vehicleClass = VehicleClass.car;
  double confidence = 0;
}

class _Crossing {
  const _Crossing({required this.timestampMicros, required this.direction});

  final int timestampMicros;
  final TravelDirection direction;
}
