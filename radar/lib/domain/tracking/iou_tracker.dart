import 'dart:math' as math;

import '../../core/config/detection_config.dart';
import '../geometry/geometry.dart';
import '../models/detection_models.dart';
import '../models/enums.dart';

/// Tuning knobs for [IoUTracker].
class TrackerConfig {
  const TrackerConfig({
    this.highIoUThreshold = 0.30,
    this.lowIoUThreshold = 0.15,
    this.minHits = 3,
    this.maxMisses = 12,
    this.highConfidence = kHighConfidence,
    this.velocitySmoothing = 0.5,
  });

  /// IoU needed to associate a high-confidence detection with a track.
  final double highIoUThreshold;

  /// IoU used for the second (low confidence) association pass.
  final double lowIoUThreshold;

  /// Matches needed before a track becomes confirmed and can be counted.
  /// Tracks younger than this are never counted.
  final int minHits;

  /// Frames a track may go unmatched before it is dropped.
  final int maxMisses;

  final double highConfidence;

  /// Exponential smoothing applied to the estimated velocity (0..1).
  final double velocitySmoothing;
}

/// One tracked object with its association bookkeeping.
class Track {
  Track({
    required this.id,
    required this.vehicleClass,
    required this.box,
    required this.confidence,
    required this.minHits,
    this.velocity = const NormPoint(0, 0),
    this.hits = 1,
    this.misses = 0,
    this.age = 0,
  });

  final int id;
  final int minHits;
  VehicleClass vehicleClass;
  BoundingBox box;
  double confidence;
  NormPoint velocity;
  int hits;
  int misses;
  int age;

  bool get confirmed => hits >= minHits;

  NormPoint get centroid => box.center;

  /// Box extrapolated by the estimated velocity, used for IoU association so
  /// fast vehicles keep their identity at low frame rates.
  BoundingBox get predictedBox => box.translate(velocity.x, velocity.y);

  TrackedObject toTrackedObject() => TrackedObject(
        id: id,
        box: box,
        vehicleClass: vehicleClass,
        confidence: confidence,
        confirmed: confirmed,
        missingFrames: misses,
      );

  @override
  String toString() =>
      'Track(#$id, $vehicleClass, hits: $hits, misses: $misses)';
}

/// IoU based multi object tracker, ByteTrack flavoured.
///
/// Pure Dart: no Flutter, no plugins. Two association stages are used: first
/// high confidence detections, then low confidence ones (which keep occluded
/// vehicles alive without spawning new ids).
class IoUTracker {
  IoUTracker({this.config = const TrackerConfig(), int startId = 1})
      : _startId = startId,
        _nextId = startId;

  final TrackerConfig config;
  final int _startId;

  final Map<int, Track> _tracks = {};
  int _nextId;

  List<Track> get tracks => List.unmodifiable(_tracks.values);

  int get nextId => _nextId;

  /// Feeds one frame of detections and returns the currently alive tracks.
  List<Track> update(List<Detection> detections) {
    final high = <Detection>[];
    final low = <Detection>[];
    for (final det in detections) {
      if (det.confidence >= config.highConfidence) {
        high.add(det);
      } else {
        low.add(det);
      }
    }

    final active = _tracks.values.toList();
    final firstStage = _associate(active, high, config.highIoUThreshold);
    final matchedTrackIds = <int>{};
    for (final entry in firstStage.entries) {
      _applyMatch(entry.key, entry.value);
      matchedTrackIds.add(entry.key.id);
    }

    // Second stage only sees tracks that missed the first pass.
    final remaining =
        _tracks.values.where((t) => !matchedTrackIds.contains(t.id)).toList();
    final secondStage = _associate(remaining, low, config.lowIoUThreshold);
    for (final entry in secondStage.entries) {
      _applyMatch(entry.key, entry.value);
      matchedTrackIds.add(entry.key.id);
    }

    for (final track in _tracks.values) {
      if (matchedTrackIds.contains(track.id)) continue;
      track.misses += 1;
      track.age += 1;
      track.velocity = NormPoint(track.velocity.x * 0.5, track.velocity.y * 0.5);
    }
    _tracks.removeWhere((_, track) => track.misses > config.maxMisses);

    final used = <Detection>{...firstStage.values, ...secondStage.values};
    for (final det in high) {
      if (!_contains(used, det)) _spawn(det);
    }

    return tracks;
  }

  void reset() {
    _tracks.clear();
    _nextId = _startId;
  }

  bool _contains(Set<Detection> set, Detection det) => set.contains(det);

  void _spawn(Detection det) {
    final track = Track(
      id: _nextId++,
      vehicleClass: _classFor(det),
      box: det.box,
      confidence: det.confidence,
      minHits: config.minHits,
    );
    _tracks[track.id] = track;
  }

  void _applyMatch(Track track, Detection det) {
    final previous = track.box.center;
    final current = det.box.center;
    final dx = current.x - previous.x;
    final dy = current.y - previous.y;
    final alpha = config.velocitySmoothing;
    track.velocity = NormPoint(
      track.velocity.x * (1 - alpha) + dx * alpha,
      track.velocity.y * (1 - alpha) + dy * alpha,
    );
    track.box = det.box;
    track.hits += 1;
    track.age += 1;
    track.misses = 0;
    if (det.confidence >= track.confidence) {
      track.confidence = det.confidence;
      track.vehicleClass = _classFor(det);
    }
  }

  VehicleClass _classFor(Detection det) {
    // The detector already maps class ids; this is a defensive fallback for
    // raw COCO ids reaching the tracker in tests.
    switch (det.classId) {
      case 3:
        return VehicleClass.motorcycle;
      case 5:
        return VehicleClass.bus;
      case 7:
        return VehicleClass.truck;
      case 2:
      default:
        return VehicleClass.car;
    }
  }

  /// Greedy IoU matching: repeatedly take the best remaining pair.
  Map<Track, Detection> _associate(
    List<Track> tracks,
    List<Detection> detections,
    double threshold,
  ) {
    final result = <Track, Detection>{};
    if (tracks.isEmpty || detections.isEmpty) return result;

    final pairs = <_Pair>[];
    for (final track in tracks) {
      final predicted = track.predictedBox.clampUnit();
      for (final detection in detections) {
        final iou = predicted.iou(detection.box);
        if (iou >= threshold) {
          pairs.add(_Pair(track, detection, iou));
        }
      }
    }
    pairs.sort((a, b) {
      // IoU differences below 5% are treated as ties: sensor noise and
      // velocity prediction make them meaningless. On a tie the most
      // recently seen track wins, so a stale track parked at the same spot
      // cannot steal a detection from the vehicle actually crossing now.
      final bucketA = (a.iou * 20).round();
      final bucketB = (b.iou * 20).round();
      final byBucket = bucketB.compareTo(bucketA);
      if (byBucket != 0) return byBucket;
      final byIou = b.iou.compareTo(a.iou);
      if (byIou != 0) return byIou;
      final byFreshness = a.track.misses.compareTo(b.track.misses);
      if (byFreshness != 0) return byFreshness;
      return b.track.id.compareTo(a.track.id);
    });

    final usedTracks = <int>{};
    final usedDetections = <Detection>{};
    for (final pair in pairs) {
      if (usedTracks.contains(pair.track.id)) continue;
      if (usedDetections.contains(pair.detection)) continue;
      usedTracks.add(pair.track.id);
      usedDetections.add(pair.detection);
      result[pair.track] = pair.detection;
    }
    return result;
  }
}

class _Pair {
  const _Pair(this.track, this.detection, this.iou);

  final Track track;
  final Detection detection;
  final double iou;
}

/// COCO class ids accepted by the app (car, motorcycle, bus, truck).
const Set<int> kCocoVehicleIds = {2, 3, 5, 7};

/// Clamps a raw model box to the unit square.
BoundingBox sanitiseBox(double x1, double y1, double x2, double y2) =>
    BoundingBox.fromCorners(x1, y1, x2, y2).clampUnit();

/// Convenience helper used by tests and the live overlay to sort tracks by
/// visual size, largest first.
List<TrackedObject> sortBySizeDescending(List<Track> tracks) {
  final objects = tracks.map((t) => t.toTrackedObject()).toList();
  objects.sort((a, b) => math
      .max(b.box.width, b.box.height)
      .compareTo(math.max(a.box.width, a.box.height)));
  return objects;
}
