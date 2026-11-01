import 'dart:io';

import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../domain/models/enums.dart';
import '../domain/violation_item.dart';

/// Read/update access to the violation list.
class ViolationRepository {
  ViolationRepository(this._db);

  final AppDatabase _db;

  Future<List<ViolationItem>> list({ViolationStatus? status, int limit = 300}) async {
    final query = _db.select(_db.violations).join([
      innerJoin(
        _db.events,
        _db.events.id.equalsExp(_db.violations.eventId),
      ),
    ])
      ..where(_db.events.isDeleted.equals(false))
      ..orderBy([OrderingTerm.desc(_db.violations.createdAt)])
      ..limit(limit);
    if (status != null) {
      query.where(_db.violations.status.equalsValue(status));
    }
    final rows = await query.get();
    return rows.map((row) {
      final violation = row.readTable(_db.violations);
      final event = row.readTable(_db.events);
      return ViolationItem(
        id: violation.id,
        eventId: violation.eventId,
        limitKmh: violation.limitKmh,
        speedKmh: event.speedKmh,
        status: violation.status,
        createdAt: violation.createdAt,
        imagePath: violation.imagePath,
        vehicleClass: event.vehicleClass,
        direction: event.direction,
        countedAt: event.countedAt,
      );
    }).toList();
  }

  Future<int> pendingCount() async {
    final query = _db.selectOnly(_db.violations)
      ..addColumns([_db.violations.id.count()])
      ..where(_db.violations.status.equalsValue(ViolationStatus.pending));
    final row = await query.getSingle();
    return row.read(_db.violations.id.count()) ?? 0;
  }

  Future<void> setStatus(String violationId, ViolationStatus status) async {
    await (_db.update(_db.violations)
          ..where((t) => t.id.equals(violationId)))
        .write(ViolationsCompanion(status: Value(status)));
  }

  /// Deletes the image file of a violation (used by the retention job and by
  /// the "remove image" action).
  Future<void> deleteImage(String violationId) async {
    final row = await (_db.select(_db.violations)
          ..where((t) => t.id.equals(violationId)))
        .getSingleOrNull();
    final path = row?.imagePath;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await (_db.update(_db.violations)..where((t) => t.id.equals(violationId)))
        .write(const ViolationsCompanion(imagePath: Value(null)));
  }

  Future<void> deleteImagesForSession(String sessionId) async {
    final rows = await (_db.select(_db.violations).join([
      innerJoin(
        _db.events,
        _db.events.id.equalsExp(_db.violations.eventId),
      ),
    ])
          ..where(_db.events.sessionId.equals(sessionId)))
        .get();
    for (final row in rows) {
      final path = row.readTable(_db.violations).imagePath;
      if (path == null) continue;
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }

  /// Removes images older than [retentionDays] and clears their paths.
  Future<int> purgeOldImages({required int retentionDays, DateTime? now}) async {
    if (retentionDays <= 0) return 0;
    final cutoff = (now ?? DateTime.now())
        .toUtc()
        .subtract(Duration(days: retentionDays));
    final rows = await (_db.select(_db.violations)
          ..where((t) =>
              t.createdAt.isSmallerThanValue(cutoff) & t.imagePath.isNotNull()))
        .get();
    var deleted = 0;
    for (final row in rows) {
      final path = row.imagePath;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          try {
            await file.delete();
            deleted += 1;
          } on FileSystemException {
            // Ignore: the file may be locked or already gone.
          }
        }
      }
      await (_db.update(_db.violations)..where((t) => t.id.equals(row.id)))
          .write(const ViolationsCompanion(imagePath: Value(null)));
    }
    return deleted;
  }
}
