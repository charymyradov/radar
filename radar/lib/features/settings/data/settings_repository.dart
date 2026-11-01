import '../../../data/db/app_database.dart';

/// Tiny persistence facade over the `settings_entries` table.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> read(String key) async {
    final rows = await (_db.select(_db.settingsEntries)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return rows?.value;
  }

  Future<void> write(String key, String value) => _db.putSetting(key, value);

  Future<Map<String, String>> readAll() => _db.allSettings();
}
