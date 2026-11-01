import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../domain/models/enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// SQLite schema for the whole app.
///
/// Version history:
/// * v1 - first internal build (stations, calibrations, sessions, events).
/// * v2 - adds `events.track_id`, `events.is_valid`, `events.is_deleted`, the
///   `violations` and `settings_entries` tables plus the reporting indices.
///
/// The v1 DDL lives in `docs/schema_v1.sql`; the migration test replays it and
/// then opens this database to prove existing rows survive the upgrade.
@DriftDatabase(
  tables: [
    Stations,
    Calibrations,
    Sessions,
    Events,
    Violations,
    SettingsEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens (or creates) the database file in a background isolate so query
  /// execution never blocks the UI.
  factory AppDatabase.open(File file) =>
      AppDatabase(NativeDatabase.createInBackground(file));

  /// In-memory database used by tests.
  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await createIndices();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(events, events.trackId);
            await m.addColumn(events, events.isValid);
            await m.addColumn(events, events.isDeleted);
            await m.createTable(violations);
            await m.createTable(settingsEntries);
          }
          await createIndices();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          if (details.wasCreated) {
            await customStatement('PRAGMA journal_mode = WAL');
          }
        },
      );

  /// Indices required by the history and statistics screens.
  Future<void> createIndices() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS events_counted_at ON events (counted_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS events_session_id ON events (session_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS events_speed_kmh ON events (speed_kmh)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS violations_event_id ON violations (event_id)',
    );
  }

  /// Flushes WAL pages so a plain file copy is consistent.
  Future<void> checkpoint() async {
    await customStatement('PRAGMA wal_checkpoint(FULL)');
  }

  /// Creates the immutable single station used by the app on first launch.
  Future<void> ensureDefaultStation(String stationId) async {
    final existing = await (select(stations)
          ..where((t) => t.id.equals(stationId)))
        .getSingleOrNull();
    if (existing != null) return;
    await into(stations).insert(
      StationsCompanion.insert(
        id: stationId,
        name: 'Default station',
        createdAt: DateTime.now().toUtc(),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> deleteSessionCascade(String sessionId) async {
    await transaction(() async {
      final eventIds = await (select(events)
            ..where((t) => t.sessionId.equals(sessionId)))
          .map((row) => row.id)
          .get();
      if (eventIds.isNotEmpty) {
        await (delete(violations)
              ..where((t) => t.eventId.isIn(eventIds)))
            .go();
      }
      await (delete(events)..where((t) => t.sessionId.equals(sessionId))).go();
      await (delete(sessions)..where((t) => t.id.equals(sessionId))).go();
    });
  }

  /// Wipes all user data but keeps the schema and the default station.
  Future<void> deleteAllData({required String stationId}) async {
    await transaction(() async {
      await delete(violations).go();
      await delete(events).go();
      await delete(sessions).go();
      await delete(calibrations).go();
      await delete(settingsEntries).go();
      await delete(stations).go();
      await ensureDefaultStation(stationId);
    });
  }

  /// Total number of events, used by the storage-full health check.
  Future<int> countEvents() async {
    final query = selectOnly(events)..addColumns([events.id.count()]);
    final row = await query.getSingle();
    return row.read(events.id.count()) ?? 0;
  }

  /// Speed values used for percentile calculations, already sorted.
  Future<List<double>> sortedSpeeds({
    DateTime? from,
    DateTime? to,
    String? sessionId,
    bool onlyValid = true,
  }) async {
    final query = select(events)
      ..where((t) => t.speedKmh.isNotNull())
      ..orderBy([(t) => OrderingTerm.asc(t.speedKmh)]);
    if (onlyValid) {
      query.where((t) => t.isDeleted.equals(false) & t.isValid.equals(true));
    }
    if (from != null) {
      query.where((t) => t.countedAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((t) => t.countedAt.isSmallerThanValue(to));
    }
    if (sessionId != null) {
      query.where((t) => t.sessionId.equals(sessionId));
    }
    final rows = await query.get();
    return rows
        .map((row) => row.speedKmh)
        .whereType<double>()
        .where((value) => value.isFinite)
        .toList();
  }

  /// Convenience lookup used by the settings screen.
  Future<Map<String, String>> allSettings() async {
    final rows = await select(settingsEntries).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> putSetting(String key, String value) async {
    await into(settingsEntries).insertOnConflictUpdate(
      SettingsEntriesCompanion.insert(key: key, value: value),
    );
  }
}

/// Re-exported so repositories do not need to import table classes directly.
class EventRecord {
  const EventRecord(this.row, this.violation);

  final EventRow row;
  final ViolationRow? violation;
}

/// Direction helper used by filters and UI.
extension TravelDirectionX on TravelDirection {
  String get storageKey => name;
}
