import 'dart:io';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' show Value;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../domain/models/enums.dart';
import '../../l10n/generated/app_localizations.dart';
import '../history/domain/vehicle_event.dart';
import 'domain/app_settings.dart';
import '../live/live_session_controller.dart';
import '../stats/domain/period_stats.dart';

final _storageBytesProvider = FutureProvider<int>((ref) async {
  await ref.watch(databaseProvider.future);
  final media = await ref.watch(mediaStoreProvider.future);
  final dbBytes =
      await ref.read(databaseProvider.notifier).databaseFile.length();
  return dbBytes + await media.imagesSizeBytes();
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final value = ref.watch(settingsProvider);
    if (value.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (value.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: Center(child: Text('${l10n.commonError}: ${value.error}')),
      );
    }
    final settings = value.requireValue;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (settings.backupDue)
            Card(
              color: AppTheme.warning.withValues(alpha: 0.12),
              child: ListTile(
                leading: const Icon(Icons.backup_rounded, color: AppTheme.warning),
                title: Text(l10n.settingsBackupReminderTitle),
                subtitle: Text(l10n.settingsBackupReminderBody),
                trailing: TextButton(
                  onPressed: () => _createBackup(context, ref),
                  child: Text(l10n.settingsBackupNowShort),
                ),
              ),
            ),
          _sectionTitle(context, l10n.settingsTitle),
          ListTile(
            leading: const Icon(Icons.speed_rounded),
            title: Text(l10n.settingsSpeedLimit),
            subtitle: Text(l10n.settingsSpeedLimitHint),
            trailing: Text(
              '${settings.unit.fromKmh(settings.speedLimitKmh).round()} ${settings.unit.label}',
            ),
            onTap: () => _editSpeedLimit(context, ref, settings),
          ),
          ListTile(
            leading: const Icon(Icons.straighten_rounded),
            title: Text(l10n.settingsUnit),
            trailing: DropdownButton<SpeedUnit>(
              value: settings.unit,
              onChanged: (unit) {
                if (unit != null) {
                  _update(context, ref, (old) => old.copyWith(unit: unit));
                }
              },
              items: [
                for (final unit in SpeedUnit.values)
                  DropdownMenuItem(
                    value: unit,
                    child: Text(unit.label),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(l10n.settingsLanguage),
            trailing: DropdownButton<AppLanguage>(
              value: settings.language,
              onChanged: (language) {
                if (language != null) {
                  _update(
                    context,
                    ref,
                    (old) => old.copyWith(language: language),
                  );
                }
              },
              items: const [
                DropdownMenuItem(value: AppLanguage.tr, child: Text('Türkçe')),
                DropdownMenuItem(value: AppLanguage.en, child: Text('English')),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text(l10n.settingsQuality),
            trailing: DropdownButton<CameraQuality>(
              value: settings.cameraQuality,
              onChanged: (quality) {
                if (quality != null) {
                  _update(
                    context,
                    ref,
                    (old) => old.copyWith(cameraQuality: quality),
                  );
                }
              },
              items: [
                DropdownMenuItem(
                  value: CameraQuality.low,
                  child: Text(l10n.settingsQualityLow),
                ),
                DropdownMenuItem(
                  value: CameraQuality.medium,
                  child: Text(l10n.settingsQualityMedium),
                ),
                DropdownMenuItem(
                  value: CameraQuality.high,
                  child: Text(l10n.settingsQualityHigh),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.speed_outlined),
            title: Text(l10n.settingsFps),
            subtitle: Slider(
              value: settings.targetFps.toDouble(),
              min: 5,
              max: 30,
              divisions: 25,
              label: '${settings.targetFps}',
              onChanged: (fps) => _update(
                context,
                ref,
                (old) => old.copyWith(targetFps: fps.round()),
                notify: false,
              ),
              onChangeEnd: (_) => _persistCurrent(ref),
            ),
            trailing: Text('${settings.targetFps}'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.flip_rounded),
            title: Text(l10n.directionLabel),
            subtitle: Text(
              '${l10n.directionInbound} ↔ ${l10n.directionOutbound}',
            ),
            value: settings.flipDirection,
            onChanged: (enabled) => _update(
              context,
              ref,
              (old) => old.copyWith(flipDirection: enabled),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.crop_free_rounded),
            title: Text(l10n.liveShowOverlay),
            value: settings.showOverlay,
            onChanged: (enabled) => _update(
              context,
              ref,
              (old) => old.copyWith(showOverlay: enabled),
            ),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.settingsRetention),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.settingsRetention),
            subtitle: Text(l10n.settingsRetentionHint),
            trailing: DropdownButton<int>(
              value: settings.imageRetentionDays,
              onChanged: (days) async {
                if (days == null) return;
                await _update(
                  context,
                  ref,
                  (old) => old.copyWith(imageRetentionDays: days),
                );
                await ref
                    .read(violationRepositoryProvider)
                    .purgeOldImages(retentionDays: days);
                ref.invalidate(_storageBytesProvider);
              },
              items: [
                for (final days in [7, 30, 90, 365])
                  DropdownMenuItem(
                    value: days,
                    child: Text('$days ${l10n.settingsDays}'),
                  ),
              ],
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: Text(l10n.settingsBackupReminder),
            subtitle: Text(l10n.settingsBackupReminderBody),
            value: settings.backupReminder,
            onChanged: (enabled) => _update(
              context,
              ref,
              (old) => old.copyWith(backupReminder: enabled),
            ),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.settingsBackup),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: Text(l10n.settingsBackupNow),
            subtitle: Text(
              '${l10n.settingsLastBackup}: '
              '${settings.lastBackupAt == null ? l10n.settingsNever : DateFormat.yMMMd().format(settings.lastBackupAt!.toLocal())}',
            ),
            onTap: () => _createBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: Text(l10n.settingsRestore),
            onTap: () => _restoreBackup(context, ref),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.settingsExport),
          ListTile(
            leading: const Icon(Icons.table_view_rounded),
            title: Text(l10n.settingsExportCsv),
            onTap: () => _exportCsv(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: Text(l10n.settingsExportPdf),
            onTap: () => _exportPdf(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.storage_rounded),
            title: Text(l10n.settingsStorageUsage),
            trailing: ref.watch(_storageBytesProvider).when(
                  loading: () => const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (error, stack) => const Icon(Icons.error_outline),
                  data: (bytes) => Text(_formatBytes(bytes)),
                ),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.settingsDangerZone),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: AppTheme.danger),
            title: Text(
              l10n.settingsDeleteAll,
              style: const TextStyle(color: AppTheme.danger),
            ),
            onTap: () => _deleteAll(context, ref),
          ),
          const SizedBox(height: 12),
          Text(l10n.settingsBatteryNote),
          const SizedBox(height: 8),
          Text(
            l10n.settingsPrivacy,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          Text(
            '${l10n.settingsAbout} · ${l10n.settingsVersion} 1.0.0',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

Widget _sectionTitle(BuildContext context, String title) => Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );

Future<void> _update(
  BuildContext context,
  WidgetRef ref,
  AppSettings Function(AppSettings) transform, {
  bool notify = true,
}) async {
  try {
    await ref.read(settingsProvider.notifier).updateSettings(transform);
    if (notify && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).commonSave)),
        );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context).commonError}: $error'),
        ),
      );
    }
  }
}

void _persistCurrent(WidgetRef ref) {
  final settings = ref.read(settingsProvider).value;
  if (settings != null) {
    ref.read(settingsProvider.notifier).updateSettings((_) => settings);
  }
}

Future<void> _editSpeedLimit(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
) async {
  final controller = TextEditingController(
    text: settings.unit.fromKmh(settings.speedLimitKmh).toStringAsFixed(0),
  );
  final value = await showDialog<double>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context).settingsSpeedLimit),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(suffixText: settings.unit.label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            double.tryParse(controller.text),
          ),
          child: Text(AppLocalizations.of(context).commonSave),
        ),
      ],
    ),
  );
  controller.dispose();
  if (!context.mounted || value == null || value <= 0 || value > 300) return;
  await _update(
    context,
    ref,
    (old) => old.copyWith(speedLimitKmh: old.unit.toKmh(value)),
  );
}

Future<void> _createBackup(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  File? backupFile;
  try {
    await ref.read(databaseProvider.notifier).checkpoint();
    final dbFile = ref.read(databaseProvider.notifier).databaseFile;
    final archive = Archive()
      ..addFile(
        ArchiveFile(
          'radar.sqlite',
          await dbFile.length(),
          await dbFile.readAsBytes(),
        ),
      );
    final media = await ref.read(mediaStoreProvider.future);
    if (await media.imagesDirectory.exists()) {
      await for (final entity in media.imagesDirectory.list(recursive: true)) {
        if (entity is File) {
          final relative = p.relative(
            entity.path,
            from: media.imagesDirectory.path,
          );
          final bytes = await entity.readAsBytes();
          archive.addFile(ArchiveFile('violations/$relative', bytes.length, bytes));
        }
      }
    }
    final bytes = ZipEncoder().encode(archive);
    final temp = await getTemporaryDirectory();
    final file = File(
      p.join(temp.path, 'radar-${DateTime.now().millisecondsSinceEpoch}.radarbackup'),
    );
    backupFile = file;
    await file.writeAsBytes(bytes, flush: true);
    final result = await _shareFile(file, l10n.settingsBackup);
    if (result.status == ShareResultStatus.success) {
      await ref.read(settingsProvider.notifier).markBackupDone();
      ref.invalidate(_storageBytesProvider);
      if (context.mounted) _showMessage(context, l10n.settingsBackupDone);
    }
  } catch (error) {
    if (context.mounted) _showError(context, error);
  } finally {
    if (backupFile != null && await backupFile.exists()) {
      await backupFile.delete();
    }
  }
}

Future<void> _restoreBackup(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final selected = await openFile(
    acceptedTypeGroups: [
      XTypeGroup(
        label: 'Radar backup',
        extensions: const ['radarbackup', 'zip'],
      ),
    ],
  );
  if (!context.mounted || selected == null) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.settingsRestoreTitle),
      content: Text(l10n.settingsRestoreBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.commonConfirm),
        ),
      ],
    ),
  );
  if (!context.mounted || confirmed != true) return;

  Directory? staging;
  try {
    final archive = ZipDecoder().decodeBytes(await selected.readAsBytes());
    final databaseEntry = archive.findFile('radar.sqlite');
    if (databaseEntry == null || databaseEntry.isFile != true) {
      throw const FormatException('Backup has no database');
    }
    final bytes = databaseEntry.content as List<int>;
    staging = await Directory.systemTemp.createTemp('radar-restore-');
    final replacement = File(p.join(staging.path, 'radar.sqlite'));
    await replacement.writeAsBytes(bytes, flush: true);
    final stagedImages = Directory(p.join(staging.path, 'violations'));
    for (final entry in archive.files) {
      if (!entry.isFile || !entry.name.startsWith('violations/')) continue;
      final relative = entry.name.substring('violations/'.length);
      final segments = p.split(relative);
      if (segments.isEmpty ||
          p.isAbsolute(relative) ||
          relative.contains(r'\') ||
          segments.any((segment) => segment == '..' || segment == '.')) {
        throw const FormatException('Backup contains an invalid image path');
      }
      final destination = File(p.joinAll([stagedImages.path, ...segments]));
      await destination.parent.create(recursive: true);
      await destination.writeAsBytes(entry.content as List<int>, flush: true);
    }

    final candidate = AppDatabase.open(replacement);
    try {
      await candidate.ensureDefaultStation(kDefaultStationId);
      await candidate.countEvents();
      final media = await ref.read(mediaStoreProvider.future);
      final violations = await candidate.select(candidate.violations).get();
      for (final violation in violations) {
        final oldPath = violation.imagePath;
        if (oldPath == null) continue;
        final fileName = p.basename(oldPath);
        final stagedImage = File(p.join(stagedImages.path, fileName));
        await (candidate.update(candidate.violations)
              ..where((row) => row.id.equals(violation.id)))
            .write(
          ViolationsCompanion(
            imagePath: Value(
              await stagedImage.exists()
                  ? p.join(media.imagesDirectory.path, fileName)
                  : null,
            ),
          ),
        );
      }
    } finally {
      await candidate.close();
    }

    await ref.read(liveSessionProvider.notifier).stop();
    await ref.read(databaseProvider.notifier).restoreFrom(replacement);
    final media = await ref.read(mediaStoreProvider.future);
    await media.deleteOrphans(const {});
    if (await stagedImages.exists()) {
      await for (final entity in stagedImages.list(recursive: true)) {
        if (entity is File) {
          final relative = p.relative(entity.path, from: stagedImages.path);
          final destination = File(
            p.join(media.imagesDirectory.path, relative),
          );
          await destination.parent.create(recursive: true);
          await entity.copy(destination.path);
        }
      }
    }
    ref.invalidate(settingsProvider);
    ref.invalidate(_storageBytesProvider);
    if (context.mounted) {
      _showMessage(context, l10n.settingsRestoreDone);
    }
  } catch (error) {
    if (context.mounted) {
      _showMessage(context, '${l10n.settingsRestoreFailed}: $error');
    }
  } finally {
    if (staging != null && await staging.exists()) {
      await staging.delete(recursive: true);
    }
  }
}

Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  try {
    final events = <VehicleEvent>[];
    var offset = 0;
    while (true) {
      final batch = await ref.read(eventRepositoryProvider).query(
            const EventFilter(includeInvalid: true, includeDeleted: true),
            limit: 500,
            offset: offset,
          );
      events.addAll(batch);
      if (batch.length < 500) break;
      offset += batch.length;
    }
    final rows = <List<Object?>>[
      [
        'id',
        'session_id',
        'counted_at',
        'vehicle_class',
        'direction',
        'speed_kmh',
        'confidence',
        'valid',
        'deleted',
      ],
      for (final event in events)
        [
          event.id,
          event.sessionId,
          event.countedAt.toUtc().toIso8601String(),
          event.vehicleClass.name,
          event.direction.name,
          event.speedKmh,
          event.confidence,
          event.isValid,
          event.isDeleted,
        ],
    ];
    final temp = await getTemporaryDirectory();
    final file = File(
      p.join(temp.path, 'radar-events-${DateTime.now().millisecondsSinceEpoch}.csv'),
    );
    await file.writeAsString(Csv().encode(rows));
    await _shareFile(file, l10n.settingsExportCsv);
    if (await file.exists()) await file.delete();
  } catch (error) {
    if (context.mounted) _showError(context, error);
  }
}

Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  try {
    final stats = await ref
        .read(statsRepositoryProvider)
        .load(const StatsQuery());
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'RADAR - TRAFFIC REPORT',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Generated: ${DateTime.now().toIso8601String()}'),
          pw.SizedBox(height: 16),
          pw.Text('Total vehicles: ${stats.totalCount}'),
          pw.Text('Measured speeds: ${stats.measuredCount}'),
          pw.Text('Violations: ${stats.violationCount}'),
          pw.Text('Average speed km/h: ${stats.meanSpeed?.toStringAsFixed(1) ?? '-'}'),
          pw.Text('85th percentile km/h: ${stats.p85?.toStringAsFixed(1) ?? '-'}'),
          pw.Text('Maximum speed km/h: ${stats.maxSpeed?.toStringAsFixed(1) ?? '-'}'),
          pw.SizedBox(height: 20),
          pw.Text('Vehicle classes'),
          for (final entry in stats.classCounts.entries)
            pw.Text('${entry.key.name}: ${entry.value}'),
        ],
      ),
    );
    final temp = await getTemporaryDirectory();
    final file = File(
      p.join(temp.path, 'radar-report-${DateTime.now().millisecondsSinceEpoch}.pdf'),
    );
    await file.writeAsBytes(await document.save(), flush: true);
    await _shareFile(file, l10n.settingsExportPdf);
    if (await file.exists()) await file.delete();
  } catch (error) {
    if (context.mounted) _showError(context, error);
  }
}

Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.settingsDeleteAllTitle),
      content: Text(l10n.settingsDeleteAllBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.settingsDeleteAll),
        ),
      ],
    ),
  );
  if (!context.mounted || confirmed != true) return;
  try {
    await ref.read(liveSessionProvider.notifier).stop();
    await ref.read(databaseProvider).requireValue.deleteAllData(
          stationId: kDefaultStationId,
        );
    final media = await ref.read(mediaStoreProvider.future);
    await media.deleteOrphans(const {});
    ref.invalidate(settingsProvider);
    ref.invalidate(_storageBytesProvider);
    if (context.mounted) _showMessage(context, l10n.settingsDeleted);
  } catch (error) {
    if (context.mounted) _showError(context, error);
  }
}

Future<ShareResult> _shareFile(File file, String text) {
  return SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path)],
      text: text,
    ),
  );
}

void _showError(BuildContext context, Object error) {
  if (!context.mounted) return;
  _showMessage(
    context,
    '${AppLocalizations.of(context).commonError}: $error',
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
