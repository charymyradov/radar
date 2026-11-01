// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Road Radar';

  @override
  String get navLive => 'Live';

  @override
  String get navHistory => 'History';

  @override
  String get navStats => 'Stats';

  @override
  String get navViolations => 'Violations';

  @override
  String get navSettings => 'Settings';

  @override
  String get databaseStartupError =>
      'The local database could not be opened. Check available storage and try again.';

  @override
  String get stageScaffoldOnly =>
      'This screen is part of the application scaffold. Its functionality will be added in the planned implementation stages.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonAll => 'All';

  @override
  String get commonNone => 'None';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonBack => 'Back';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get vehicleCar => 'Car';

  @override
  String get vehicleMotorcycle => 'Motorcycle';

  @override
  String get vehicleBus => 'Bus';

  @override
  String get vehicleTruck => 'Truck';

  @override
  String get directionInbound => 'Inbound';

  @override
  String get directionOutbound => 'Outbound';

  @override
  String get classLabel => 'Class';

  @override
  String get directionLabel => 'Direction';

  @override
  String get speedLabel => 'Speed';

  @override
  String get noSpeed => 'No speed';

  @override
  String get liveTitle => 'Live counting';

  @override
  String get liveStart => 'Start';

  @override
  String get liveStop => 'Stop';

  @override
  String get livePause => 'Pause';

  @override
  String get liveResume => 'Resume';

  @override
  String get liveReset => 'Reset counters';

  @override
  String get liveResetTitle => 'Reset counters?';

  @override
  String get liveResetBody =>
      'The current session keeps running but all counters and the live list start from zero. Stored events are not removed.';

  @override
  String get liveTotal => 'Total';

  @override
  String get liveByClass => 'By class';

  @override
  String get liveByDirection => 'By direction';

  @override
  String get liveLastVehicles => 'Last 5 vehicles';

  @override
  String get liveNoVehicles => 'No vehicles counted yet';

  @override
  String get liveAvgSpeed => 'Average';

  @override
  String get liveMaxSpeed => 'Highest';

  @override
  String get livePerHour => 'Vehicles / hour';

  @override
  String get liveDetectionWaiting => 'Analyzing frames…';

  @override
  String get liveNothingDetected => 'No vehicle detected';

  @override
  String liveDetectionCount(Object count) {
    return '$count vehicle(s) detected';
  }

  @override
  String get liveCountingRule =>
      'Vehicles are counted when they cross line A. Speed is measured only after crossing both lines.';

  @override
  String get liveFpsWarning => 'Low frame rate';

  @override
  String get liveFpsWarningBody =>
      'The device cannot keep up, image quality was reduced automatically.';

  @override
  String get liveHeatWarning => 'Device is warming up';

  @override
  String get liveHeatWarningBody =>
      'Reduce the target FPS or move the phone to a cooler place.';

  @override
  String get liveStorageFull => 'Storage is full';

  @override
  String get liveStorageFullBody =>
      'Counting stopped because events cannot be saved. Free up space and try again.';

  @override
  String get liveNeedsCalibration => 'Calibration required';

  @override
  String get liveNeedsCalibrationBody =>
      'Draw line A and line B and enter the real distance before counting.';

  @override
  String get liveGoToCalibration => 'Open calibration';

  @override
  String get liveCameraPermission => 'Camera permission denied';

  @override
  String get liveCameraPermissionBody =>
      'This app needs the camera to count vehicles. Nothing is uploaded.';

  @override
  String get liveOpenSystemSettings => 'Open app settings';

  @override
  String get liveModelError => 'Detection model could not be loaded';

  @override
  String get liveModelErrorBody =>
      'Reinstall the app or check that the model asset is present.';

  @override
  String get liveCameraError => 'Camera could not be started';

  @override
  String get liveSessionRunning => 'Session running';

  @override
  String get liveCameraMoved => 'The camera may have moved since calibration';

  @override
  String get liveCameraMovedBody =>
      'Compare the current view with the saved reference image.';

  @override
  String get liveShowOverlay => 'Boxes';

  @override
  String get livePrivacy =>
      'No plate or face recognition. Images are stored only for speed violations.';

  @override
  String get calibrationTitle => 'Calibration';

  @override
  String get calibrationLineA => 'Line A (count)';

  @override
  String get calibrationLineB => 'Line B (speed)';

  @override
  String get calibrationDragHint =>
      'Drag the handles to place the lines across the road.';

  @override
  String get calibrationDistance => 'Real distance between A and B';

  @override
  String get calibrationDistanceHint => 'Metres';

  @override
  String get calibrationSave => 'Save calibration';

  @override
  String get calibrationSaved => 'Calibration saved as a new version';

  @override
  String get calibrationTestMode => 'Test crossing mode';

  @override
  String get calibrationTestModeHint =>
      'Counting is simulated; nothing is written to the database.';

  @override
  String get calibrationReference => 'Reference image';

  @override
  String get calibrationRefreshReference => 'Update reference image';

  @override
  String get calibrationVersions => 'Saved versions';

  @override
  String get calibrationActive => 'Active';

  @override
  String get calibrationSetActive => 'Use this version';

  @override
  String get calibrationInvalid => 'Place both lines across the road first';

  @override
  String get calibrationDistanceInvalid =>
      'Enter a distance between 1 and 500 metres';

  @override
  String get calibrationResetLines => 'Reset lines';

  @override
  String get calibrationNoCamera =>
      'Camera preview is unavailable, use the grid below.';

  @override
  String get historyTitle => 'History';

  @override
  String get historyNoSessions => 'No sessions yet';

  @override
  String get historySession => 'Session';

  @override
  String get historyStarted => 'Started';

  @override
  String get historyEnded => 'Ended';

  @override
  String get historyDuration => 'Duration';

  @override
  String get historyEvents => 'Events';

  @override
  String get historyOpen => 'Open';

  @override
  String get historyDeleteTitle => 'Delete session?';

  @override
  String get historyDeleteBody =>
      'All events, violations and images of this session are removed permanently.';

  @override
  String get historyDeleted => 'Session deleted';

  @override
  String get historyFilters => 'Filters';

  @override
  String get historyDateFrom => 'From';

  @override
  String get historyDateTo => 'To';

  @override
  String get historyOnlyMeasured => 'Only measured speeds';

  @override
  String get historySpeedMin => 'Min speed';

  @override
  String get historySpeedMax => 'Max speed';

  @override
  String get historyMarkInvalid => 'Mark as wrong detection';

  @override
  String get historyMarkValid => 'Restore to statistics';

  @override
  String get historyChangeClass => 'Change class';

  @override
  String get historyEdit => 'Edit event';

  @override
  String get historyNoEvents => 'No events match these filters';

  @override
  String get historyEventTime => 'Time';

  @override
  String get historyConfidence => 'Confidence';

  @override
  String get historyTrackId => 'Track';

  @override
  String get historyInvalidBadge => 'Excluded';

  @override
  String get historySpeedUnknown => '—';

  @override
  String get historyCount => 'counted';

  @override
  String get historyMeasured => 'measured';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsPeriodToday => 'Today';

  @override
  String get statsPeriod7 => '7 days';

  @override
  String get statsPeriod30 => '30 days';

  @override
  String get statsPeriodAll => 'All time';

  @override
  String get statsTotal => 'Total vehicles';

  @override
  String get statsMeasured => 'Speed measured';

  @override
  String get statsMean => 'Average';

  @override
  String get statsMedian => 'Median';

  @override
  String get statsP85 => '85th percentile';

  @override
  String get statsMax => 'Maximum';

  @override
  String get statsMin => 'Minimum';

  @override
  String get statsHourly => 'Hourly distribution';

  @override
  String get statsDaily => 'Daily distribution';

  @override
  String get statsHistogram => 'Speed histogram (5 km/h)';

  @override
  String get statsBusiest => 'Busiest hour';

  @override
  String get statsClasses => 'Class distribution';

  @override
  String get statsDirections => 'Direction distribution';

  @override
  String get statsNoData => 'Not enough data for this period';

  @override
  String get statsCompare => 'Compare periods';

  @override
  String get statsCompareA => 'Period A';

  @override
  String get statsCompareB => 'Period B';

  @override
  String get statsMeasuredRatio => 'measured share';

  @override
  String get violationsTitle => 'Violations';

  @override
  String get violationsEmpty => 'No violations recorded';

  @override
  String get violationsPending => 'New';

  @override
  String get violationsReviewed => 'Reviewed';

  @override
  String get violationsIgnored => 'Ignored';

  @override
  String get violationsMarkReviewed => 'Mark reviewed';

  @override
  String get violationsMarkIgnored => 'Ignore';

  @override
  String get violationsLimit => 'Limit';

  @override
  String get violationsOver => 'Over by';

  @override
  String get violationsNoImage => 'Image not available';

  @override
  String get violationsShowImage => 'Show image';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSpeedLimit => 'Speed limit';

  @override
  String get settingsSpeedLimitHint =>
      'Used for violations and the red highlight';

  @override
  String get settingsUnit => 'Unit';

  @override
  String get settingsFps => 'Target FPS';

  @override
  String get settingsQuality => 'Camera quality';

  @override
  String get settingsQualityLow => 'Low';

  @override
  String get settingsQualityMedium => 'Medium';

  @override
  String get settingsQualityHigh => 'High';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsRetention => 'Image retention';

  @override
  String get settingsRetentionHint =>
      'Violation images older than this are deleted automatically';

  @override
  String get settingsDays => 'days';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsBackupNow => 'Back up now';

  @override
  String get settingsRestore => 'Restore from file';

  @override
  String get settingsLastBackup => 'Last backup';

  @override
  String get settingsNever => 'Never';

  @override
  String get settingsBackupReminder => 'Remind me weekly';

  @override
  String get settingsBackupReminderBody =>
      'Your last backup is more than a week old.';

  @override
  String get settingsRestoreTitle => 'Restore backup?';

  @override
  String get settingsRestoreBody =>
      'Current data is replaced by the contents of the archive.';

  @override
  String get settingsRestoreDone => 'Backup restored';

  @override
  String get settingsRestoreFailed => 'This file is not a valid backup';

  @override
  String get settingsExport => 'Reports';

  @override
  String get settingsExportCsv => 'Export CSV';

  @override
  String get settingsExportPdf => 'Export PDF report';

  @override
  String get settingsExportAll => 'Export all data';

  @override
  String get settingsDangerZone => 'Delete data';

  @override
  String get settingsDeleteAll => 'Delete all data';

  @override
  String get settingsDeleteAllTitle => 'Delete everything?';

  @override
  String get settingsDeleteAllBody =>
      'Sessions, events, calibrations and images are removed. This cannot be undone.';

  @override
  String get settingsDeleted => 'All data deleted';

  @override
  String get settingsStorage => 'Storage';

  @override
  String get settingsStorageUsage => 'Database size';

  @override
  String get settingsBatteryNote =>
      'Counting keeps the screen on and uses the camera continuously. Expect the battery to drain faster and the phone to get warm.';

  @override
  String get settingsPrivacy =>
      'Everything stays on this device. No account, no server, no analytics.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsBackupDone => 'Backup ready';

  @override
  String get settingsBackupReminderTitle => 'Time for a backup';

  @override
  String get settingsBackupNowShort => 'Back up';

  @override
  String get notifChannelName => 'Counting service';

  @override
  String get notifTitle => 'Counting vehicles';

  @override
  String get notifBody => 'The camera is running. Tap to return to the app.';

  @override
  String get notifStop => 'Stop';

  @override
  String get errorPermissionDenied => 'Permission denied';

  @override
  String get errorStorageFull => 'Storage full';

  @override
  String get errorFileAccess => 'File access failed';

  @override
  String get errorDatabase => 'Database error';
}
