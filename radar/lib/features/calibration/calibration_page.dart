import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/geometry/geometry.dart';
import '../../l10n/generated/app_localizations.dart';
import 'domain/calibration.dart';

class CalibrationPage extends ConsumerStatefulWidget {
  const CalibrationPage({super.key});

  @override
  ConsumerState<CalibrationPage> createState() => _CalibrationPageState();
}

class _CalibrationPageState extends ConsumerState<CalibrationPage> {
  CameraController? _camera;
  String? _cameraError;
  bool _cameraLoading = true;
  bool _saving = false;
  bool _edited = false;
  int? _draggedHandle;
  final _distanceController = TextEditingController(text: '10');
  LineSegment _lineA = const LineSegment(
    NormPoint(0.08, 0.4),
    NormPoint(0.92, 0.4),
  );
  LineSegment _lineB = const LineSegment(
    NormPoint(0.08, 0.65),
    NormPoint(0.92, 0.65),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_openCamera());
    unawaited(_loadActiveCalibration());
  }

  /// Starts the editor from the calibration that is currently in use, so users
  /// refine the existing lines instead of drawing new ones from scratch.
  Future<void> _loadActiveCalibration() async {
    try {
      final active = await ref
          .read(calibrationRepositoryProvider)
          .active(kDefaultStationId);
      if (!mounted || active == null || _edited) return;
      setState(() {
        _lineA = active.geometry.lineA;
        _lineB = active.geometry.lineB;
        _distanceController.text = _formatDistance(
          active.geometry.distanceMeters,
        );
      });
    } catch (error) {
      ref.read(appErrorProvider.notifier).report(error);
    }
  }

  String _formatDistance(double metres) => metres == metres.roundToDouble()
      ? metres.toStringAsFixed(0)
      : metres.toStringAsFixed(1);

  @override
  void dispose() {
    _distanceController.dispose();
    final camera = _camera;
    if (camera != null) unawaited(camera.dispose());
    super.dispose();
  }

  Future<void> _openCamera() async {
    try {
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        throw StateError('Camera permission was denied');
      }
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('No camera is available');
      final description = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        description,
        ResolutionPreset.low,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _cameraLoading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _cameraError = error.toString();
          _cameraLoading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final distance = double.tryParse(_distanceController.text);
    if (distance == null || distance < 1 || distance > 500) {
      _showMessage(l10n.calibrationDistanceInvalid);
      return;
    }
    final geometry = CalibrationGeometry(
      lineA: _lineA,
      lineB: _lineB,
      distanceMeters: distance,
    );
    if (!geometry.isValid) {
      _showMessage(l10n.calibrationInvalid);
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(calibrationRepositoryProvider).saveNewVersion(
            id: const Uuid().v4(),
            stationId: kDefaultStationId,
            geometry: geometry,
          );
      ref.invalidate(_calibrationsProvider);
      if (mounted) _showMessage(l10n.calibrationSaved);
    } catch (error) {
      if (mounted) _showMessage('${l10n.commonError}: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _activate(Calibration calibration) async {
    try {
      await ref.read(calibrationRepositoryProvider).setActive(
            kDefaultStationId,
            calibration.id,
          );
      ref.invalidate(_calibrationsProvider);
      if (mounted) setState(() {});
    } catch (error) {
      if (mounted) _showMessage('${AppLocalizations.of(context).commonError}: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _startDrag(Offset localPosition, Size size) {
    final point = NormPoint(
      (localPosition.dx / size.width).clamp(0.0, 1.0),
      (localPosition.dy / size.height).clamp(0.0, 1.0),
    );
    final handles = [
      _lineA.a,
      _lineA.b,
      _lineB.a,
      _lineB.b,
    ];
    var closest = 0;
    var distance = double.infinity;
    for (var index = 0; index < handles.length; index++) {
      final dx = (handles[index].x - point.x) * size.width;
      final dy = (handles[index].y - point.y) * size.height;
      final current = math.sqrt(dx * dx + dy * dy);
      if (current < distance) {
        distance = current;
        closest = index;
      }
    }
    _draggedHandle = closest;
    _moveHandle(point);
  }

  void _moveHandle(NormPoint point) {
    final handle = _draggedHandle;
    if (handle == null) return;
    _edited = true;
    setState(() {
      switch (handle) {
        case 0:
          _lineA = _lineA.withA(point);
        case 1:
          _lineA = _lineA.withB(point);
        case 2:
          _lineB = _lineB.withA(point);
        case 3:
          _lineB = _lineB.withB(point);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calibrations = ref.watch(_calibrationsProvider);
    final camera = _camera;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.calibrationTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.calibrationDragHint),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: camera?.value.aspectRatio ?? 0.72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (camera?.value.isInitialized == true)
                    CameraPreview(camera!)
                  else
                    const ColoredBox(
                      color: AppTheme.surfaceHigh,
                      child: Center(
                        child: Icon(Icons.grid_on_rounded, size: 52),
                      ),
                    ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      return GestureDetector(
                        onPanStart: (details) =>
                            _startDrag(details.localPosition, size),
                        onPanUpdate: (details) => _moveHandle(
                          NormPoint(
                            (details.localPosition.dx / size.width)
                                .clamp(0.0, 1.0),
                            (details.localPosition.dy / size.height)
                                .clamp(0.0, 1.0),
                          ),
                        ),
                        onPanEnd: (_) => _draggedHandle = null,
                        child: CustomPaint(
                          painter: _CalibrationPainter(
                            lineA: _lineA,
                            lineB: _lineB,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      );
                    },
                  ),
                  if (_cameraLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_cameraError != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: Colors.black87,
                        child: Text(
                          l10n.calibrationNoCamera,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.calibrationDistance),
          const SizedBox(height: 8),
          TextField(
            controller: _distanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: l10n.calibrationDistanceHint,
              suffixText: 'm',
            ),
            onChanged: (_) => setState(() => _edited = true),
          ),
          const SizedBox(height: 12),
          _LineLegend(color: AppTheme.accent, label: l10n.calibrationLineA),
          const SizedBox(height: 6),
          _LineLegend(color: AppTheme.warning, label: l10n.calibrationLineB),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(l10n.calibrationSave),
          ),
          const SizedBox(height: 24),
          Text(l10n.calibrationVersions,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          calibrations.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('${l10n.commonError}: $error'),
            data: (items) => items.isEmpty
                ? Text(l10n.commonNone)
                : Column(
                    children: [
                      for (final item in items)
                        Card(
                          child: ListTile(
                            leading: Icon(
                              item.isActive
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: item.isActive
                                  ? AppTheme.accent
                                  : null,
                            ),
                            title: Text(
                              'v${item.version} · ${item.geometry.distanceMeters.toStringAsFixed(1)} m',
                            ),
                            subtitle: Text(
                              '${MaterialLocalizations.of(context).formatShortDate(item.createdAt.toLocal())}'
                              '${item.isActive ? ' · ${l10n.calibrationActive}' : ''}',
                            ),
                            trailing: item.isActive
                                ? null
                                : TextButton(
                                    onPressed: () => _activate(item),
                                    child: Text(l10n.calibrationSetActive),
                                  ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

final _calibrationsProvider = FutureProvider<List<Calibration>>((ref) {
  return ref.read(calibrationRepositoryProvider).list(
        stationId: kDefaultStationId,
      );
});

class _LineLegend extends StatelessWidget {
  const _LineLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(width: 20, height: 3, color: color),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
}

class _CalibrationPainter extends CustomPainter {
  const _CalibrationPainter({required this.lineA, required this.lineB});

  final LineSegment lineA;
  final LineSegment lineB;

  @override
  void paint(Canvas canvas, Size size) {
    _drawLine(canvas, size, lineA, AppTheme.accent, 'A');
    _drawLine(canvas, size, lineB, AppTheme.warning, 'B');
  }

  void _drawLine(
    Canvas canvas,
    Size size,
    LineSegment line,
    Color color,
    String label,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final start = Offset(line.a.x * size.width, line.a.y * size.height);
    final end = Offset(line.b.x * size.width, line.b.y * size.height);
    canvas.drawLine(start, end, paint);
    final handlePaint = Paint()..color = color;
    canvas.drawCircle(start, 9, handlePaint);
    canvas.drawCircle(end, 9, handlePaint);
    final text = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(start.dx + 8, start.dy - 26));
  }

  @override
  bool shouldRepaint(_CalibrationPainter oldDelegate) =>
      oldDelegate.lineA != lineA || oldDelegate.lineB != lineB;
}
