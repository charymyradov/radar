import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radar/data/db/app_database.dart';
import 'package:radar/domain/models/enums.dart';

/// Splits the v1 DDL file into executable statements.
List<String> _statements(String ddl) => ddl
    .split('\n')
    .where((line) => !line.trimLeft().startsWith('--'))
    .join('\n')
    .split(';')
    .map((s) => s.trim())
    .where((s) => s.isNotEmpty)
    .map((s) => '$s;')
    .toList();

/// Opens an in-memory database whose file already contains the v1 schema and
/// one row per table, exactly like a device that installed version 0.1.
AppDatabase openLegacyDatabase() {
  final ddl = File('docs/schema_v1.sql').readAsStringSync();
  const timestamp = 1735689600; // 2025-01-01T00:00:00Z
  return AppDatabase(
    NativeDatabase.memory(
      setup: (db) {
        for (final statement in _statements(ddl)) {
          db.execute(statement);
        }
        db.execute(
          "INSERT INTO stations (id, name, created_at) "
          "VALUES ('default', 'Legacy', $timestamp);",
        );
        db.execute(
          "INSERT INTO calibrations (id, station_id, version, line_a_x1, "
          "line_a_y1, line_a_x2, line_a_y2, line_b_x1, line_b_y1, line_b_x2, "
          "line_b_y2, distance_m, is_active, created_at) "
          "VALUES ('cal-1', 'default', 1, 0, 0.4, 1, 0.4, 0, 0.6, 1, 0.6, "
          "20, 1, $timestamp);",
        );
        db.execute(
          "INSERT INTO sessions (id, station_id, calibration_id, started_at) "
          "VALUES ('ses-1', 'default', 'cal-1', $timestamp);",
        );
        for (var i = 0; i < 3; i++) {
          db.execute(
            "INSERT INTO events (id, session_id, calibration_id, counted_at, "
            "vehicle_class, direction, speed_kmh, confidence) "
            "VALUES ('evt-$i', 'ses-1', 'cal-1', ${timestamp + i}, 0, 0, "
            "${50 + i}, 0.9);",
          );
        }
        db.userVersion = 1;
      },
    ),
  );
}

void main() {
  group('drift migration v1 -> v2', () {
    test('keeps existing rows and adds the new columns', () async {
      final db = openLegacyDatabase();
      addTearDown(db.close);

      // Reading through the generated API proves the schema now matches v2.
      final events = await db.select(db.events).get();
      expect(events, hasLength(3));
      expect(events.first.isValid, isTrue);
      expect(events.first.isDeleted, isFalse);
      expect(events.first.trackId, 0);
      expect(events.first.speedKmh, 50);
      expect(events.map((e) => e.id), containsAll(['evt-0', 'evt-1', 'evt-2']));

      final sessions = await db.select(db.sessions).get();
      expect(sessions.single.note, isNull);

      // New tables exist and are usable.
      await db.into(db.settingsEntries).insert(
            SettingsEntriesCompanion.insert(key: 'unit', value: 'kmh'),
          );
      expect(await db.allSettings(), {'unit': 'kmh'});

      await db.into(db.violations).insert(
            ViolationsCompanion.insert(
              id: 'vio-1',
              eventId: 'evt-0',
              limitKmh: 50,
              status: ViolationStatus.pending,
              createdAt: DateTime.utc(2025),
            ),
          );
      final violations = await db.select(db.violations).get();
      expect(violations.single.eventId, 'evt-0');
    });

    test('indices are present after the upgrade', () async {
      final db = openLegacyDatabase();
      addTearDown(db.close);
      final result = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
          .get();
      final names = result.map((row) => row.read<String>('name')).toSet();
      expect(names, contains('events_counted_at'));
      expect(names, contains('events_session_id'));
      expect(names, contains('events_speed_kmh'));
    });

    test('a fresh database is created at the current version', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await db.ensureDefaultStation('default');
      final stations = await db.select(db.stations).get();
      expect(stations, hasLength(1));
      final columns = await db
          .customSelect('PRAGMA table_info(events)')
          .get();
      final names = columns.map((row) => row.read<String>('name')).toSet();
      expect(names, containsAll(['track_id', 'is_valid', 'is_deleted']));
    });

    test('cascade delete removes events and violations of a session', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await db.ensureDefaultStation('default');
      final now = DateTime.utc(2026, 1, 1);
      await db.into(db.sessions).insert(
            SessionsCompanion.insert(
              id: 'ses-1',
              stationId: 'default',
              startedAt: now,
            ),
          );
      await db.into(db.events).insert(
            EventsCompanion.insert(
              id: 'evt-1',
              sessionId: 'ses-1',
              countedAt: now,
              vehicleClass: VehicleClass.car,
              direction: TravelDirection.inbound,
              speedKmh: const Value(60),
              confidence: 0.9,
              trackId: const Value(7),
            ),
          );
      await db.into(db.violations).insert(
            ViolationsCompanion.insert(
              id: 'vio-1',
              eventId: 'evt-1',
              limitKmh: 50,
              status: ViolationStatus.pending,
              createdAt: now,
            ),
          );

      await db.deleteSessionCascade('ses-1');

      expect(await db.select(db.events).get(), isEmpty);
      expect(await db.select(db.violations).get(), isEmpty);
      expect(await db.select(db.sessions).get(), isEmpty);
    });
  });
}
