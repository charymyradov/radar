/// Shared domain enums.
///
/// These types are used by the pure domain layer, by drift (stored as ints)
/// and by the UI, so they live in their own file and never import Flutter.
library;

/// Vehicle categories this app counts. The order is persisted in the database
/// and must never be reordered.
enum VehicleClass {
  car,
  motorcycle,
  bus,
  truck;

  static VehicleClass? fromName(String name) {
    for (final value in VehicleClass.values) {
      if (value.name == name) return value;
    }
    return null;
  }

  static VehicleClass fromIndex(int index) =>
      VehicleClass.values[index % VehicleClass.values.length];
}

/// Direction of travel relative to the two calibration lines.
enum TravelDirection {
  inbound,
  outbound;

  TravelDirection get opposite => this == inbound ? outbound : inbound;

  static TravelDirection fromIndex(int index) =>
      index == outbound.index ? outbound : inbound;
}

/// Review state of a speed violation.
enum ViolationStatus {
  pending,
  reviewed,
  ignored;

  static ViolationStatus fromIndex(int index) =>
      index >= 0 && index < ViolationStatus.values.length
          ? ViolationStatus.values[index]
          : pending;
}

/// Unit used for display. Speeds are always stored in km/h.
enum SpeedUnit {
  kmh,
  mph;

  double fromKmh(double kmh) => this == mph ? kmh / 1.609344 : kmh;
  double toKmh(double value) => this == mph ? value * 1.609344 : value;
  String format(double kmh, {int decimals = 0}) =>
      fromKmh(kmh).toStringAsFixed(decimals);
  String get label => this == mph ? 'mph' : 'km/h';
}
