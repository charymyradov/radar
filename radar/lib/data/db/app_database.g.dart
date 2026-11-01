// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StationsTable extends Stations
    with TableInfo<$StationsTable, StationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<StationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StationsTable createAlias(String alias) {
    return $StationsTable(attachedDatabase, alias);
  }
}

class StationRow extends DataClass implements Insertable<StationRow> {
  final String id;
  final String name;
  final String? note;
  final DateTime createdAt;
  const StationRow({
    required this.id,
    required this.name,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StationsCompanion toCompanion(bool nullToAbsent) {
    return StationsCompanion(
      id: Value(id),
      name: Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory StationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StationRow copyWith({
    String? id,
    String? name,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => StationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  StationRow copyWithCompanion(StationsCompanion data) {
    return StationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class StationsCompanion extends UpdateCompanion<StationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StationsCompanion.insert({
    required String id,
    required String name,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<StationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalibrationsTable extends Calibrations
    with TableInfo<$CalibrationsTable, CalibrationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<String> stationId = GeneratedColumn<String>(
    'station_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stations (id)',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineAX1Meta = const VerificationMeta(
    'lineAX1',
  );
  @override
  late final GeneratedColumn<double> lineAX1 = GeneratedColumn<double>(
    'line_a_x1',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineAY1Meta = const VerificationMeta(
    'lineAY1',
  );
  @override
  late final GeneratedColumn<double> lineAY1 = GeneratedColumn<double>(
    'line_a_y1',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineAX2Meta = const VerificationMeta(
    'lineAX2',
  );
  @override
  late final GeneratedColumn<double> lineAX2 = GeneratedColumn<double>(
    'line_a_x2',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineAY2Meta = const VerificationMeta(
    'lineAY2',
  );
  @override
  late final GeneratedColumn<double> lineAY2 = GeneratedColumn<double>(
    'line_a_y2',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineBX1Meta = const VerificationMeta(
    'lineBX1',
  );
  @override
  late final GeneratedColumn<double> lineBX1 = GeneratedColumn<double>(
    'line_b_x1',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineBY1Meta = const VerificationMeta(
    'lineBY1',
  );
  @override
  late final GeneratedColumn<double> lineBY1 = GeneratedColumn<double>(
    'line_b_y1',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineBX2Meta = const VerificationMeta(
    'lineBX2',
  );
  @override
  late final GeneratedColumn<double> lineBX2 = GeneratedColumn<double>(
    'line_b_x2',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineBY2Meta = const VerificationMeta(
    'lineBY2',
  );
  @override
  late final GeneratedColumn<double> lineBY2 = GeneratedColumn<double>(
    'line_b_y2',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<double> distanceM = GeneratedColumn<double>(
    'distance_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceImagePathMeta =
      const VerificationMeta('referenceImagePath');
  @override
  late final GeneratedColumn<String> referenceImagePath =
      GeneratedColumn<String>(
        'reference_image_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stationId,
    version,
    lineAX1,
    lineAY1,
    lineAX2,
    lineAY2,
    lineBX1,
    lineBY1,
    lineBX2,
    lineBY2,
    distanceM,
    referenceImagePath,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibrations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalibrationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('line_a_x1')) {
      context.handle(
        _lineAX1Meta,
        lineAX1.isAcceptableOrUnknown(data['line_a_x1']!, _lineAX1Meta),
      );
    } else if (isInserting) {
      context.missing(_lineAX1Meta);
    }
    if (data.containsKey('line_a_y1')) {
      context.handle(
        _lineAY1Meta,
        lineAY1.isAcceptableOrUnknown(data['line_a_y1']!, _lineAY1Meta),
      );
    } else if (isInserting) {
      context.missing(_lineAY1Meta);
    }
    if (data.containsKey('line_a_x2')) {
      context.handle(
        _lineAX2Meta,
        lineAX2.isAcceptableOrUnknown(data['line_a_x2']!, _lineAX2Meta),
      );
    } else if (isInserting) {
      context.missing(_lineAX2Meta);
    }
    if (data.containsKey('line_a_y2')) {
      context.handle(
        _lineAY2Meta,
        lineAY2.isAcceptableOrUnknown(data['line_a_y2']!, _lineAY2Meta),
      );
    } else if (isInserting) {
      context.missing(_lineAY2Meta);
    }
    if (data.containsKey('line_b_x1')) {
      context.handle(
        _lineBX1Meta,
        lineBX1.isAcceptableOrUnknown(data['line_b_x1']!, _lineBX1Meta),
      );
    } else if (isInserting) {
      context.missing(_lineBX1Meta);
    }
    if (data.containsKey('line_b_y1')) {
      context.handle(
        _lineBY1Meta,
        lineBY1.isAcceptableOrUnknown(data['line_b_y1']!, _lineBY1Meta),
      );
    } else if (isInserting) {
      context.missing(_lineBY1Meta);
    }
    if (data.containsKey('line_b_x2')) {
      context.handle(
        _lineBX2Meta,
        lineBX2.isAcceptableOrUnknown(data['line_b_x2']!, _lineBX2Meta),
      );
    } else if (isInserting) {
      context.missing(_lineBX2Meta);
    }
    if (data.containsKey('line_b_y2')) {
      context.handle(
        _lineBY2Meta,
        lineBY2.isAcceptableOrUnknown(data['line_b_y2']!, _lineBY2Meta),
      );
    } else if (isInserting) {
      context.missing(_lineBY2Meta);
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceMMeta);
    }
    if (data.containsKey('reference_image_path')) {
      context.handle(
        _referenceImagePathMeta,
        referenceImagePath.isAcceptableOrUnknown(
          data['reference_image_path']!,
          _referenceImagePathMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalibrationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalibrationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      lineAX1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_a_x1'],
      )!,
      lineAY1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_a_y1'],
      )!,
      lineAX2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_a_x2'],
      )!,
      lineAY2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_a_y2'],
      )!,
      lineBX1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_b_x1'],
      )!,
      lineBY1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_b_y1'],
      )!,
      lineBX2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_b_x2'],
      )!,
      lineBY2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_b_y2'],
      )!,
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_m'],
      )!,
      referenceImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_image_path'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CalibrationsTable createAlias(String alias) {
    return $CalibrationsTable(attachedDatabase, alias);
  }
}

class CalibrationRow extends DataClass implements Insertable<CalibrationRow> {
  final String id;
  final String stationId;
  final int version;
  final double lineAX1;
  final double lineAY1;
  final double lineAX2;
  final double lineAY2;
  final double lineBX1;
  final double lineBY1;
  final double lineBX2;
  final double lineBY2;

  /// Real distance between the two lines, in metres.
  final double distanceM;

  /// Optional still image captured when the calibration was saved, used to warn
  /// the user when the camera has been moved since.
  final String? referenceImagePath;
  final bool isActive;
  final DateTime createdAt;
  const CalibrationRow({
    required this.id,
    required this.stationId,
    required this.version,
    required this.lineAX1,
    required this.lineAY1,
    required this.lineAX2,
    required this.lineAY2,
    required this.lineBX1,
    required this.lineBY1,
    required this.lineBX2,
    required this.lineBY2,
    required this.distanceM,
    this.referenceImagePath,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['station_id'] = Variable<String>(stationId);
    map['version'] = Variable<int>(version);
    map['line_a_x1'] = Variable<double>(lineAX1);
    map['line_a_y1'] = Variable<double>(lineAY1);
    map['line_a_x2'] = Variable<double>(lineAX2);
    map['line_a_y2'] = Variable<double>(lineAY2);
    map['line_b_x1'] = Variable<double>(lineBX1);
    map['line_b_y1'] = Variable<double>(lineBY1);
    map['line_b_x2'] = Variable<double>(lineBX2);
    map['line_b_y2'] = Variable<double>(lineBY2);
    map['distance_m'] = Variable<double>(distanceM);
    if (!nullToAbsent || referenceImagePath != null) {
      map['reference_image_path'] = Variable<String>(referenceImagePath);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CalibrationsCompanion toCompanion(bool nullToAbsent) {
    return CalibrationsCompanion(
      id: Value(id),
      stationId: Value(stationId),
      version: Value(version),
      lineAX1: Value(lineAX1),
      lineAY1: Value(lineAY1),
      lineAX2: Value(lineAX2),
      lineAY2: Value(lineAY2),
      lineBX1: Value(lineBX1),
      lineBY1: Value(lineBY1),
      lineBX2: Value(lineBX2),
      lineBY2: Value(lineBY2),
      distanceM: Value(distanceM),
      referenceImagePath: referenceImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceImagePath),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CalibrationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalibrationRow(
      id: serializer.fromJson<String>(json['id']),
      stationId: serializer.fromJson<String>(json['stationId']),
      version: serializer.fromJson<int>(json['version']),
      lineAX1: serializer.fromJson<double>(json['lineAX1']),
      lineAY1: serializer.fromJson<double>(json['lineAY1']),
      lineAX2: serializer.fromJson<double>(json['lineAX2']),
      lineAY2: serializer.fromJson<double>(json['lineAY2']),
      lineBX1: serializer.fromJson<double>(json['lineBX1']),
      lineBY1: serializer.fromJson<double>(json['lineBY1']),
      lineBX2: serializer.fromJson<double>(json['lineBX2']),
      lineBY2: serializer.fromJson<double>(json['lineBY2']),
      distanceM: serializer.fromJson<double>(json['distanceM']),
      referenceImagePath: serializer.fromJson<String?>(
        json['referenceImagePath'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stationId': serializer.toJson<String>(stationId),
      'version': serializer.toJson<int>(version),
      'lineAX1': serializer.toJson<double>(lineAX1),
      'lineAY1': serializer.toJson<double>(lineAY1),
      'lineAX2': serializer.toJson<double>(lineAX2),
      'lineAY2': serializer.toJson<double>(lineAY2),
      'lineBX1': serializer.toJson<double>(lineBX1),
      'lineBY1': serializer.toJson<double>(lineBY1),
      'lineBX2': serializer.toJson<double>(lineBX2),
      'lineBY2': serializer.toJson<double>(lineBY2),
      'distanceM': serializer.toJson<double>(distanceM),
      'referenceImagePath': serializer.toJson<String?>(referenceImagePath),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CalibrationRow copyWith({
    String? id,
    String? stationId,
    int? version,
    double? lineAX1,
    double? lineAY1,
    double? lineAX2,
    double? lineAY2,
    double? lineBX1,
    double? lineBY1,
    double? lineBX2,
    double? lineBY2,
    double? distanceM,
    Value<String?> referenceImagePath = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => CalibrationRow(
    id: id ?? this.id,
    stationId: stationId ?? this.stationId,
    version: version ?? this.version,
    lineAX1: lineAX1 ?? this.lineAX1,
    lineAY1: lineAY1 ?? this.lineAY1,
    lineAX2: lineAX2 ?? this.lineAX2,
    lineAY2: lineAY2 ?? this.lineAY2,
    lineBX1: lineBX1 ?? this.lineBX1,
    lineBY1: lineBY1 ?? this.lineBY1,
    lineBX2: lineBX2 ?? this.lineBX2,
    lineBY2: lineBY2 ?? this.lineBY2,
    distanceM: distanceM ?? this.distanceM,
    referenceImagePath: referenceImagePath.present
        ? referenceImagePath.value
        : this.referenceImagePath,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  CalibrationRow copyWithCompanion(CalibrationsCompanion data) {
    return CalibrationRow(
      id: data.id.present ? data.id.value : this.id,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      version: data.version.present ? data.version.value : this.version,
      lineAX1: data.lineAX1.present ? data.lineAX1.value : this.lineAX1,
      lineAY1: data.lineAY1.present ? data.lineAY1.value : this.lineAY1,
      lineAX2: data.lineAX2.present ? data.lineAX2.value : this.lineAX2,
      lineAY2: data.lineAY2.present ? data.lineAY2.value : this.lineAY2,
      lineBX1: data.lineBX1.present ? data.lineBX1.value : this.lineBX1,
      lineBY1: data.lineBY1.present ? data.lineBY1.value : this.lineBY1,
      lineBX2: data.lineBX2.present ? data.lineBX2.value : this.lineBX2,
      lineBY2: data.lineBY2.present ? data.lineBY2.value : this.lineBY2,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      referenceImagePath: data.referenceImagePath.present
          ? data.referenceImagePath.value
          : this.referenceImagePath,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationRow(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('version: $version, ')
          ..write('lineAX1: $lineAX1, ')
          ..write('lineAY1: $lineAY1, ')
          ..write('lineAX2: $lineAX2, ')
          ..write('lineAY2: $lineAY2, ')
          ..write('lineBX1: $lineBX1, ')
          ..write('lineBY1: $lineBY1, ')
          ..write('lineBX2: $lineBX2, ')
          ..write('lineBY2: $lineBY2, ')
          ..write('distanceM: $distanceM, ')
          ..write('referenceImagePath: $referenceImagePath, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stationId,
    version,
    lineAX1,
    lineAY1,
    lineAX2,
    lineAY2,
    lineBX1,
    lineBY1,
    lineBX2,
    lineBY2,
    distanceM,
    referenceImagePath,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalibrationRow &&
          other.id == this.id &&
          other.stationId == this.stationId &&
          other.version == this.version &&
          other.lineAX1 == this.lineAX1 &&
          other.lineAY1 == this.lineAY1 &&
          other.lineAX2 == this.lineAX2 &&
          other.lineAY2 == this.lineAY2 &&
          other.lineBX1 == this.lineBX1 &&
          other.lineBY1 == this.lineBY1 &&
          other.lineBX2 == this.lineBX2 &&
          other.lineBY2 == this.lineBY2 &&
          other.distanceM == this.distanceM &&
          other.referenceImagePath == this.referenceImagePath &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CalibrationsCompanion extends UpdateCompanion<CalibrationRow> {
  final Value<String> id;
  final Value<String> stationId;
  final Value<int> version;
  final Value<double> lineAX1;
  final Value<double> lineAY1;
  final Value<double> lineAX2;
  final Value<double> lineAY2;
  final Value<double> lineBX1;
  final Value<double> lineBY1;
  final Value<double> lineBX2;
  final Value<double> lineBY2;
  final Value<double> distanceM;
  final Value<String?> referenceImagePath;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CalibrationsCompanion({
    this.id = const Value.absent(),
    this.stationId = const Value.absent(),
    this.version = const Value.absent(),
    this.lineAX1 = const Value.absent(),
    this.lineAY1 = const Value.absent(),
    this.lineAX2 = const Value.absent(),
    this.lineAY2 = const Value.absent(),
    this.lineBX1 = const Value.absent(),
    this.lineBY1 = const Value.absent(),
    this.lineBX2 = const Value.absent(),
    this.lineBY2 = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.referenceImagePath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalibrationsCompanion.insert({
    required String id,
    required String stationId,
    required int version,
    required double lineAX1,
    required double lineAY1,
    required double lineAX2,
    required double lineAY2,
    required double lineBX1,
    required double lineBY1,
    required double lineBX2,
    required double lineBY2,
    required double distanceM,
    this.referenceImagePath = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       stationId = Value(stationId),
       version = Value(version),
       lineAX1 = Value(lineAX1),
       lineAY1 = Value(lineAY1),
       lineAX2 = Value(lineAX2),
       lineAY2 = Value(lineAY2),
       lineBX1 = Value(lineBX1),
       lineBY1 = Value(lineBY1),
       lineBX2 = Value(lineBX2),
       lineBY2 = Value(lineBY2),
       distanceM = Value(distanceM),
       createdAt = Value(createdAt);
  static Insertable<CalibrationRow> custom({
    Expression<String>? id,
    Expression<String>? stationId,
    Expression<int>? version,
    Expression<double>? lineAX1,
    Expression<double>? lineAY1,
    Expression<double>? lineAX2,
    Expression<double>? lineAY2,
    Expression<double>? lineBX1,
    Expression<double>? lineBY1,
    Expression<double>? lineBX2,
    Expression<double>? lineBY2,
    Expression<double>? distanceM,
    Expression<String>? referenceImagePath,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stationId != null) 'station_id': stationId,
      if (version != null) 'version': version,
      if (lineAX1 != null) 'line_a_x1': lineAX1,
      if (lineAY1 != null) 'line_a_y1': lineAY1,
      if (lineAX2 != null) 'line_a_x2': lineAX2,
      if (lineAY2 != null) 'line_a_y2': lineAY2,
      if (lineBX1 != null) 'line_b_x1': lineBX1,
      if (lineBY1 != null) 'line_b_y1': lineBY1,
      if (lineBX2 != null) 'line_b_x2': lineBX2,
      if (lineBY2 != null) 'line_b_y2': lineBY2,
      if (distanceM != null) 'distance_m': distanceM,
      if (referenceImagePath != null)
        'reference_image_path': referenceImagePath,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalibrationsCompanion copyWith({
    Value<String>? id,
    Value<String>? stationId,
    Value<int>? version,
    Value<double>? lineAX1,
    Value<double>? lineAY1,
    Value<double>? lineAX2,
    Value<double>? lineAY2,
    Value<double>? lineBX1,
    Value<double>? lineBY1,
    Value<double>? lineBX2,
    Value<double>? lineBY2,
    Value<double>? distanceM,
    Value<String?>? referenceImagePath,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CalibrationsCompanion(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      version: version ?? this.version,
      lineAX1: lineAX1 ?? this.lineAX1,
      lineAY1: lineAY1 ?? this.lineAY1,
      lineAX2: lineAX2 ?? this.lineAX2,
      lineAY2: lineAY2 ?? this.lineAY2,
      lineBX1: lineBX1 ?? this.lineBX1,
      lineBY1: lineBY1 ?? this.lineBY1,
      lineBX2: lineBX2 ?? this.lineBX2,
      lineBY2: lineBY2 ?? this.lineBY2,
      distanceM: distanceM ?? this.distanceM,
      referenceImagePath: referenceImagePath ?? this.referenceImagePath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<String>(stationId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (lineAX1.present) {
      map['line_a_x1'] = Variable<double>(lineAX1.value);
    }
    if (lineAY1.present) {
      map['line_a_y1'] = Variable<double>(lineAY1.value);
    }
    if (lineAX2.present) {
      map['line_a_x2'] = Variable<double>(lineAX2.value);
    }
    if (lineAY2.present) {
      map['line_a_y2'] = Variable<double>(lineAY2.value);
    }
    if (lineBX1.present) {
      map['line_b_x1'] = Variable<double>(lineBX1.value);
    }
    if (lineBY1.present) {
      map['line_b_y1'] = Variable<double>(lineBY1.value);
    }
    if (lineBX2.present) {
      map['line_b_x2'] = Variable<double>(lineBX2.value);
    }
    if (lineBY2.present) {
      map['line_b_y2'] = Variable<double>(lineBY2.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<double>(distanceM.value);
    }
    if (referenceImagePath.present) {
      map['reference_image_path'] = Variable<String>(referenceImagePath.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationsCompanion(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('version: $version, ')
          ..write('lineAX1: $lineAX1, ')
          ..write('lineAY1: $lineAY1, ')
          ..write('lineAX2: $lineAX2, ')
          ..write('lineAY2: $lineAY2, ')
          ..write('lineBX1: $lineBX1, ')
          ..write('lineBY1: $lineBY1, ')
          ..write('lineBX2: $lineBX2, ')
          ..write('lineBY2: $lineBY2, ')
          ..write('distanceM: $distanceM, ')
          ..write('referenceImagePath: $referenceImagePath, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<String> stationId = GeneratedColumn<String>(
    'station_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stations (id)',
    ),
  );
  static const VerificationMeta _calibrationIdMeta = const VerificationMeta(
    'calibrationId',
  );
  @override
  late final GeneratedColumn<String> calibrationId = GeneratedColumn<String>(
    'calibration_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calibrations (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stationId,
    calibrationId,
    startedAt,
    endedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('calibration_id')) {
      context.handle(
        _calibrationIdMeta,
        calibrationId.isAcceptableOrUnknown(
          data['calibration_id']!,
          _calibrationIdMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_id'],
      )!,
      calibrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calibration_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final String stationId;
  final String? calibrationId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? note;
  const SessionRow({
    required this.id,
    required this.stationId,
    this.calibrationId,
    required this.startedAt,
    this.endedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['station_id'] = Variable<String>(stationId);
    if (!nullToAbsent || calibrationId != null) {
      map['calibration_id'] = Variable<String>(calibrationId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      stationId: Value(stationId),
      calibrationId: calibrationId == null && nullToAbsent
          ? const Value.absent()
          : Value(calibrationId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      stationId: serializer.fromJson<String>(json['stationId']),
      calibrationId: serializer.fromJson<String?>(json['calibrationId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stationId': serializer.toJson<String>(stationId),
      'calibrationId': serializer.toJson<String?>(calibrationId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  SessionRow copyWith({
    String? id,
    String? stationId,
    Value<String?> calibrationId = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SessionRow(
    id: id ?? this.id,
    stationId: stationId ?? this.stationId,
    calibrationId: calibrationId.present
        ? calibrationId.value
        : this.calibrationId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    note: note.present ? note.value : this.note,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      calibrationId: data.calibrationId.present
          ? data.calibrationId.value
          : this.calibrationId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('calibrationId: $calibrationId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, stationId, calibrationId, startedAt, endedAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.stationId == this.stationId &&
          other.calibrationId == this.calibrationId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.note == this.note);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<String> stationId;
  final Value<String?> calibrationId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.stationId = const Value.absent(),
    this.calibrationId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String stationId,
    this.calibrationId = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       stationId = Value(stationId),
       startedAt = Value(startedAt);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<String>? stationId,
    Expression<String>? calibrationId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stationId != null) 'station_id': stationId,
      if (calibrationId != null) 'calibration_id': calibrationId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? stationId,
    Value<String?>? calibrationId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      calibrationId: calibrationId ?? this.calibrationId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<String>(stationId.value);
    }
    if (calibrationId.present) {
      map['calibration_id'] = Variable<String>(calibrationId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('calibrationId: $calibrationId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, EventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _calibrationIdMeta = const VerificationMeta(
    'calibrationId',
  );
  @override
  late final GeneratedColumn<String> calibrationId = GeneratedColumn<String>(
    'calibration_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calibrations (id)',
    ),
  );
  static const VerificationMeta _countedAtMeta = const VerificationMeta(
    'countedAt',
  );
  @override
  late final GeneratedColumn<DateTime> countedAt = GeneratedColumn<DateTime>(
    'counted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeasuredAtMeta = const VerificationMeta(
    'speedMeasuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> speedMeasuredAt =
      GeneratedColumn<DateTime>(
        'speed_measured_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<VehicleClass, int> vehicleClass =
      GeneratedColumn<int>(
        'vehicle_class',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<VehicleClass>($EventsTable.$convertervehicleClass);
  @override
  late final GeneratedColumnWithTypeConverter<TravelDirection, int> direction =
      GeneratedColumn<int>(
        'direction',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TravelDirection>($EventsTable.$converterdirection);
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isValidMeta = const VerificationMeta(
    'isValid',
  );
  @override
  late final GeneratedColumn<bool> isValid = GeneratedColumn<bool>(
    'is_valid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_valid" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    calibrationId,
    countedAt,
    speedMeasuredAt,
    vehicleClass,
    direction,
    speedKmh,
    confidence,
    trackId,
    isValid,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('calibration_id')) {
      context.handle(
        _calibrationIdMeta,
        calibrationId.isAcceptableOrUnknown(
          data['calibration_id']!,
          _calibrationIdMeta,
        ),
      );
    }
    if (data.containsKey('counted_at')) {
      context.handle(
        _countedAtMeta,
        countedAt.isAcceptableOrUnknown(data['counted_at']!, _countedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_countedAtMeta);
    }
    if (data.containsKey('speed_measured_at')) {
      context.handle(
        _speedMeasuredAtMeta,
        speedMeasuredAt.isAcceptableOrUnknown(
          data['speed_measured_at']!,
          _speedMeasuredAtMeta,
        ),
      );
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    }
    if (data.containsKey('is_valid')) {
      context.handle(
        _isValidMeta,
        isValid.isAcceptableOrUnknown(data['is_valid']!, _isValidMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      calibrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calibration_id'],
      ),
      countedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}counted_at'],
      )!,
      speedMeasuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}speed_measured_at'],
      ),
      vehicleClass: $EventsTable.$convertervehicleClass.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}vehicle_class'],
        )!,
      ),
      direction: $EventsTable.$converterdirection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}direction'],
        )!,
      ),
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_id'],
      )!,
      isValid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_valid'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<VehicleClass, int, int> $convertervehicleClass =
      const EnumIndexConverter<VehicleClass>(VehicleClass.values);
  static JsonTypeConverter2<TravelDirection, int, int> $converterdirection =
      const EnumIndexConverter<TravelDirection>(TravelDirection.values);
}

class EventRow extends DataClass implements Insertable<EventRow> {
  final String id;
  final String sessionId;
  final String? calibrationId;
  final DateTime countedAt;
  final DateTime? speedMeasuredAt;
  final VehicleClass vehicleClass;
  final TravelDirection direction;
  final double? speedKmh;
  final double confidence;
  final int trackId;
  final bool isValid;
  final bool isDeleted;
  const EventRow({
    required this.id,
    required this.sessionId,
    this.calibrationId,
    required this.countedAt,
    this.speedMeasuredAt,
    required this.vehicleClass,
    required this.direction,
    this.speedKmh,
    required this.confidence,
    required this.trackId,
    required this.isValid,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || calibrationId != null) {
      map['calibration_id'] = Variable<String>(calibrationId);
    }
    map['counted_at'] = Variable<DateTime>(countedAt);
    if (!nullToAbsent || speedMeasuredAt != null) {
      map['speed_measured_at'] = Variable<DateTime>(speedMeasuredAt);
    }
    {
      map['vehicle_class'] = Variable<int>(
        $EventsTable.$convertervehicleClass.toSql(vehicleClass),
      );
    }
    {
      map['direction'] = Variable<int>(
        $EventsTable.$converterdirection.toSql(direction),
      );
    }
    if (!nullToAbsent || speedKmh != null) {
      map['speed_kmh'] = Variable<double>(speedKmh);
    }
    map['confidence'] = Variable<double>(confidence);
    map['track_id'] = Variable<int>(trackId);
    map['is_valid'] = Variable<bool>(isValid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      calibrationId: calibrationId == null && nullToAbsent
          ? const Value.absent()
          : Value(calibrationId),
      countedAt: Value(countedAt),
      speedMeasuredAt: speedMeasuredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(speedMeasuredAt),
      vehicleClass: Value(vehicleClass),
      direction: Value(direction),
      speedKmh: speedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(speedKmh),
      confidence: Value(confidence),
      trackId: Value(trackId),
      isValid: Value(isValid),
      isDeleted: Value(isDeleted),
    );
  }

  factory EventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      calibrationId: serializer.fromJson<String?>(json['calibrationId']),
      countedAt: serializer.fromJson<DateTime>(json['countedAt']),
      speedMeasuredAt: serializer.fromJson<DateTime?>(json['speedMeasuredAt']),
      vehicleClass: $EventsTable.$convertervehicleClass.fromJson(
        serializer.fromJson<int>(json['vehicleClass']),
      ),
      direction: $EventsTable.$converterdirection.fromJson(
        serializer.fromJson<int>(json['direction']),
      ),
      speedKmh: serializer.fromJson<double?>(json['speedKmh']),
      confidence: serializer.fromJson<double>(json['confidence']),
      trackId: serializer.fromJson<int>(json['trackId']),
      isValid: serializer.fromJson<bool>(json['isValid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'calibrationId': serializer.toJson<String?>(calibrationId),
      'countedAt': serializer.toJson<DateTime>(countedAt),
      'speedMeasuredAt': serializer.toJson<DateTime?>(speedMeasuredAt),
      'vehicleClass': serializer.toJson<int>(
        $EventsTable.$convertervehicleClass.toJson(vehicleClass),
      ),
      'direction': serializer.toJson<int>(
        $EventsTable.$converterdirection.toJson(direction),
      ),
      'speedKmh': serializer.toJson<double?>(speedKmh),
      'confidence': serializer.toJson<double>(confidence),
      'trackId': serializer.toJson<int>(trackId),
      'isValid': serializer.toJson<bool>(isValid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  EventRow copyWith({
    String? id,
    String? sessionId,
    Value<String?> calibrationId = const Value.absent(),
    DateTime? countedAt,
    Value<DateTime?> speedMeasuredAt = const Value.absent(),
    VehicleClass? vehicleClass,
    TravelDirection? direction,
    Value<double?> speedKmh = const Value.absent(),
    double? confidence,
    int? trackId,
    bool? isValid,
    bool? isDeleted,
  }) => EventRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    calibrationId: calibrationId.present
        ? calibrationId.value
        : this.calibrationId,
    countedAt: countedAt ?? this.countedAt,
    speedMeasuredAt: speedMeasuredAt.present
        ? speedMeasuredAt.value
        : this.speedMeasuredAt,
    vehicleClass: vehicleClass ?? this.vehicleClass,
    direction: direction ?? this.direction,
    speedKmh: speedKmh.present ? speedKmh.value : this.speedKmh,
    confidence: confidence ?? this.confidence,
    trackId: trackId ?? this.trackId,
    isValid: isValid ?? this.isValid,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  EventRow copyWithCompanion(EventsCompanion data) {
    return EventRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      calibrationId: data.calibrationId.present
          ? data.calibrationId.value
          : this.calibrationId,
      countedAt: data.countedAt.present ? data.countedAt.value : this.countedAt,
      speedMeasuredAt: data.speedMeasuredAt.present
          ? data.speedMeasuredAt.value
          : this.speedMeasuredAt,
      vehicleClass: data.vehicleClass.present
          ? data.vehicleClass.value
          : this.vehicleClass,
      direction: data.direction.present ? data.direction.value : this.direction,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      isValid: data.isValid.present ? data.isValid.value : this.isValid,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('calibrationId: $calibrationId, ')
          ..write('countedAt: $countedAt, ')
          ..write('speedMeasuredAt: $speedMeasuredAt, ')
          ..write('vehicleClass: $vehicleClass, ')
          ..write('direction: $direction, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('confidence: $confidence, ')
          ..write('trackId: $trackId, ')
          ..write('isValid: $isValid, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    calibrationId,
    countedAt,
    speedMeasuredAt,
    vehicleClass,
    direction,
    speedKmh,
    confidence,
    trackId,
    isValid,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.calibrationId == this.calibrationId &&
          other.countedAt == this.countedAt &&
          other.speedMeasuredAt == this.speedMeasuredAt &&
          other.vehicleClass == this.vehicleClass &&
          other.direction == this.direction &&
          other.speedKmh == this.speedKmh &&
          other.confidence == this.confidence &&
          other.trackId == this.trackId &&
          other.isValid == this.isValid &&
          other.isDeleted == this.isDeleted);
}

class EventsCompanion extends UpdateCompanion<EventRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String?> calibrationId;
  final Value<DateTime> countedAt;
  final Value<DateTime?> speedMeasuredAt;
  final Value<VehicleClass> vehicleClass;
  final Value<TravelDirection> direction;
  final Value<double?> speedKmh;
  final Value<double> confidence;
  final Value<int> trackId;
  final Value<bool> isValid;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.calibrationId = const Value.absent(),
    this.countedAt = const Value.absent(),
    this.speedMeasuredAt = const Value.absent(),
    this.vehicleClass = const Value.absent(),
    this.direction = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.confidence = const Value.absent(),
    this.trackId = const Value.absent(),
    this.isValid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String sessionId,
    this.calibrationId = const Value.absent(),
    required DateTime countedAt,
    this.speedMeasuredAt = const Value.absent(),
    required VehicleClass vehicleClass,
    required TravelDirection direction,
    this.speedKmh = const Value.absent(),
    required double confidence,
    this.trackId = const Value.absent(),
    this.isValid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       countedAt = Value(countedAt),
       vehicleClass = Value(vehicleClass),
       direction = Value(direction),
       confidence = Value(confidence);
  static Insertable<EventRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? calibrationId,
    Expression<DateTime>? countedAt,
    Expression<DateTime>? speedMeasuredAt,
    Expression<int>? vehicleClass,
    Expression<int>? direction,
    Expression<double>? speedKmh,
    Expression<double>? confidence,
    Expression<int>? trackId,
    Expression<bool>? isValid,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (calibrationId != null) 'calibration_id': calibrationId,
      if (countedAt != null) 'counted_at': countedAt,
      if (speedMeasuredAt != null) 'speed_measured_at': speedMeasuredAt,
      if (vehicleClass != null) 'vehicle_class': vehicleClass,
      if (direction != null) 'direction': direction,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (confidence != null) 'confidence': confidence,
      if (trackId != null) 'track_id': trackId,
      if (isValid != null) 'is_valid': isValid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String?>? calibrationId,
    Value<DateTime>? countedAt,
    Value<DateTime?>? speedMeasuredAt,
    Value<VehicleClass>? vehicleClass,
    Value<TravelDirection>? direction,
    Value<double?>? speedKmh,
    Value<double>? confidence,
    Value<int>? trackId,
    Value<bool>? isValid,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      calibrationId: calibrationId ?? this.calibrationId,
      countedAt: countedAt ?? this.countedAt,
      speedMeasuredAt: speedMeasuredAt ?? this.speedMeasuredAt,
      vehicleClass: vehicleClass ?? this.vehicleClass,
      direction: direction ?? this.direction,
      speedKmh: speedKmh ?? this.speedKmh,
      confidence: confidence ?? this.confidence,
      trackId: trackId ?? this.trackId,
      isValid: isValid ?? this.isValid,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (calibrationId.present) {
      map['calibration_id'] = Variable<String>(calibrationId.value);
    }
    if (countedAt.present) {
      map['counted_at'] = Variable<DateTime>(countedAt.value);
    }
    if (speedMeasuredAt.present) {
      map['speed_measured_at'] = Variable<DateTime>(speedMeasuredAt.value);
    }
    if (vehicleClass.present) {
      map['vehicle_class'] = Variable<int>(
        $EventsTable.$convertervehicleClass.toSql(vehicleClass.value),
      );
    }
    if (direction.present) {
      map['direction'] = Variable<int>(
        $EventsTable.$converterdirection.toSql(direction.value),
      );
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (isValid.present) {
      map['is_valid'] = Variable<bool>(isValid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('calibrationId: $calibrationId, ')
          ..write('countedAt: $countedAt, ')
          ..write('speedMeasuredAt: $speedMeasuredAt, ')
          ..write('vehicleClass: $vehicleClass, ')
          ..write('direction: $direction, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('confidence: $confidence, ')
          ..write('trackId: $trackId, ')
          ..write('isValid: $isValid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ViolationsTable extends Violations
    with TableInfo<$ViolationsTable, ViolationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ViolationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _limitKmhMeta = const VerificationMeta(
    'limitKmh',
  );
  @override
  late final GeneratedColumn<double> limitKmh = GeneratedColumn<double>(
    'limit_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ViolationStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ViolationStatus>($ViolationsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    limitKmh,
    imagePath,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'violations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ViolationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('limit_kmh')) {
      context.handle(
        _limitKmhMeta,
        limitKmh.isAcceptableOrUnknown(data['limit_kmh']!, _limitKmhMeta),
      );
    } else if (isInserting) {
      context.missing(_limitKmhMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ViolationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ViolationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      limitKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}limit_kmh'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      status: $ViolationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ViolationsTable createAlias(String alias) {
    return $ViolationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ViolationStatus, int, int> $converterstatus =
      const EnumIndexConverter<ViolationStatus>(ViolationStatus.values);
}

class ViolationRow extends DataClass implements Insertable<ViolationRow> {
  final String id;
  final String eventId;
  final double limitKmh;
  final String? imagePath;
  final ViolationStatus status;
  final DateTime createdAt;
  const ViolationRow({
    required this.id,
    required this.eventId,
    required this.limitKmh,
    this.imagePath,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['limit_kmh'] = Variable<double>(limitKmh);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    {
      map['status'] = Variable<int>(
        $ViolationsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ViolationsCompanion toCompanion(bool nullToAbsent) {
    return ViolationsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      limitKmh: Value(limitKmh),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ViolationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ViolationRow(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      limitKmh: serializer.fromJson<double>(json['limitKmh']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      status: $ViolationsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'limitKmh': serializer.toJson<double>(limitKmh),
      'imagePath': serializer.toJson<String?>(imagePath),
      'status': serializer.toJson<int>(
        $ViolationsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ViolationRow copyWith({
    String? id,
    String? eventId,
    double? limitKmh,
    Value<String?> imagePath = const Value.absent(),
    ViolationStatus? status,
    DateTime? createdAt,
  }) => ViolationRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    limitKmh: limitKmh ?? this.limitKmh,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ViolationRow copyWithCompanion(ViolationsCompanion data) {
    return ViolationRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      limitKmh: data.limitKmh.present ? data.limitKmh.value : this.limitKmh,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ViolationRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('limitKmh: $limitKmh, ')
          ..write('imagePath: $imagePath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventId, limitKmh, imagePath, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ViolationRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.limitKmh == this.limitKmh &&
          other.imagePath == this.imagePath &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ViolationsCompanion extends UpdateCompanion<ViolationRow> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<double> limitKmh;
  final Value<String?> imagePath;
  final Value<ViolationStatus> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ViolationsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.limitKmh = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ViolationsCompanion.insert({
    required String id,
    required String eventId,
    required double limitKmh,
    this.imagePath = const Value.absent(),
    required ViolationStatus status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       limitKmh = Value(limitKmh),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ViolationRow> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<double>? limitKmh,
    Expression<String>? imagePath,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (limitKmh != null) 'limit_kmh': limitKmh,
      if (imagePath != null) 'image_path': imagePath,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ViolationsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<double>? limitKmh,
    Value<String?>? imagePath,
    Value<ViolationStatus>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ViolationsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      limitKmh: limitKmh ?? this.limitKmh,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (limitKmh.present) {
      map['limit_kmh'] = Variable<double>(limitKmh.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $ViolationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ViolationsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('limitKmh: $limitKmh, ')
          ..write('imagePath: $imagePath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StationsTable stations = $StationsTable(this);
  late final $CalibrationsTable calibrations = $CalibrationsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $ViolationsTable violations = $ViolationsTable(this);
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    stations,
    calibrations,
    sessions,
    events,
    violations,
    settingsEntries,
  ];
}

typedef $$StationsTableCreateCompanionBuilder = StationsCompanion Function({
  required String id,
  required String name,
  Value<String?> note,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$StationsTableUpdateCompanionBuilder = StationsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$StationsTableReferences
    extends BaseReferences<_$AppDatabase, $StationsTable, StationRow> {
  $$StationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CalibrationsTable, List<CalibrationRow>>
  _calibrationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.calibrations,
    aliasName: 'stations__id__calibrations__station_id',
  );

  $$CalibrationsTableProcessedTableManager get calibrationsRefs {
    final manager = $$CalibrationsTableTableManager(
      $_db,
      $_db.calibrations,
    ).filter((f) => f.stationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_calibrationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<SessionRow>>
  _sessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'stations__id__sessions__station_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.stationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StationsTableFilterComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> calibrationsRefs(
    Expression<bool> Function($$CalibrationsTableFilterComposer f) f,
  ) {
    final $$CalibrationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableFilterComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> calibrationsRefs<T extends Object>(
    Expression<T> Function($$CalibrationsTableAnnotationComposer a) f,
  ) {
    final $$CalibrationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StationsTable,
          StationRow,
          $$StationsTableFilterComposer,
          $$StationsTableOrderingComposer,
          $$StationsTableAnnotationComposer,
          $$StationsTableCreateCompanionBuilder,
          $$StationsTableUpdateCompanionBuilder,
          (StationRow, $$StationsTableReferences),
          StationRow,
          PrefetchHooks Function({bool calibrationsRefs, bool sessionsRefs})
        > {
  $$StationsTableTableManager(_$AppDatabase db, $StationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationsCompanion(
                id: id,
                name: name,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StationsCompanion.insert(
                id: id,
                name: name,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StationsTable, StationRow>(table),
                  $$StationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({calibrationsRefs = false, sessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (calibrationsRefs) db.calibrations,
                    if (sessionsRefs) db.sessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (calibrationsRefs)
                        await $_getPrefetchedDataByColumns<
                          StationRow,
                          $StationsTable,
                          CalibrationRow,
                          $CalibrationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$StationsTableReferences
                              ._calibrationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StationsTableReferences(
                                db,
                                table,
                                p0,
                              ).calibrationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'station_id',
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          StationRow,
                          $StationsTable,
                          SessionRow,
                          $SessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$StationsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StationsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'station_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StationsTable,
      StationRow,
      $$StationsTableFilterComposer,
      $$StationsTableOrderingComposer,
      $$StationsTableAnnotationComposer,
      $$StationsTableCreateCompanionBuilder,
      $$StationsTableUpdateCompanionBuilder,
      (StationRow, $$StationsTableReferences),
      StationRow,
      PrefetchHooks Function({bool calibrationsRefs, bool sessionsRefs})
    >;
typedef $$CalibrationsTableCreateCompanionBuilder =
    CalibrationsCompanion Function({
      required String id,
      required String stationId,
      required int version,
      required double lineAX1,
      required double lineAY1,
      required double lineAX2,
      required double lineAY2,
      required double lineBX1,
      required double lineBY1,
      required double lineBX2,
      required double lineBY2,
      required double distanceM,
      Value<String?> referenceImagePath,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CalibrationsTableUpdateCompanionBuilder =
    CalibrationsCompanion Function({
      Value<String> id,
      Value<String> stationId,
      Value<int> version,
      Value<double> lineAX1,
      Value<double> lineAY1,
      Value<double> lineAX2,
      Value<double> lineAY2,
      Value<double> lineBX1,
      Value<double> lineBY1,
      Value<double> lineBX2,
      Value<double> lineBY2,
      Value<double> distanceM,
      Value<String?> referenceImagePath,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CalibrationsTableReferences
    extends BaseReferences<_$AppDatabase, $CalibrationsTable, CalibrationRow> {
  $$CalibrationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StationsTable _stationIdTable(_$AppDatabase db) =>
      db.stations.createAlias('calibrations__station_id__stations__id');

  $$StationsTableProcessedTableManager get stationId {
    final $_column = $_itemColumn<String>('station_id')!;

    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<SessionRow>>
  _sessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'calibrations__id__sessions__calibration_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.calibrationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<EventRow>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'calibrations__id__events__calibration_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.calibrationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalibrationsTableFilterComposer
    extends Composer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineAX1 => $composableBuilder(
    column: $table.lineAX1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineAY1 => $composableBuilder(
    column: $table.lineAY1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineAX2 => $composableBuilder(
    column: $table.lineAX2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineAY2 => $composableBuilder(
    column: $table.lineAY2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineBX1 => $composableBuilder(
    column: $table.lineBX1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineBY1 => $composableBuilder(
    column: $table.lineBY1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineBX2 => $composableBuilder(
    column: $table.lineBX2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineBY2 => $composableBuilder(
    column: $table.lineBY2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceImagePath => $composableBuilder(
    column: $table.referenceImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StationsTableFilterComposer get stationId {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.calibrationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.calibrationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalibrationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineAX1 => $composableBuilder(
    column: $table.lineAX1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineAY1 => $composableBuilder(
    column: $table.lineAY1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineAX2 => $composableBuilder(
    column: $table.lineAX2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineAY2 => $composableBuilder(
    column: $table.lineAY2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineBX1 => $composableBuilder(
    column: $table.lineBX1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineBY1 => $composableBuilder(
    column: $table.lineBY1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineBX2 => $composableBuilder(
    column: $table.lineBX2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineBY2 => $composableBuilder(
    column: $table.lineBY2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceImagePath => $composableBuilder(
    column: $table.referenceImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StationsTableOrderingComposer get stationId {
    final $$StationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableOrderingComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalibrationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<double> get lineAX1 =>
      $composableBuilder(column: $table.lineAX1, builder: (column) => column);

  GeneratedColumn<double> get lineAY1 =>
      $composableBuilder(column: $table.lineAY1, builder: (column) => column);

  GeneratedColumn<double> get lineAX2 =>
      $composableBuilder(column: $table.lineAX2, builder: (column) => column);

  GeneratedColumn<double> get lineAY2 =>
      $composableBuilder(column: $table.lineAY2, builder: (column) => column);

  GeneratedColumn<double> get lineBX1 =>
      $composableBuilder(column: $table.lineBX1, builder: (column) => column);

  GeneratedColumn<double> get lineBY1 =>
      $composableBuilder(column: $table.lineBY1, builder: (column) => column);

  GeneratedColumn<double> get lineBX2 =>
      $composableBuilder(column: $table.lineBX2, builder: (column) => column);

  GeneratedColumn<double> get lineBY2 =>
      $composableBuilder(column: $table.lineBY2, builder: (column) => column);

  GeneratedColumn<double> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<String> get referenceImagePath => $composableBuilder(
    column: $table.referenceImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StationsTableAnnotationComposer get stationId {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.calibrationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.calibrationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalibrationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalibrationsTable,
          CalibrationRow,
          $$CalibrationsTableFilterComposer,
          $$CalibrationsTableOrderingComposer,
          $$CalibrationsTableAnnotationComposer,
          $$CalibrationsTableCreateCompanionBuilder,
          $$CalibrationsTableUpdateCompanionBuilder,
          (CalibrationRow, $$CalibrationsTableReferences),
          CalibrationRow,
          PrefetchHooks Function({
            bool stationId,
            bool sessionsRefs,
            bool eventsRefs,
          })
        > {
  $$CalibrationsTableTableManager(_$AppDatabase db, $CalibrationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalibrationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalibrationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalibrationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> stationId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<double> lineAX1 = const Value.absent(),
                Value<double> lineAY1 = const Value.absent(),
                Value<double> lineAX2 = const Value.absent(),
                Value<double> lineAY2 = const Value.absent(),
                Value<double> lineBX1 = const Value.absent(),
                Value<double> lineBY1 = const Value.absent(),
                Value<double> lineBX2 = const Value.absent(),
                Value<double> lineBY2 = const Value.absent(),
                Value<double> distanceM = const Value.absent(),
                Value<String?> referenceImagePath = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalibrationsCompanion(
                id: id,
                stationId: stationId,
                version: version,
                lineAX1: lineAX1,
                lineAY1: lineAY1,
                lineAX2: lineAX2,
                lineAY2: lineAY2,
                lineBX1: lineBX1,
                lineBY1: lineBY1,
                lineBX2: lineBX2,
                lineBY2: lineBY2,
                distanceM: distanceM,
                referenceImagePath: referenceImagePath,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String stationId,
                required int version,
                required double lineAX1,
                required double lineAY1,
                required double lineAX2,
                required double lineAY2,
                required double lineBX1,
                required double lineBY1,
                required double lineBX2,
                required double lineBY2,
                required double distanceM,
                Value<String?> referenceImagePath = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CalibrationsCompanion.insert(
                id: id,
                stationId: stationId,
                version: version,
                lineAX1: lineAX1,
                lineAY1: lineAY1,
                lineAX2: lineAX2,
                lineAY2: lineAY2,
                lineBX1: lineBX1,
                lineBY1: lineBY1,
                lineBX2: lineBX2,
                lineBY2: lineBY2,
                distanceM: distanceM,
                referenceImagePath: referenceImagePath,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CalibrationsTable, CalibrationRow>(table),
                  $$CalibrationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({stationId = false, sessionsRefs = false, eventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionsRefs) db.sessions,
                    if (eventsRefs) db.events,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (stationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.stationId,
                            referencedTable: $$CalibrationsTableReferences
                                ._stationIdTable(db),
                            referencedColumn: $$CalibrationsTableReferences
                                ._stationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CalibrationRow,
                          $CalibrationsTable,
                          SessionRow,
                          $SessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CalibrationsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalibrationsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'calibration_id',
                          typedResults: items,
                        ),
                      if (eventsRefs)
                        await $_getPrefetchedDataByColumns<
                          CalibrationRow,
                          $CalibrationsTable,
                          EventRow,
                          $EventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CalibrationsTableReferences
                              ._eventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalibrationsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'calibration_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CalibrationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalibrationsTable,
      CalibrationRow,
      $$CalibrationsTableFilterComposer,
      $$CalibrationsTableOrderingComposer,
      $$CalibrationsTableAnnotationComposer,
      $$CalibrationsTableCreateCompanionBuilder,
      $$CalibrationsTableUpdateCompanionBuilder,
      (CalibrationRow, $$CalibrationsTableReferences),
      CalibrationRow,
      PrefetchHooks Function({
        bool stationId,
        bool sessionsRefs,
        bool eventsRefs,
      })
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required String stationId,
  Value<String?> calibrationId,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> stationId,
  Value<String?> calibrationId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<String?> note,
  Value<int> rowid,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionRow> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StationsTable _stationIdTable(_$AppDatabase db) =>
      db.stations.createAlias('sessions__station_id__stations__id');

  $$StationsTableProcessedTableManager get stationId {
    final $_column = $_itemColumn<String>('station_id')!;

    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CalibrationsTable _calibrationIdTable(_$AppDatabase db) =>
      db.calibrations.createAlias('sessions__calibration_id__calibrations__id');

  $$CalibrationsTableProcessedTableManager? get calibrationId {
    final $_column = $_itemColumn<String>('calibration_id');
    if ($_column == null) return null;
    final manager = $$CalibrationsTableTableManager(
      $_db,
      $_db.calibrations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calibrationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<EventRow>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'sessions__id__events__session_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$StationsTableFilterComposer get stationId {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableFilterComposer get calibrationId {
    final $$CalibrationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableFilterComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$StationsTableOrderingComposer get stationId {
    final $$StationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableOrderingComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableOrderingComposer get calibrationId {
    final $$CalibrationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableOrderingComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$StationsTableAnnotationComposer get stationId {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableAnnotationComposer get calibrationId {
    final $$CalibrationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionRow, $$SessionsTableReferences),
          SessionRow,
          PrefetchHooks Function({
            bool stationId,
            bool calibrationId,
            bool eventsRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> stationId = const Value.absent(),
                Value<String?> calibrationId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                stationId: stationId,
                calibrationId: calibrationId,
                startedAt: startedAt,
                endedAt: endedAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String stationId,
                Value<String?> calibrationId = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                stationId: stationId,
                calibrationId: calibrationId,
                startedAt: startedAt,
                endedAt: endedAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, SessionRow>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({stationId = false, calibrationId = false, eventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (eventsRefs) db.events],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (stationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.stationId,
                            referencedTable: $$SessionsTableReferences
                                ._stationIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._stationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (calibrationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.calibrationId,
                            referencedTable: $$SessionsTableReferences
                                ._calibrationIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._calibrationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eventsRefs)
                        await $_getPrefetchedDataByColumns<
                          SessionRow,
                          $SessionsTable,
                          EventRow,
                          $EventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._eventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, $$SessionsTableReferences),
      SessionRow,
      PrefetchHooks Function({
        bool stationId,
        bool calibrationId,
        bool eventsRefs,
      })
    >;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  required String id,
  required String sessionId,
  Value<String?> calibrationId,
  required DateTime countedAt,
  Value<DateTime?> speedMeasuredAt,
  required VehicleClass vehicleClass,
  required TravelDirection direction,
  Value<double?> speedKmh,
  required double confidence,
  Value<int> trackId,
  Value<bool> isValid,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String?> calibrationId,
  Value<DateTime> countedAt,
  Value<DateTime?> speedMeasuredAt,
  Value<VehicleClass> vehicleClass,
  Value<TravelDirection> direction,
  Value<double?> speedKmh,
  Value<double> confidence,
  Value<int> trackId,
  Value<bool> isValid,
  Value<bool> isDeleted,
  Value<int> rowid,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, EventRow> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('events__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CalibrationsTable _calibrationIdTable(_$AppDatabase db) =>
      db.calibrations.createAlias('events__calibration_id__calibrations__id');

  $$CalibrationsTableProcessedTableManager? get calibrationId {
    final $_column = $_itemColumn<String>('calibration_id');
    if ($_column == null) return null;
    final manager = $$CalibrationsTableTableManager(
      $_db,
      $_db.calibrations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calibrationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ViolationsTable, List<ViolationRow>>
  _violationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.violations,
    aliasName: 'events__id__violations__event_id',
  );

  $$ViolationsTableProcessedTableManager get violationsRefs {
    final manager = $$ViolationsTableTableManager(
      $_db,
      $_db.violations,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_violationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get countedAt => $composableBuilder(
    column: $table.countedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get speedMeasuredAt => $composableBuilder(
    column: $table.speedMeasuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VehicleClass, VehicleClass, int>
  get vehicleClass => $composableBuilder(
    column: $table.vehicleClass,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TravelDirection, TravelDirection, int>
  get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isValid => $composableBuilder(
    column: $table.isValid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableFilterComposer get calibrationId {
    final $$CalibrationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableFilterComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> violationsRefs(
    Expression<bool> Function($$ViolationsTableFilterComposer f) f,
  ) {
    final $$ViolationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.violations,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ViolationsTableFilterComposer(
            $db: $db,
            $table: $db.violations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get countedAt => $composableBuilder(
    column: $table.countedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get speedMeasuredAt => $composableBuilder(
    column: $table.speedMeasuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vehicleClass => $composableBuilder(
    column: $table.vehicleClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isValid => $composableBuilder(
    column: $table.isValid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableOrderingComposer get calibrationId {
    final $$CalibrationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableOrderingComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get countedAt =>
      $composableBuilder(column: $table.countedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get speedMeasuredAt => $composableBuilder(
    column: $table.speedMeasuredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<VehicleClass, int> get vehicleClass =>
      $composableBuilder(
        column: $table.vehicleClass,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TravelDirection, int> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<bool> get isValid =>
      $composableBuilder(column: $table.isValid, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableAnnotationComposer get calibrationId {
    final $$CalibrationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> violationsRefs<T extends Object>(
    Expression<T> Function($$ViolationsTableAnnotationComposer a) f,
  ) {
    final $$ViolationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.violations,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ViolationsTableAnnotationComposer(
            $db: $db,
            $table: $db.violations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          EventRow,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (EventRow, $$EventsTableReferences),
          EventRow,
          PrefetchHooks Function({
            bool sessionId,
            bool calibrationId,
            bool violationsRefs,
          })
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String?> calibrationId = const Value.absent(),
                Value<DateTime> countedAt = const Value.absent(),
                Value<DateTime?> speedMeasuredAt = const Value.absent(),
                Value<VehicleClass> vehicleClass = const Value.absent(),
                Value<TravelDirection> direction = const Value.absent(),
                Value<double?> speedKmh = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<bool> isValid = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                sessionId: sessionId,
                calibrationId: calibrationId,
                countedAt: countedAt,
                speedMeasuredAt: speedMeasuredAt,
                vehicleClass: vehicleClass,
                direction: direction,
                speedKmh: speedKmh,
                confidence: confidence,
                trackId: trackId,
                isValid: isValid,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                Value<String?> calibrationId = const Value.absent(),
                required DateTime countedAt,
                Value<DateTime?> speedMeasuredAt = const Value.absent(),
                required VehicleClass vehicleClass,
                required TravelDirection direction,
                Value<double?> speedKmh = const Value.absent(),
                required double confidence,
                Value<int> trackId = const Value.absent(),
                Value<bool> isValid = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                calibrationId: calibrationId,
                countedAt: countedAt,
                speedMeasuredAt: speedMeasuredAt,
                vehicleClass: vehicleClass,
                direction: direction,
                speedKmh: speedKmh,
                confidence: confidence,
                trackId: trackId,
                isValid: isValid,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventsTable, EventRow>(table),
                  $$EventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                calibrationId = false,
                violationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (violationsRefs) db.violations],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$EventsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$EventsTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (calibrationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.calibrationId,
                            referencedTable: $$EventsTableReferences
                                ._calibrationIdTable(db),
                            referencedColumn: $$EventsTableReferences
                                ._calibrationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (violationsRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          ViolationRow,
                          $ViolationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._violationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).violationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      EventRow,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (EventRow, $$EventsTableReferences),
      EventRow,
      PrefetchHooks Function({
        bool sessionId,
        bool calibrationId,
        bool violationsRefs,
      })
    >;
typedef $$ViolationsTableCreateCompanionBuilder = ViolationsCompanion Function({
  required String id,
  required String eventId,
  required double limitKmh,
  Value<String?> imagePath,
  required ViolationStatus status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ViolationsTableUpdateCompanionBuilder = ViolationsCompanion Function({
  Value<String> id,
  Value<String> eventId,
  Value<double> limitKmh,
  Value<String?> imagePath,
  Value<ViolationStatus> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ViolationsTableReferences
    extends BaseReferences<_$AppDatabase, $ViolationsTable, ViolationRow> {
  $$ViolationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('violations__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ViolationsTableFilterComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get limitKmh => $composableBuilder(
    column: $table.limitKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ViolationStatus, ViolationStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ViolationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get limitKmh => $composableBuilder(
    column: $table.limitKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ViolationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get limitKmh =>
      $composableBuilder(column: $table.limitKmh, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ViolationStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ViolationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ViolationsTable,
          ViolationRow,
          $$ViolationsTableFilterComposer,
          $$ViolationsTableOrderingComposer,
          $$ViolationsTableAnnotationComposer,
          $$ViolationsTableCreateCompanionBuilder,
          $$ViolationsTableUpdateCompanionBuilder,
          (ViolationRow, $$ViolationsTableReferences),
          ViolationRow,
          PrefetchHooks Function({bool eventId})
        > {
  $$ViolationsTableTableManager(_$AppDatabase db, $ViolationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ViolationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ViolationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ViolationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<double> limitKmh = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<ViolationStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ViolationsCompanion(
                id: id,
                eventId: eventId,
                limitKmh: limitKmh,
                imagePath: imagePath,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required double limitKmh,
                Value<String?> imagePath = const Value.absent(),
                required ViolationStatus status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ViolationsCompanion.insert(
                id: id,
                eventId: eventId,
                limitKmh: limitKmh,
                imagePath: imagePath,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ViolationsTable, ViolationRow>(table),
                  $$ViolationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$ViolationsTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$ViolationsTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ViolationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ViolationsTable,
      ViolationRow,
      $$ViolationsTableFilterComposer,
      $$ViolationsTableOrderingComposer,
      $$ViolationsTableAnnotationComposer,
      $$ViolationsTableCreateCompanionBuilder,
      $$ViolationsTableUpdateCompanionBuilder,
      (ViolationRow, $$ViolationsTableReferences),
      ViolationRow,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingRow,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsEntriesTable, SettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsEntriesTable,
                    SettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingRow,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StationsTableTableManager get stations =>
      $$StationsTableTableManager(_db, _db.stations);
  $$CalibrationsTableTableManager get calibrations =>
      $$CalibrationsTableTableManager(_db, _db.calibrations);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$ViolationsTableTableManager get violations =>
      $$ViolationsTableTableManager(_db, _db.violations);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
}
