import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers.dart';
import '../../domain/geometry/geometry.dart';
import '../../domain/models/detection_models.dart';
import '../../domain/models/enums.dart';
import '../../features/settings/domain/app_settings.dart';
import '../../l10n/generated/app_localizations.dart';
import 'live_session_controller.dart';

class LivePage extends ConsumerStatefulWidget {
  const LivePage({super.key});

  @override
  ConsumerState<LivePage> createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && defaultTargetPlatform == TargetPlatform.android) {
        ref.read(liveSessionProvider.notifier).preparePreview();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.detached) {
      ref.read(liveSessionProvider.notifier).stop();
    } else if (lifecycleState == AppLifecycleState.resumed &&
        defaultTargetPlatform == TargetPlatform.android) {
      ref.read(liveSessionProvider.notifier).preparePreview();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Releases the camera before the calibration page opens its own preview.
  ///
  /// The camera belongs to the live session provider, so leaving the page via
  /// the router alone would keep the sensor busy and the calibration editor
  /// could not initialize.
  Future<void> _goToCalibration() async {
    await ref.read(liveSessionProvider.notifier).stop();
    if (!mounted) return;
    context.go('/calibration');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(liveSessionProvider);
    final controller = ref.read(liveSessionProvider.notifier);
    final settings = ref.watch(settingsProvider).value ?? const AppSettings();
    final camera = controller.cameraController;
    final running = state.isRunning;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.liveTitle),
        actions: [
          if (running)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: AppTheme.accent),
                  const SizedBox(width: 6),
                  Text(l10n.liveSessionRunning),
                ],
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          if (state.error != null) ...[
            _LiveError(
              message: _localizedError(context, state.error!),
              onCalibration: state.error == 'CALIBRATION_REQUIRED'
                  ? _goToCalibration
                  : null,
              onSettings: state.error == 'CAMERA_PERMISSION_DENIED'
                  ? openAppSettings
                  : null,
            ),
            const SizedBox(height: 12),
          ],
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: AspectRatio(
              aspectRatio: 0.62,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (state.cameraReady && camera?.value.isInitialized == true)
                    CameraPreview(camera!)
                  else
                    ColoredBox(
                      color: AppTheme.surfaceHigh,
                      child: Center(
                        child: Icon(
                          state.error == 'CAMERA_PERMISSION_DENIED'
                              ? Icons.no_photography_rounded
                              : running
                              ? Icons.videocam_off_rounded
                              : Icons.videocam_rounded,
                          size: 52,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  if (running && settings.showOverlay)
                    CustomPaint(
                      painter: _LiveOverlayPainter(
                        tracks: state.tracks,
                        calibration: controller.calibrationGeometry,
                        limitKmh: settings.speedLimitKmh,
                      ),
                    ),
                  if (state.status == LiveSessionStatus.starting ||
                      state.status == LiveSessionStatus.stopping)
                    ColoredBox(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(l10n.commonLoading),
                          ],
                        ),
                      ),
                    ),
                  if (running)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            '${state.inferenceFps.toStringAsFixed(1)} FPS · '
                            '${state.processedFrames == 0
                                ? l10n.liveDetectionWaiting
                                : state.lastDetectionCount == 0
                                ? l10n.liveNothingDetected
                                : l10n.liveDetectionCount(state.lastDetectionCount)}',
                            style: const TextStyle(
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed:
                state.status == LiveSessionStatus.starting ||
                    state.status == LiveSessionStatus.stopping
                ? null
                : running
                ? controller.stop
                : controller.start,
            icon: Icon(running ? Icons.stop_rounded : Icons.play_arrow_rounded),
            label: Text(running ? l10n.liveStop : l10n.liveStart),
            style: running
                ? FilledButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                    foregroundColor: Colors.white,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.liveCountingRule,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.liveTotal),
                        const SizedBox(height: 4),
                        Text(
                          '${state.totalCount}',
                          style: AppTheme.numeric(
                            Theme.of(context).textTheme.displaySmall,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _MiniMetric(
                    label: l10n.liveByDirection,
                    value:
                        '${l10n.directionInbound}: ${state.directionCounts[TravelDirection.inbound] ?? 0}\n'
                        '${l10n.directionOutbound}: ${state.directionCounts[TravelDirection.outbound] ?? 0}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.liveByClass,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final vehicleClass in VehicleClass.values)
                Chip(
                  avatar: Icon(_classIcon(vehicleClass), size: 18),
                  label: Text(
                    '${_className(l10n, vehicleClass)} · ${state.classCounts[vehicleClass] ?? 0}',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.liveLastVehicles,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (state.recent.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.liveNoVehicles),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (var index = 0; index < state.recent.length; index++)
                    _RecentVehicleTile(
                      vehicle: state.recent[index],
                      settings: settings,
                      divider: index < state.recent.length - 1,
                    ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(
            l10n.livePrivacy,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

String _localizedError(BuildContext context, String error) {
  final l10n = AppLocalizations.of(context);
  if (error == 'CALIBRATION_REQUIRED') return l10n.liveNeedsCalibrationBody;
  if (error == 'CAMERA_PERMISSION_DENIED') {
    return l10n.liveCameraPermissionBody;
  }
  if (error == 'CAMERA_UNAVAILABLE') return l10n.liveCameraError;
  if (error.startsWith('CAMERA_ERROR:')) return error.substring(13);
  return '${l10n.liveModelError}: ${error.split('\n').first}';
}

String _className(AppLocalizations l10n, VehicleClass vehicleClass) =>
    switch (vehicleClass) {
      VehicleClass.car => l10n.vehicleCar,
      VehicleClass.motorcycle => l10n.vehicleMotorcycle,
      VehicleClass.bus => l10n.vehicleBus,
      VehicleClass.truck => l10n.vehicleTruck,
    };

IconData _classIcon(VehicleClass vehicleClass) => switch (vehicleClass) {
  VehicleClass.car => Icons.directions_car_rounded,
  VehicleClass.motorcycle => Icons.two_wheeler_rounded,
  VehicleClass.bus => Icons.directions_bus_rounded,
  VehicleClass.truck => Icons.local_shipping_rounded,
};

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 4),
      Text(value, textAlign: TextAlign.end),
    ],
  );
}

class _RecentVehicleTile extends StatelessWidget {
  const _RecentVehicleTile({
    required this.vehicle,
    required this.settings,
    required this.divider,
  });

  final LiveVehicle vehicle;
  final AppSettings settings;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final speed = vehicle.speedKmh == null
        ? l10n.noSpeed
        : '${settings.unit.format(vehicle.speedKmh!, decimals: 0)} ${settings.unit.label}';
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: Icon(_classIcon(vehicle.vehicleClass)),
          title: Text(_className(l10n, vehicle.vehicleClass)),
          subtitle: Text(
            '${vehicle.direction == TravelDirection.inbound ? l10n.directionInbound : l10n.directionOutbound} · ${DateFormat.Hm().format(vehicle.countedAt.toLocal())}',
          ),
          trailing: Text(
            speed,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color:
                  vehicle.speedKmh != null &&
                      vehicle.speedKmh! > settings.speedLimitKmh
                  ? AppTheme.danger
                  : null,
            ),
          ),
        ),
        if (divider) const Divider(height: 1, indent: 64),
      ],
    );
  }
}

class _LiveError extends StatelessWidget {
  const _LiveError({
    required this.message,
    this.onCalibration,
    this.onSettings,
  });

  final String message;
  final VoidCallback? onCalibration;
  final Future<bool> Function()? onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: AppTheme.danger.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (onCalibration != null || onSettings != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed:
                    onCalibration ??
                    () async {
                      await onSettings?.call();
                    },
                child: Text(
                  onCalibration != null
                      ? l10n.liveGoToCalibration
                      : l10n.liveOpenSystemSettings,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LiveOverlayPainter extends CustomPainter {
  const _LiveOverlayPainter({
    required this.tracks,
    required this.calibration,
    required this.limitKmh,
  });

  final List<TrackedObject> tracks;
  final CalibrationGeometry? calibration;
  final double limitKmh;

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = calibration;
    if (geometry != null) {
      _line(canvas, size, geometry.lineA, AppTheme.accent);
      _line(canvas, size, geometry.lineB, AppTheme.warning);
    }
    for (final track in tracks) {
      if (!track.confirmed) continue;
      final box = track.box;
      final rect = Rect.fromLTRB(
        box.left * size.width,
        box.top * size.height,
        box.right * size.width,
        box.bottom * size.height,
      );
      final color = track.speedKmh != null && track.speedKmh! > limitKmh
          ? AppTheme.danger
          : AppTheme.accent;
      canvas.drawRect(
        rect,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final label = track.speedKmh == null
          ? '#${track.id}'
          : '#${track.id} ${track.speedKmh!.round()} km/h';
      final text = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      canvas.drawRect(
        Rect.fromLTWH(
          rect.left,
          (rect.top - text.height - 4).clamp(0, size.height),
          text.width + 8,
          text.height + 4,
        ),
        Paint()..color = color,
      );
      text.paint(
        canvas,
        Offset(
          rect.left + 4,
          (rect.top - text.height - 2).clamp(0, size.height),
        ),
      );
    }
  }

  void _line(Canvas canvas, Size size, LineSegment line, Color color) {
    canvas.drawLine(
      Offset(line.a.x * size.width, line.a.y * size.height),
      Offset(line.b.x * size.width, line.b.y * size.height),
      Paint()
        ..color = color
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_LiveOverlayPainter oldDelegate) =>
      oldDelegate.tracks != tracks ||
      oldDelegate.calibration != calibration ||
      oldDelegate.limitKmh != limitKmh;
}
