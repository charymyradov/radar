import '../domain/models/enums.dart';
import '../l10n/generated/app_localizations.dart';

String vehicleClassLabel(AppLocalizations l10n, VehicleClass vehicleClass) =>
    switch (vehicleClass) {
      VehicleClass.car => l10n.vehicleCar,
      VehicleClass.motorcycle => l10n.vehicleMotorcycle,
      VehicleClass.bus => l10n.vehicleBus,
      VehicleClass.truck => l10n.vehicleTruck,
    };

String travelDirectionLabel(
  AppLocalizations l10n,
  TravelDirection direction,
) =>
    direction == TravelDirection.inbound
        ? l10n.directionInbound
        : l10n.directionOutbound;

String violationStatusLabel(
  AppLocalizations l10n,
  ViolationStatus status,
) =>
    switch (status) {
      ViolationStatus.pending => l10n.violationsPending,
      ViolationStatus.reviewed => l10n.violationsReviewed,
      ViolationStatus.ignored => l10n.violationsIgnored,
    };
