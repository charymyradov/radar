import 'package:drift/drift.dart';

import '../../domain/models/enums.dart';

/// A physical location / camera mount. The app is single user and normally has
/// exactly one station, but keeping the table makes multi-mount use possible
/// without a migration.
@DataClassName('StationRow')
class Stations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A versioned calibration. Old versions are never deleted so historical
/// events keep pointing at the geometry that produced them.
@DataClassName('CalibrationRow')
class Calibrations extends Table {
  TextColumn get id => text()();
  TextColumn get stationId => text().references(Stations, #id)();
  IntColumn get version => integer()();

  // Line A, normalised to the raw camera image.
  RealColumn get lineAX1 => real()();
  RealColumn get lineAY1 => real()();
  RealColumn get lineAX2 => real()();
  RealColumn get lineAY2 => real()();

  // Line B, same space.
  RealColumn get lineBX1 => real()();
  RealColumn get lineBY1 => real()();
  RealColumn get lineBX2 => real()();
  RealColumn get lineBY2 => real()();

  /// Real distance between the two lines, in metres.
  RealColumn get distanceM => real()();

  /// Optional still image captured when the calibration was saved, used to warn
  /// the user when the camera has been moved since.
  TextColumn get referenceImagePath => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A counting run.
@DataClassName('SessionRow')
class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get stationId => text().references(Stations, #id)();
  TextColumn get calibrationId =>
      text().nullable().references(Calibrations, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One counted vehicle.
@DataClassName('EventRow')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(Sessions, #id)();
  TextColumn get calibrationId =>
      text().nullable().references(Calibrations, #id)();
  DateTimeColumn get countedAt => dateTime()();
  DateTimeColumn get speedMeasuredAt => dateTime().nullable()();
  IntColumn get vehicleClass => intEnum<VehicleClass>()();
  IntColumn get direction => intEnum<TravelDirection>()();
  RealColumn get speedKmh => real().nullable()();
  RealColumn get confidence => real()();
  IntColumn get trackId => integer().withDefault(const Constant(0))();
  BoolColumn get isValid => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// A vehicle that exceeded the configured speed limit. Only violations carry
/// an image, which keeps plates and faces out of the database for normal
/// counting.
@DataClassName('ViolationRow')
class Violations extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().references(Events, #id)();
  RealColumn get limitKmh => real()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get status => intEnum<ViolationStatus>()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Key/value application settings (locale, unit, retention, backup timestamps).
@DataClassName('SettingRow')
class SettingsEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
