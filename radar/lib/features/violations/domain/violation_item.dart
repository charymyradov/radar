import '../../../domain/models/enums.dart';

/// A violation row joined with the counted vehicle it belongs to.
class ViolationItem {
  const ViolationItem({
    required this.id,
    required this.eventId,
    required this.limitKmh,
    required this.status,
    required this.createdAt,
    required this.vehicleClass,
    required this.direction,
    required this.countedAt,
    this.speedKmh,
    this.imagePath,
  });

  final String id;
  final String eventId;
  final double limitKmh;
  final double? speedKmh;
  final ViolationStatus status;
  final DateTime createdAt;
  final String? imagePath;
  final VehicleClass vehicleClass;
  final TravelDirection direction;
  final DateTime countedAt;

  double get overBy =>
      speedKmh == null ? 0 : (speedKmh! - limitKmh).clamp(0, double.infinity);
}
