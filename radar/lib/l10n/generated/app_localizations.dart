import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Road Radar'**
  String get appTitle;

  /// No description provided for @navLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get navLive;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navViolations.
  ///
  /// In en, this message translates to:
  /// **'Violations'**
  String get navViolations;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @databaseStartupError.
  ///
  /// In en, this message translates to:
  /// **'The local database could not be opened. Check available storage and try again.'**
  String get databaseStartupError;

  /// No description provided for @stageScaffoldOnly.
  ///
  /// In en, this message translates to:
  /// **'This screen is part of the application scaffold. Its functionality will be added in the planned implementation stages.'**
  String get stageScaffoldOnly;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonUnknown;

  /// No description provided for @vehicleCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get vehicleCar;

  /// No description provided for @vehicleMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get vehicleMotorcycle;

  /// No description provided for @vehicleBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get vehicleBus;

  /// No description provided for @vehicleTruck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get vehicleTruck;

  /// No description provided for @directionInbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get directionInbound;

  /// No description provided for @directionOutbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get directionOutbound;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @directionLabel.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get directionLabel;

  /// No description provided for @speedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// No description provided for @noSpeed.
  ///
  /// In en, this message translates to:
  /// **'No speed'**
  String get noSpeed;

  /// No description provided for @liveTitle.
  ///
  /// In en, this message translates to:
  /// **'Live counting'**
  String get liveTitle;

  /// No description provided for @liveStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get liveStart;

  /// No description provided for @liveStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get liveStop;

  /// No description provided for @livePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get livePause;

  /// No description provided for @liveResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get liveResume;

  /// No description provided for @liveReset.
  ///
  /// In en, this message translates to:
  /// **'Reset counters'**
  String get liveReset;

  /// No description provided for @liveResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset counters?'**
  String get liveResetTitle;

  /// No description provided for @liveResetBody.
  ///
  /// In en, this message translates to:
  /// **'The current session keeps running but all counters and the live list start from zero. Stored events are not removed.'**
  String get liveResetBody;

  /// No description provided for @liveTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get liveTotal;

  /// No description provided for @liveByClass.
  ///
  /// In en, this message translates to:
  /// **'By class'**
  String get liveByClass;

  /// No description provided for @liveByDirection.
  ///
  /// In en, this message translates to:
  /// **'By direction'**
  String get liveByDirection;

  /// No description provided for @liveLastVehicles.
  ///
  /// In en, this message translates to:
  /// **'Last 5 vehicles'**
  String get liveLastVehicles;

  /// No description provided for @liveNoVehicles.
  ///
  /// In en, this message translates to:
  /// **'No vehicles counted yet'**
  String get liveNoVehicles;

  /// No description provided for @liveAvgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get liveAvgSpeed;

  /// No description provided for @liveMaxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get liveMaxSpeed;

  /// No description provided for @livePerHour.
  ///
  /// In en, this message translates to:
  /// **'Vehicles / hour'**
  String get livePerHour;

  /// No description provided for @liveDetectionWaiting.
  ///
  /// In en, this message translates to:
  /// **'Analyzing frames…'**
  String get liveDetectionWaiting;

  /// No description provided for @liveNothingDetected.
  ///
  /// In en, this message translates to:
  /// **'No vehicle detected'**
  String get liveNothingDetected;

  /// No description provided for @liveDetectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} vehicle(s) detected'**
  String liveDetectionCount(Object count);

  /// No description provided for @liveCountingRule.
  ///
  /// In en, this message translates to:
  /// **'Vehicles are counted when they cross line A. Speed is measured only after crossing both lines.'**
  String get liveCountingRule;

  /// No description provided for @liveFpsWarning.
  ///
  /// In en, this message translates to:
  /// **'Low frame rate'**
  String get liveFpsWarning;

  /// No description provided for @liveFpsWarningBody.
  ///
  /// In en, this message translates to:
  /// **'The device cannot keep up, image quality was reduced automatically.'**
  String get liveFpsWarningBody;

  /// No description provided for @liveHeatWarning.
  ///
  /// In en, this message translates to:
  /// **'Device is warming up'**
  String get liveHeatWarning;

  /// No description provided for @liveHeatWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Reduce the target FPS or move the phone to a cooler place.'**
  String get liveHeatWarningBody;

  /// No description provided for @liveStorageFull.
  ///
  /// In en, this message translates to:
  /// **'Storage is full'**
  String get liveStorageFull;

  /// No description provided for @liveStorageFullBody.
  ///
  /// In en, this message translates to:
  /// **'Counting stopped because events cannot be saved. Free up space and try again.'**
  String get liveStorageFullBody;

  /// No description provided for @liveNeedsCalibration.
  ///
  /// In en, this message translates to:
  /// **'Calibration required'**
  String get liveNeedsCalibration;

  /// No description provided for @liveNeedsCalibrationBody.
  ///
  /// In en, this message translates to:
  /// **'Draw line A and line B and enter the real distance before counting.'**
  String get liveNeedsCalibrationBody;

  /// No description provided for @liveGoToCalibration.
  ///
  /// In en, this message translates to:
  /// **'Open calibration'**
  String get liveGoToCalibration;

  /// No description provided for @liveCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get liveCameraPermission;

  /// No description provided for @liveCameraPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'This app needs the camera to count vehicles. Nothing is uploaded.'**
  String get liveCameraPermissionBody;

  /// No description provided for @liveOpenSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get liveOpenSystemSettings;

  /// No description provided for @liveModelError.
  ///
  /// In en, this message translates to:
  /// **'Detection model could not be loaded'**
  String get liveModelError;

  /// No description provided for @liveModelErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Reinstall the app or check that the model asset is present.'**
  String get liveModelErrorBody;

  /// No description provided for @liveCameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera could not be started'**
  String get liveCameraError;

  /// No description provided for @liveSessionRunning.
  ///
  /// In en, this message translates to:
  /// **'Session running'**
  String get liveSessionRunning;

  /// No description provided for @liveCameraMoved.
  ///
  /// In en, this message translates to:
  /// **'The camera may have moved since calibration'**
  String get liveCameraMoved;

  /// No description provided for @liveCameraMovedBody.
  ///
  /// In en, this message translates to:
  /// **'Compare the current view with the saved reference image.'**
  String get liveCameraMovedBody;

  /// No description provided for @liveShowOverlay.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get liveShowOverlay;

  /// No description provided for @livePrivacy.
  ///
  /// In en, this message translates to:
  /// **'No plate or face recognition. Images are stored only for speed violations.'**
  String get livePrivacy;

  /// No description provided for @calibrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get calibrationTitle;

  /// No description provided for @calibrationLineA.
  ///
  /// In en, this message translates to:
  /// **'Line A (count)'**
  String get calibrationLineA;

  /// No description provided for @calibrationLineB.
  ///
  /// In en, this message translates to:
  /// **'Line B (speed)'**
  String get calibrationLineB;

  /// No description provided for @calibrationDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the handles to place the lines across the road.'**
  String get calibrationDragHint;

  /// No description provided for @calibrationDistance.
  ///
  /// In en, this message translates to:
  /// **'Real distance between A and B'**
  String get calibrationDistance;

  /// No description provided for @calibrationDistanceHint.
  ///
  /// In en, this message translates to:
  /// **'Metres'**
  String get calibrationDistanceHint;

  /// No description provided for @calibrationSave.
  ///
  /// In en, this message translates to:
  /// **'Save calibration'**
  String get calibrationSave;

  /// No description provided for @calibrationSaved.
  ///
  /// In en, this message translates to:
  /// **'Calibration saved as a new version'**
  String get calibrationSaved;

  /// No description provided for @calibrationTestMode.
  ///
  /// In en, this message translates to:
  /// **'Test crossing mode'**
  String get calibrationTestMode;

  /// No description provided for @calibrationTestModeHint.
  ///
  /// In en, this message translates to:
  /// **'Counting is simulated; nothing is written to the database.'**
  String get calibrationTestModeHint;

  /// No description provided for @calibrationReference.
  ///
  /// In en, this message translates to:
  /// **'Reference image'**
  String get calibrationReference;

  /// No description provided for @calibrationRefreshReference.
  ///
  /// In en, this message translates to:
  /// **'Update reference image'**
  String get calibrationRefreshReference;

  /// No description provided for @calibrationVersions.
  ///
  /// In en, this message translates to:
  /// **'Saved versions'**
  String get calibrationVersions;

  /// No description provided for @calibrationActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get calibrationActive;

  /// No description provided for @calibrationSetActive.
  ///
  /// In en, this message translates to:
  /// **'Use this version'**
  String get calibrationSetActive;

  /// No description provided for @calibrationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Place both lines across the road first'**
  String get calibrationInvalid;

  /// No description provided for @calibrationDistanceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a distance between 1 and 500 metres'**
  String get calibrationDistanceInvalid;

  /// No description provided for @calibrationResetLines.
  ///
  /// In en, this message translates to:
  /// **'Reset lines'**
  String get calibrationResetLines;

  /// No description provided for @calibrationNoCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera preview is unavailable, use the grid below.'**
  String get calibrationNoCamera;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get historyNoSessions;

  /// No description provided for @historySession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get historySession;

  /// No description provided for @historyStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get historyStarted;

  /// No description provided for @historyEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get historyEnded;

  /// No description provided for @historyDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get historyDuration;

  /// No description provided for @historyEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get historyEvents;

  /// No description provided for @historyOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get historyOpen;

  /// No description provided for @historyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'All events, violations and images of this session are removed permanently.'**
  String get historyDeleteBody;

  /// No description provided for @historyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Session deleted'**
  String get historyDeleted;

  /// No description provided for @historyFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get historyFilters;

  /// No description provided for @historyDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get historyDateFrom;

  /// No description provided for @historyDateTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get historyDateTo;

  /// No description provided for @historyOnlyMeasured.
  ///
  /// In en, this message translates to:
  /// **'Only measured speeds'**
  String get historyOnlyMeasured;

  /// No description provided for @historySpeedMin.
  ///
  /// In en, this message translates to:
  /// **'Min speed'**
  String get historySpeedMin;

  /// No description provided for @historySpeedMax.
  ///
  /// In en, this message translates to:
  /// **'Max speed'**
  String get historySpeedMax;

  /// No description provided for @historyMarkInvalid.
  ///
  /// In en, this message translates to:
  /// **'Mark as wrong detection'**
  String get historyMarkInvalid;

  /// No description provided for @historyMarkValid.
  ///
  /// In en, this message translates to:
  /// **'Restore to statistics'**
  String get historyMarkValid;

  /// No description provided for @historyChangeClass.
  ///
  /// In en, this message translates to:
  /// **'Change class'**
  String get historyChangeClass;

  /// No description provided for @historyEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get historyEdit;

  /// No description provided for @historyNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events match these filters'**
  String get historyNoEvents;

  /// No description provided for @historyEventTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get historyEventTime;

  /// No description provided for @historyConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get historyConfidence;

  /// No description provided for @historyTrackId.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get historyTrackId;

  /// No description provided for @historyInvalidBadge.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get historyInvalidBadge;

  /// No description provided for @historySpeedUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get historySpeedUnknown;

  /// No description provided for @historyCount.
  ///
  /// In en, this message translates to:
  /// **'counted'**
  String get historyCount;

  /// No description provided for @historyMeasured.
  ///
  /// In en, this message translates to:
  /// **'measured'**
  String get historyMeasured;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsPeriodToday;

  /// No description provided for @statsPeriod7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get statsPeriod7;

  /// No description provided for @statsPeriod30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get statsPeriod30;

  /// No description provided for @statsPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get statsPeriodAll;

  /// No description provided for @statsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total vehicles'**
  String get statsTotal;

  /// No description provided for @statsMeasured.
  ///
  /// In en, this message translates to:
  /// **'Speed measured'**
  String get statsMeasured;

  /// No description provided for @statsMean.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statsMean;

  /// No description provided for @statsMedian.
  ///
  /// In en, this message translates to:
  /// **'Median'**
  String get statsMedian;

  /// No description provided for @statsP85.
  ///
  /// In en, this message translates to:
  /// **'85th percentile'**
  String get statsP85;

  /// No description provided for @statsMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get statsMax;

  /// No description provided for @statsMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get statsMin;

  /// No description provided for @statsHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly distribution'**
  String get statsHourly;

  /// No description provided for @statsDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily distribution'**
  String get statsDaily;

  /// No description provided for @statsHistogram.
  ///
  /// In en, this message translates to:
  /// **'Speed histogram (5 km/h)'**
  String get statsHistogram;

  /// No description provided for @statsBusiest.
  ///
  /// In en, this message translates to:
  /// **'Busiest hour'**
  String get statsBusiest;

  /// No description provided for @statsClasses.
  ///
  /// In en, this message translates to:
  /// **'Class distribution'**
  String get statsClasses;

  /// No description provided for @statsDirections.
  ///
  /// In en, this message translates to:
  /// **'Direction distribution'**
  String get statsDirections;

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data for this period'**
  String get statsNoData;

  /// No description provided for @statsCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare periods'**
  String get statsCompare;

  /// No description provided for @statsCompareA.
  ///
  /// In en, this message translates to:
  /// **'Period A'**
  String get statsCompareA;

  /// No description provided for @statsCompareB.
  ///
  /// In en, this message translates to:
  /// **'Period B'**
  String get statsCompareB;

  /// No description provided for @statsMeasuredRatio.
  ///
  /// In en, this message translates to:
  /// **'measured share'**
  String get statsMeasuredRatio;

  /// No description provided for @violationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Violations'**
  String get violationsTitle;

  /// No description provided for @violationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No violations recorded'**
  String get violationsEmpty;

  /// No description provided for @violationsPending.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get violationsPending;

  /// No description provided for @violationsReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get violationsReviewed;

  /// No description provided for @violationsIgnored.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get violationsIgnored;

  /// No description provided for @violationsMarkReviewed.
  ///
  /// In en, this message translates to:
  /// **'Mark reviewed'**
  String get violationsMarkReviewed;

  /// No description provided for @violationsMarkIgnored.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get violationsMarkIgnored;

  /// No description provided for @violationsLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get violationsLimit;

  /// No description provided for @violationsOver.
  ///
  /// In en, this message translates to:
  /// **'Over by'**
  String get violationsOver;

  /// No description provided for @violationsNoImage.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get violationsNoImage;

  /// No description provided for @violationsShowImage.
  ///
  /// In en, this message translates to:
  /// **'Show image'**
  String get violationsShowImage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSpeedLimit.
  ///
  /// In en, this message translates to:
  /// **'Speed limit'**
  String get settingsSpeedLimit;

  /// No description provided for @settingsSpeedLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Used for violations and the red highlight'**
  String get settingsSpeedLimitHint;

  /// No description provided for @settingsUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get settingsUnit;

  /// No description provided for @settingsFps.
  ///
  /// In en, this message translates to:
  /// **'Target FPS'**
  String get settingsFps;

  /// No description provided for @settingsQuality.
  ///
  /// In en, this message translates to:
  /// **'Camera quality'**
  String get settingsQuality;

  /// No description provided for @settingsQualityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get settingsQualityLow;

  /// No description provided for @settingsQualityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get settingsQualityMedium;

  /// No description provided for @settingsQualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get settingsQualityHigh;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsRetention.
  ///
  /// In en, this message translates to:
  /// **'Image retention'**
  String get settingsRetention;

  /// No description provided for @settingsRetentionHint.
  ///
  /// In en, this message translates to:
  /// **'Violation images older than this are deleted automatically'**
  String get settingsRetentionHint;

  /// No description provided for @settingsDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get settingsDays;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackup;

  /// No description provided for @settingsBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get settingsBackupNow;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from file'**
  String get settingsRestore;

  /// No description provided for @settingsLastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup'**
  String get settingsLastBackup;

  /// No description provided for @settingsNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get settingsNever;

  /// No description provided for @settingsBackupReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me weekly'**
  String get settingsBackupReminder;

  /// No description provided for @settingsBackupReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your last backup is more than a week old.'**
  String get settingsBackupReminderBody;

  /// No description provided for @settingsRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get settingsRestoreTitle;

  /// No description provided for @settingsRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'Current data is replaced by the contents of the archive.'**
  String get settingsRestoreBody;

  /// No description provided for @settingsRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get settingsRestoreDone;

  /// No description provided for @settingsRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid backup'**
  String get settingsRestoreFailed;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get settingsExport;

  /// No description provided for @settingsExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get settingsExportCsv;

  /// No description provided for @settingsExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF report'**
  String get settingsExportPdf;

  /// No description provided for @settingsExportAll.
  ///
  /// In en, this message translates to:
  /// **'Export all data'**
  String get settingsExportAll;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Delete data'**
  String get settingsDangerZone;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteAll;

  /// No description provided for @settingsDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete everything?'**
  String get settingsDeleteAllTitle;

  /// No description provided for @settingsDeleteAllBody.
  ///
  /// In en, this message translates to:
  /// **'Sessions, events, calibrations and images are removed. This cannot be undone.'**
  String get settingsDeleteAllBody;

  /// No description provided for @settingsDeleted.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get settingsDeleted;

  /// No description provided for @settingsStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsStorage;

  /// No description provided for @settingsStorageUsage.
  ///
  /// In en, this message translates to:
  /// **'Database size'**
  String get settingsStorageUsage;

  /// No description provided for @settingsBatteryNote.
  ///
  /// In en, this message translates to:
  /// **'Counting keeps the screen on and uses the camera continuously. Expect the battery to drain faster and the phone to get warm.'**
  String get settingsBatteryNote;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this device. No account, no server, no analytics.'**
  String get settingsPrivacy;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsBackupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup ready'**
  String get settingsBackupDone;

  /// No description provided for @settingsBackupReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a backup'**
  String get settingsBackupReminderTitle;

  /// No description provided for @settingsBackupNowShort.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get settingsBackupNowShort;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Counting service'**
  String get notifChannelName;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Counting vehicles'**
  String get notifTitle;

  /// No description provided for @notifBody.
  ///
  /// In en, this message translates to:
  /// **'The camera is running. Tap to return to the app.'**
  String get notifBody;

  /// No description provided for @notifStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get notifStop;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermissionDenied;

  /// No description provided for @errorStorageFull.
  ///
  /// In en, this message translates to:
  /// **'Storage full'**
  String get errorStorageFull;

  /// No description provided for @errorFileAccess.
  ///
  /// In en, this message translates to:
  /// **'File access failed'**
  String get errorFileAccess;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database error'**
  String get errorDatabase;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
