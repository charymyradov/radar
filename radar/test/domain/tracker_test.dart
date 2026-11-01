import 'package:flutter_test/flutter_test.dart';
import 'package:radar/domain/geometry/geometry.dart';
import 'package:radar/domain/models/detection_models.dart';
import 'package:radar/domain/tracking/iou_tracker.dart';

Detection det(double cx, double cy, {double w = 0.08, double h = 0.08}) {
  return Detection(
    box: BoundingBox(cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2),
    classId: 2,
    confidence: 0.9,
  );
}

void main() {
  group('IoUTracker', () {
    test('keeps one id while an object moves across the frame', () {
      final tracker = IoUTracker();
      final ids = <int>{};
      for (var i = 0; i < 10; i++) {
        final tracks = tracker.update([det(0.2 + i * 0.03, 0.5)]);
        expect(tracks, hasLength(1));
        ids.add(tracks.single.id);
      }
      expect(ids, hasLength(1));
      expect(tracker.tracks.single.hits, 10);
    });

    test('assigns different ids to two overlapping-in-time objects', () {
      final tracker = IoUTracker();
      for (var i = 0; i < 6; i++) {
        tracker.update([
          det(0.2, 0.2 + i * 0.02),
          det(0.8, 0.8 - i * 0.02),
        ]);
      }
      final ids = tracker.tracks.map((t) => t.id).toSet();
      expect(ids, hasLength(2));
    });

    test('tracks stay tentative until minHits matches', () {
      final tracker = IoUTracker();
      var tracks = tracker.update([det(0.4, 0.4)]);
      expect(tracks.single.confirmed, isFalse);
      tracks = tracker.update([det(0.41, 0.4)]);
      expect(tracks.single.confirmed, isFalse);
      tracks = tracker.update([det(0.42, 0.4)]);
      expect(tracks.single.confirmed, isTrue);
    });

    test('drops a track after maxMisses empty frames', () {
      final tracker = IoUTracker();
      tracker.update([det(0.4, 0.4)]);
      for (var i = 0; i < 13; i++) {
        tracker.update(const []);
      }
      expect(tracker.tracks, isEmpty);
    });

    test('a low confidence detection keeps an existing track alive', () {
      final tracker = IoUTracker();
      tracker.update([det(0.4, 0.4)]);
      final low = Detection(
        box: det(0.405, 0.4).box,
        classId: 2,
        confidence: 0.2,
      );
      final tracks = tracker.update([low]);
      expect(tracks.single.misses, 0);
      expect(tracks.single.id, 1);
    });

    test('does not spawn tracks for low confidence detections', () {
      final tracker = IoUTracker();
      tracker.update([
        Detection(box: det(0.5, 0.5).box, classId: 2, confidence: 0.1),
      ]);
      expect(tracker.tracks, isEmpty);
    });

    test('a re-entering object gets a fresh id', () {
      final tracker = IoUTracker();
      for (var i = 0; i < 5; i++) {
        tracker.update([det(0.2 + i * 0.03, 0.5)]);
      }
      final firstId = tracker.tracks.single.id;
      for (var i = 0; i < 20; i++) {
        tracker.update(const []);
      }
      expect(tracker.tracks, isEmpty);
      for (var i = 0; i < 5; i++) {
        tracker.update([det(0.2 + i * 0.03, 0.5)]);
      }
      expect(tracker.tracks.single.id, isNot(firstId));
    });
  });

  group('sortBySizeDescending', () {
    test('orders the biggest object first', () {
      final tracker = IoUTracker();
      tracker.update([
        det(0.2, 0.2, w: 0.05, h: 0.05),
        det(0.8, 0.8, w: 0.2, h: 0.2),
      ]);
      final sorted = sortBySizeDescending(tracker.tracks);
      expect(sorted.first.box.width, closeTo(0.2, 1e-9));
    });
  });
}
