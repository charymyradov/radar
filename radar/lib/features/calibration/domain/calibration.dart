import '../../../domain/geometry/geometry.dart';

/// A saved calibration version.
class Calibration {
  const Calibration({
    required this.id,
    required this.stationId,
    required this.version,
    required this.geometry,
    required this.isActive,
    required this.createdAt,
    this.referenceImagePath,
  });

  final String id;
  final String stationId;
  final int version;
  final CalibrationGeometry geometry;
  final String? referenceImagePath;
  final bool isActive;
  final DateTime createdAt;

  Calibration copyWith({bool? isActive}) => Calibration(
        id: id,
        stationId: stationId,
        version: version,
        geometry: geometry,
        referenceImagePath: referenceImagePath,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );

  @override
  String toString() =>
      'Calibration(v$version, active: $isActive, ${geometry.distanceMeters} m)';
}
