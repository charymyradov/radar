import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../domain/session_summary.dart';

/// Creates, closes and lists counting sessions.
class SessionRepository {
  SessionRepository(this._db);

  final AppDatabase _db;

  Future<SessionSummary> start({
    required String id,
    required String stationId,
    String? calibrationId,
    DateTime? startedAt,
  }) async {
    final start = (startedAt ?? DateTime.now()).toUtc();
    await _db.into(_db.sessions).insert(
          SessionsCompanion.insert(
            id: id,
            stationId: stationId,
            calibrationId: Value(calibrationId),
            startedAt: start,
          ),
        );
    return SessionSummary(
      id: id,
      stationId: stationId,
      calibrationId: calibrationId,
      startedAt: start,
      totalCount: 0,
      measuredCount: 0,
      violationCount: 0,
    );
  }

  Future<void> end(String id, {DateTime? endedAt}) async {
    final end = (endedAt ?? DateTime.now()).toUtc();
    await (_db.update(_db.sessions)..where((t) => t.id.equals(id))).write(
      SessionsCompanion(endedAt: Value(end)),
    );
  }

  /// Closes sessions left open by a crash or a force stop. Uses the last event
  /// timestamp as the end so the duration stays realistic.
  Future<int> closeOrphans() async {
    final open = await (_db.select(_db.sessions)
          ..where((t) => t.endedAt.isNull()))
        .get();
    if (open.isEmpty) return 0;
    for (final session in open) {
      final last = await _db
          .customSelect(
            'SELECT MAX(counted_at) AS last FROM events WHERE session_id = ?',
            variables: [Variable<String>(session.id)],
          )
          .map((row) => row.readNullable<int>('last'))
          .getSingle();
      final end = last == null
          ? session.startedAt.add(const Duration(seconds: 1))
          : DateTime.fromMillisecondsSinceEpoch(last * 1000, isUtc: true);
      await (_db.update(_db.sessions)..where((t) => t.id.equals(session.id)))
          .write(SessionsCompanion(endedAt: Value(end)));
    }
    return open.length;
  }

  Future<SessionSummary?> running() async {
    final row = await (_db.select(_db.sessions)
          ..where((t) => t.endedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    final all = await list(fullScan: true);
    return all.where((s) => s.id == row.id).firstOrNull;
  }

  Future<List<SessionSummary>> list({int limit = 200, bool fullScan = false}) async {
    final total = _db.events.id.count(
      filter: _db.events.isDeleted.equals(false) &
          _db.events.isValid.equals(true),
    );
    final measured = _db.events.id.count(
      filter: _db.events.isDeleted.equals(false) &
          _db.events.isValid.equals(true) &
          _db.events.speedKmh.isNotNull(),
    );

    final query = _db.select(_db.sessions).join([
      leftOuterJoin(
        _db.events,
        _db.events.sessionId.equalsExp(_db.sessions.id),
        useColumns: false,
      ),
    ])
      ..addColumns([total, measured])
      ..groupBy([_db.sessions.id])
      ..orderBy([OrderingTerm.desc(_db.sessions.startedAt)]);
    if (!fullScan) query.limit(limit);

    final violationCounts = await _violationCounts();
    final rows = await query.get();
    return rows.map((row) {
      final session = row.readTable(_db.sessions);
      return SessionSummary(
        id: session.id,
        stationId: session.stationId,
        calibrationId: session.calibrationId,
        startedAt: session.startedAt,
        endedAt: session.endedAt,
        note: session.note,
        totalCount: row.read(total) ?? 0,
        measuredCount: row.read(measured) ?? 0,
        violationCount: violationCounts[session.id] ?? 0,
      );
    }).toList();
  }

  Future<SessionSummary?> byId(String id) async {
    final all = await list(fullScan: true);
    return all.where((s) => s.id == id).firstOrNull;
  }

  Future<void> delete(String id) => _db.deleteSessionCascade(id);

  Future<Map<String, int>> _violationCounts() async {
    // The join excludes the events columns, so the session id has to be added
    // explicitly; `readTable` would throw for a table that is not selected.
    final sessionId = _db.events.sessionId;
    final count = _db.violations.id.count();
    final query = _db.select(_db.violations).join([
      innerJoin(
        _db.events,
        _db.events.id.equalsExp(_db.violations.eventId),
        useColumns: false,
      ),
    ])
      ..addColumns([sessionId, count])
      ..groupBy([sessionId]);
    final rows = await query.get();
    final counts = <String, int>{};
    for (final row in rows) {
      final id = row.read(sessionId);
      if (id == null) continue;
      counts[id] = row.read(count) ?? 0;
    }
    return counts;
  }
}
