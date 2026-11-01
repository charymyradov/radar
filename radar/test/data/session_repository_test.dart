import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:radar/data/db/app_database.dart';
import 'package:radar/domain/models/enums.dart';
import 'package:radar/features/history/data/session_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.memory();
    await db.ensureDefaultStation('default');
  });

  tearDown(() => db.close());

  test('list() reports counts and violations per session', () async {
    final now = DateTime.utc(2026, 1, 1);
    await db.into(db.sessions).insert(
          SessionsCompanion.insert(
            id: 'ses-1',
            stationId: 'default',
            startedAt: now,
          ),
        );
    for (var index = 0; index < 2; index++) {
      await db.into(db.events).insert(
            EventsCompanion.insert(
              id: 'evt-$index',
              sessionId: 'ses-1',
              countedAt: now.add(Duration(seconds: index)),
              vehicleClass: VehicleClass.car,
              direction: TravelDirection.inbound,
              speedKmh: const Value(90.0),
              confidence: 0.9,
            ),
          );
    }
    await db.into(db.violations).insert(
          ViolationsCompanion.insert(
            id: 'vio-1',
            eventId: 'evt-0',
            limitKmh: 50,
            status: ViolationStatus.pending,
            createdAt: now,
          ),
        );

    final sessions = await SessionRepository(db).list();

    expect(sessions, hasLength(1));
    expect(sessions.single.totalCount, 2);
    expect(sessions.single.measuredCount, 2);
    expect(sessions.single.violationCount, 1);
  });

  test('running() and byId() include violations', () async {
    final now = DateTime.utc(2026, 1, 1);
    await db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            id: 'ses-running',
            stationId: 'default',
            startedAt: now,
          ),
        );
    await db
        .into(db.events)
        .insert(
          EventsCompanion.insert(
            id: 'evt-running',
            sessionId: 'ses-running',
            countedAt: now,
            vehicleClass: VehicleClass.car,
            direction: TravelDirection.inbound,
            speedKmh: const Value(90.0),
            confidence: 0.9,
          ),
        );
    await db
        .into(db.violations)
        .insert(
          ViolationsCompanion.insert(
            id: 'vio-running',
            eventId: 'evt-running',
            limitKmh: 50,
            status: ViolationStatus.pending,
            createdAt: now,
          ),
        );

    final repository = SessionRepository(db);

    expect((await repository.running())?.violationCount, 1);
    expect((await repository.byId('ses-running'))?.violationCount, 1);
  });

  test('list() keeps sessions that have no events', () async {
    await db.into(db.sessions).insert(
          SessionsCompanion.insert(
            id: 'ses-empty',
            stationId: 'default',
            startedAt: DateTime.utc(2026, 1, 1),
          ),
        );

    final sessions = await SessionRepository(db).list();

    expect(sessions.single.id, 'ses-empty');
    expect(sessions.single.totalCount, 0);
    expect(sessions.single.violationCount, 0);
  });
}
