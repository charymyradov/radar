import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../domain/geometry/geometry.dart';
import '../domain/calibration.dart';

/// CRUD for versioned calibrations.
///
/// Rules enforced here:
/// * a new save always creates the next version number for the station;
/// * exactly one calibration is active per station;
/// * old versions are never modified or deleted.
class CalibrationRepository {
  CalibrationRepository(this._db);

  final AppDatabase _db;

  Future<List<Calibration>> list({String? stationId}) async {
    final query = _db.select(_db.calibrations)
      ..orderBy([(t) => OrderingTerm.desc(t.version)]);
    if (stationId != null) {
      query.where((t) => t.stationId.equals(stationId));
    }
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  Future<Calibration?> active(String stationId) async {
    final row = await (_db.select(_db.calibrations)
          ..where((t) => t.stationId.equals(stationId) & t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<Calibration?> byId(String id) async {
    final row = await (_db.select(_db.calibrations)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  /// Saves a new calibration version and makes it active.
  Future<Calibration> saveNewVersion({
    required String id,
    required String stationId,
    required CalibrationGeometry geometry,
    String? referenceImagePath,
    DateTime? createdAt,
  }) async {
    if (!geometry.isValid) {
      throw ArgumentError.value(
        geometry,
        'geometry',
        'lines must be drawn and distance must be positive',
      );
    }
    final now = (createdAt ?? DateTime.now()).toUtc();
    late Calibration saved;
    await _db.transaction(() async {
      final maxVersion = await _db
          .customSelect(
            'SELECT COALESCE(MAX(version), 0) AS v FROM calibrations '
            'WHERE station_id = ?',
            variables: [Variable<String>(stationId)],
          )
          .map((row) => row.read<int>('v'))
          .getSingle();
      final version = maxVersion + 1;

      await (_db.update(_db.calibrations)
            ..where((t) => t.stationId.equals(stationId)))
          .write(const CalibrationsCompanion(isActive: Value(false)));

      await _db.into(_db.calibrations).insert(
            CalibrationsCompanion.insert(
              id: id,
              stationId: stationId,
              version: version,
              lineAX1: geometry.lineA.a.x,
              lineAY1: geometry.lineA.a.y,
              lineAX2: geometry.lineA.b.x,
              lineAY2: geometry.lineA.b.y,
              lineBX1: geometry.lineB.a.x,
              lineBY1: geometry.lineB.a.y,
              lineBX2: geometry.lineB.b.x,
              lineBY2: geometry.lineB.b.y,
              distanceM: geometry.distanceMeters,
              referenceImagePath: Value(referenceImagePath),
              isActive: const Value(true),
              createdAt: now,
            ),
          );
      saved = Calibration(
        id: id,
        stationId: stationId,
        version: version,
        geometry: geometry,
        referenceImagePath: referenceImagePath,
        isActive: true,
        createdAt: now,
      );
    });
    return saved;
  }

  Future<void> setActive(String stationId, String calibrationId) async {
    await _db.transaction(() async {
      await (_db.update(_db.calibrations)
            ..where((t) => t.stationId.equals(stationId)))
          .write(const CalibrationsCompanion(isActive: Value(false)));
      await (_db.update(_db.calibrations)
            ..where((t) => t.id.equals(calibrationId)))
          .write(const CalibrationsCompanion(isActive: Value(true)));
    });
  }

  Future<void> updateReferenceImage(String calibrationId, String? path) async {
    await (_db.update(_db.calibrations)
          ..where((t) => t.id.equals(calibrationId)))
        .write(CalibrationsCompanion(referenceImagePath: Value(path)));
  }

  Calibration _toDomain(CalibrationRow row) => Calibration(
        id: row.id,
        stationId: row.stationId,
        version: row.version,
        geometry: CalibrationGeometry(
          lineA: LineSegment(
            NormPoint(row.lineAX1, row.lineAY1),
            NormPoint(row.lineAX2, row.lineAY2),
          ),
          lineB: LineSegment(
            NormPoint(row.lineBX1, row.lineBY1),
            NormPoint(row.lineBX2, row.lineBY2),
          ),
          distanceMeters: row.distanceM,
        ),
        referenceImagePath: row.referenceImagePath,
        isActive: row.isActive,
        createdAt: row.createdAt,
      );
}
