import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/db/app_database.dart';
import '../../../domain/models/detection_models.dart';
import '../../../domain/models/enums.dart';
import '../domain/vehicle_event.dart';

/// Buffered writer for counted vehicles.
///
/// Rows are collected in memory and written in batches every few seconds so a
/// 15 fps stream never triggers a synchronous SQLite write per frame. Ordering
/// inside a batch is preserved: event inserts first, then the speed updates
/// (and violation rows) that refer to them.
class EventRepository {
  EventRepository(
    this._db, {
    this.flushInterval = const Duration(seconds: 3),
    this.onError,
    this.maxPending = 2000,
  });

  final AppDatabase _db;
  final Duration flushInterval;

  /// Called when a background flush fails (for example storage full).
  final void Function(Object error)? onError;
  final int maxPending;

  final List<_PendingOp> _queue = <_PendingOp>[];
  Timer? _timer;
  bool _flushing = false;
  bool _disposed = false;
  int get pendingCount => _queue.length;

  /// Queues a vehicle counted at line A. Speed is filled in later.
  void enqueueCounted({
    required CountedVehicle vehicle,
    required String sessionId,
    String? calibrationId,
  }) {
    if (_disposed) return;
    _enqueue(_InsertEvent(EventsCompanion.insert(
      id: vehicle.id,
      sessionId: sessionId,
      calibrationId: Value(calibrationId),
      countedAt: vehicle.countedAtUtc.toUtc(),
      vehicleClass: vehicle.vehicleClass,
      direction: vehicle.direction,
      speedKmh: Value(vehicle.speedKmh),
      speedMeasuredAt: Value(
        vehicle.speedKmh == null ? null : vehicle.countedAtUtc.toUtc(),
      ),
      confidence: vehicle.confidence,
      trackId: Value(vehicle.trackId),
    )));
  }

  /// Queues the late speed of an already counted vehicle, optionally creating
  /// a violation row in the same batch.
  void enqueueMeasured(
    SpeedMeasurement measurement, {
    double? speedLimitKmh,
    String? imagePath,
  }) {
    if (_disposed) return;
    ViolationsCompanion? violation;
    if (speedLimitKmh != null && measurement.speedKmh > speedLimitKmh) {
      violation = ViolationsCompanion.insert(
        id: 'v-${measurement.eventId}',
        eventId: measurement.eventId,
        limitKmh: speedLimitKmh,
        imagePath: Value(imagePath),
        status: ViolationStatus.pending,
        createdAt: measurement.measuredAtUtc.toUtc(),
      );
    }
    _enqueue(_UpdateSpeed(
      eventId: measurement.eventId,
      speedKmh: measurement.speedKmh,
      measuredAt: measurement.measuredAtUtc.toUtc(),
      violation: violation,
    ));
  }

  void _enqueue(_PendingOp op) {
    if (_queue.length >= maxPending) {
      // Keep the newest data but stop growing without bound.
      _queue.removeAt(0);
    }
    _queue.add(op);
    _timer ??= Timer.periodic(flushInterval, (_) {
      flush().catchError((Object error) {
        onError?.call(error);
      });
    });
  }

  /// Writes everything queued so far. Safe to call concurrently.
  Future<void> flush() async {
    if (_flushing) {
      // A flush is already in progress; wait for it to finish then flush the
      // remainder (the queue may have grown meanwhile).
      await Future<void>.delayed(Duration.zero);
      if (_queue.isEmpty) return;
    }
    if (_queue.isEmpty) return;
    _flushing = true;
    final ops = List<_PendingOp>.of(_queue);
    _queue.clear();
    try {
      await _db.transaction(() async {
        final inserts = ops.whereType<_InsertEvent>();
        if (inserts.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
              _db.events,
              inserts.map((op) => op.row).toList(),
              mode: InsertMode.insertOrReplace,
            );
          });
        }
        for (final op in ops.whereType<_UpdateSpeed>()) {
          await (_db.update(_db.events)
                ..where((t) => t.id.equals(op.eventId)))
              .write(EventsCompanion(
            speedKmh: Value(op.speedKmh),
            speedMeasuredAt: Value(op.measuredAt),
          ));
          final violation = op.violation;
          if (violation != null) {
            await _db
                .into(_db.violations)
                .insert(violation, mode: InsertMode.insertOrReplace);
          }
        }
      });
    } catch (error) {
      // Put the work back so a transient failure does not lose events.
      _queue.insertAll(0, ops.take(maxPending));
      rethrow;
    } finally {
      _flushing = false;
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    try {
      await flush();
    } finally {
      _queue.clear();
    }
  }

  // ---------------------------------------------------------------- queries

  Future<List<VehicleEvent>> query(
    EventFilter filter, {
    int limit = 200,
    int offset = 0,
  }) async {
    final query = _db.select(_db.events).join([
      leftOuterJoin(
        _db.violations,
        _db.violations.eventId.equalsExp(_db.events.id),
      ),
    ]);
    for (final condition in _conditions(filter)) {
      query.where(condition);
    }
    query
      ..orderBy([OrderingTerm.desc(_db.events.countedAt)])
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map((row) {
      final event = row.readTable(_db.events);
      final violation = row.readTableOrNull(_db.violations);
      return VehicleEvent(
        id: event.id,
        sessionId: event.sessionId,
        calibrationId: event.calibrationId,
        countedAt: event.countedAt,
        speedMeasuredAt: event.speedMeasuredAt,
        vehicleClass: event.vehicleClass,
        direction: event.direction,
        speedKmh: event.speedKmh,
        confidence: event.confidence,
        trackId: event.trackId,
        isValid: event.isValid,
        isDeleted: event.isDeleted,
        violationStatus: violation?.status,
        violationImagePath: violation?.imagePath,
      );
    }).toList();
  }

  Future<int> count(EventFilter filter) async {
    final query = _db.selectOnly(_db.events)
      ..addColumns([_db.events.id.count()]);
    for (final condition in _conditions(filter)) {
      query.where(condition);
    }
    final row = await query.getSingle();
    return row.read(_db.events.id.count()) ?? 0;
  }

  List<Expression<bool>> _conditions(EventFilter filter) {
    final conditions = <Expression<bool>>[];
    if (filter.sessionId != null) {
      conditions.add(_db.events.sessionId.equals(filter.sessionId!));
    }
    if (filter.from != null) {
      conditions.add(_db.events.countedAt.isBiggerOrEqualValue(filter.from!));
    }
    if (filter.to != null) {
      conditions.add(_db.events.countedAt.isSmallerThanValue(filter.to!));
    }
    if (filter.classes.isNotEmpty) {
      conditions.add(_db.events.vehicleClass.isIn(
        filter.classes.map((c) => c.index).toList(),
      ));
    }
    if (filter.directions.isNotEmpty) {
      conditions.add(_db.events.direction.isIn(
        filter.directions.map((d) => d.index).toList(),
      ));
    }
    if (filter.minSpeedKmh != null) {
      conditions.add(
        _db.events.speedKmh.isBiggerOrEqualValue(filter.minSpeedKmh!),
      );
    }
    if (filter.maxSpeedKmh != null) {
      conditions.add(
        _db.events.speedKmh.isSmallerOrEqualValue(filter.maxSpeedKmh!),
      );
    }
    if (filter.onlyMeasured) {
      conditions.add(_db.events.speedKmh.isNotNull());
    }
    if (!filter.includeInvalid) {
      conditions.add(_db.events.isValid.equals(true));
    }
    if (!filter.includeDeleted) {
      conditions.add(_db.events.isDeleted.equals(false));
    }
    return conditions;
  }

  Future<void> setValid(String eventId, bool valid) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId)))
        .write(EventsCompanion(isValid: Value(valid)));
  }

  Future<void> setClass(String eventId, VehicleClass vehicleClass) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId)))
        .write(EventsCompanion(vehicleClass: Value(vehicleClass)));
  }

  Future<void> softDelete(String eventId) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId)))
        .write(const EventsCompanion(isDeleted: Value(true)));
  }

  Future<void> restore(String eventId) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(eventId)))
        .write(const EventsCompanion(isDeleted: Value(false)));
  }

  Future<String> newEventId() async {
    return const Uuid().v4();
  }
}

sealed class _PendingOp {
  const _PendingOp();
}

class _InsertEvent extends _PendingOp {
  const _InsertEvent(this.row);

  final EventsCompanion row;
}

class _UpdateSpeed extends _PendingOp {
  const _UpdateSpeed({
    required this.eventId,
    required this.speedKmh,
    required this.measuredAt,
    this.violation,
  });

  final String eventId;
  final double speedKmh;
  final DateTime measuredAt;
  final ViolationsCompanion? violation;
}
