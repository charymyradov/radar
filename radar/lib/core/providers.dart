import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/db/app_database.dart';
import '../features/calibration/data/calibration_repository.dart';
import '../features/history/data/event_repository.dart';
import '../features/history/data/session_repository.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/stats/data/stats_repository.dart';
import '../features/violations/data/violation_repository.dart';
import 'errors/app_failure.dart';
import 'media/media_store.dart';

/// The app is single station; the id is fixed so backups stay portable.
const String kDefaultStationId = 'default';
const String kDatabaseFileName = 'radar.sqlite';

/// Owns the SQLite database and can swap it out after a restore.
class DatabaseController extends AsyncNotifier<AppDatabase> {
  AppDatabase? _current;
  File? _file;

  File get databaseFile {
    final file = _file;
    if (file == null) {
      throw StateError('Database has not been opened yet');
    }
    return file;
  }

  @override
  Future<AppDatabase> build() async {
    ref.onDispose(() {
      _current?.close();
      _current = null;
    });
    final docs = await getApplicationDocumentsDirectory();
    final file = File(p.join(docs.path, kDatabaseFileName));
    return _open(file);
  }

  Future<AppDatabase> _open(File file) async {
    final db = AppDatabase.open(file);
    // Force the migration to run before anyone reads from the database.
    await db.ensureDefaultStation(kDefaultStationId);
    await db.countEvents();
    await SessionRepository(db).closeOrphans();
    _current = db;
    _file = file;
    return db;
  }

  /// Replaces the database file with [replacement] and reopens it.
  Future<void> restoreFrom(File replacement) async {
    final file = databaseFile;
    await _current?.close();
    _current = null;
    // Remove WAL side files so the old content cannot leak into the new file.
    for (final suffix in ['', '-wal', '-shm']) {
      final side = File('${file.path}$suffix');
      if (await side.exists()) {
        await side.delete();
      }
    }
    await file.parent.create(recursive: true);
    await replacement.copy(file.path);
    final db = await _open(file);
    state = AsyncData(db);
  }

  /// Flushes WAL pages so the file can be copied into a backup.
  Future<void> checkpoint() async {
    await _current?.checkpoint();
  }
}

final databaseProvider =
    AsyncNotifierProvider<DatabaseController, AppDatabase>(
  DatabaseController.new,
);

final mediaStoreProvider = FutureProvider<MediaStore>((ref) async {
  return MediaStore.openDefault();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider).requireValue);
});

/// Last error that should be surfaced to the user (storage full, etc.).
class AppErrorController extends Notifier<AppFailure?> {
  @override
  AppFailure? build() => null;

  void report(Object error) => state = AppFailure.from(error);

  void clear() => state = null;
}

final appErrorProvider =
    NotifierProvider<AppErrorController, AppFailure?>(AppErrorController.new);

/// Loads and persists [AppSettings].
class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final db = await ref.watch(databaseProvider.future);
    final repo = SettingsRepository(db);
    final raw = await repo.read(AppSettings.storageKey);
    return AppSettings.fromJsonString(raw);
  }

  Future<void> updateSettings(
    AppSettings Function(AppSettings current) transform,
  ) async {
    final current = state.value ?? const AppSettings();
    final next = transform(current);
    state = AsyncData(next);
    final repo = ref.read(settingsRepositoryProvider);
    await repo.write(AppSettings.storageKey, next.toJsonString());
  }

  Future<void> markBackupDone() => updateSettings(
        (settings) => settings.copyWith(lastBackupAt: DateTime.now().toUtc()),
      );
}

final settingsProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

final calibrationRepositoryProvider = Provider<CalibrationRepository>((ref) {
  return CalibrationRepository(ref.watch(databaseProvider).requireValue);
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(ref.watch(databaseProvider).requireValue);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final db = ref.watch(databaseProvider).requireValue;
  final repo = EventRepository(
    db,
    onError: (error) => ref.read(appErrorProvider.notifier).report(error),
  );
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

final violationRepositoryProvider = Provider<ViolationRepository>((ref) {
  return ViolationRepository(ref.watch(databaseProvider).requireValue);
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(databaseProvider).requireValue);
});
