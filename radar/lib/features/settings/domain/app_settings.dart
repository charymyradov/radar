import 'dart:convert';

import '../../../domain/models/enums.dart';

/// Camera stream quality presets. Mapped to `ResolutionPreset` at the edge so
/// the settings model stays free of plugin types.
enum CameraQuality {
  low,
  medium,
  high;

  static CameraQuality fromName(String? name) {
    for (final value in CameraQuality.values) {
      if (value.name == name) return value;
    }
    return CameraQuality.high;
  }
}

/// Supported UI languages.
enum AppLanguage {
  tr,
  en;

  static AppLanguage fromCode(String? code) =>
      code == 'en' ? AppLanguage.en : AppLanguage.tr;

  String get code => name;
}

/// Persisted application settings. Stored as a single JSON blob in the
/// `settings_entries` table so new fields can be added without a migration.
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.tr,
    this.unit = SpeedUnit.kmh,
    this.speedLimitKmh = 50,
    this.targetFps = 15,
    this.cameraQuality = CameraQuality.high,
    this.imageRetentionDays = 30,
    this.flipDirection = false,
    this.backupReminder = true,
    this.lastBackupAt,
    this.showOverlay = true,
  });

  final AppLanguage language;
  final SpeedUnit unit;
  final double speedLimitKmh;
  final int targetFps;
  final CameraQuality cameraQuality;
  final int imageRetentionDays;
  final bool flipDirection;
  final bool backupReminder;
  final DateTime? lastBackupAt;
  final bool showOverlay;

  static const String storageKey = 'app_settings';

  AppSettings copyWith({
    AppLanguage? language,
    SpeedUnit? unit,
    double? speedLimitKmh,
    int? targetFps,
    CameraQuality? cameraQuality,
    int? imageRetentionDays,
    bool? flipDirection,
    bool? backupReminder,
    DateTime? lastBackupAt,
    bool clearLastBackup = false,
    bool? showOverlay,
  }) {
    return AppSettings(
      language: language ?? this.language,
      unit: unit ?? this.unit,
      speedLimitKmh: speedLimitKmh ?? this.speedLimitKmh,
      targetFps: targetFps ?? this.targetFps,
      cameraQuality: cameraQuality ?? this.cameraQuality,
      imageRetentionDays: imageRetentionDays ?? this.imageRetentionDays,
      flipDirection: flipDirection ?? this.flipDirection,
      backupReminder: backupReminder ?? this.backupReminder,
      lastBackupAt:
          clearLastBackup ? null : (lastBackupAt ?? this.lastBackupAt),
      showOverlay: showOverlay ?? this.showOverlay,
    );
  }

  /// True when the weekly reminder should be shown.
  bool get backupDue {
    if (!backupReminder) return false;
    final last = lastBackupAt;
    if (last == null) return true;
    return DateTime.now().toUtc().difference(last) > const Duration(days: 7);
  }

  String toJsonString() => jsonEncode({
        'version': 1,
        'language': language.code,
        'unit': unit.name,
        'speedLimitKmh': speedLimitKmh,
        'targetFps': targetFps,
        'cameraQuality': cameraQuality.name,
        'imageRetentionDays': imageRetentionDays,
        'flipDirection': flipDirection,
        'backupReminder': backupReminder,
        'lastBackupAt': lastBackupAt?.toUtc().toIso8601String(),
        'showOverlay': showOverlay,
      });

  static AppSettings fromJsonString(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const AppSettings();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings(
        language: AppLanguage.fromCode(json['language'] as String?),
        unit: json['unit'] == SpeedUnit.mph.name ? SpeedUnit.mph : SpeedUnit.kmh,
        speedLimitKmh: (json['speedLimitKmh'] as num?)?.toDouble() ?? 50,
        targetFps: ((json['targetFps'] as num?)?.toInt() ?? 15).clamp(5, 30),
        cameraQuality:
            CameraQuality.fromName(json['cameraQuality'] as String?),
        imageRetentionDays:
            (json['imageRetentionDays'] as num?)?.toInt() ?? 30,
        flipDirection: json['flipDirection'] as bool? ?? false,
        backupReminder: json['backupReminder'] as bool? ?? true,
        lastBackupAt: json['lastBackupAt'] == null
            ? null
            : DateTime.tryParse(json['lastBackupAt'] as String)?.toUtc(),
        showOverlay: json['showOverlay'] as bool? ?? true,
      );
    } catch (_) {
      // A corrupted blob must never brick the app.
      return const AppSettings();
    }
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.unit == unit &&
      other.speedLimitKmh == speedLimitKmh &&
      other.targetFps == targetFps &&
      other.cameraQuality == cameraQuality &&
      other.imageRetentionDays == imageRetentionDays &&
      other.flipDirection == flipDirection &&
      other.backupReminder == backupReminder &&
      other.lastBackupAt == lastBackupAt &&
      other.showOverlay == showOverlay;

  @override
  int get hashCode => Object.hash(
        language,
        unit,
        speedLimitKmh,
        targetFps,
        cameraQuality,
        imageRetentionDays,
        flipDirection,
        backupReminder,
        lastBackupAt,
        showOverlay,
      );
}
