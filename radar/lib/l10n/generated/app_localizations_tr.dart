// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Yol Radarı';

  @override
  String get navLive => 'Canlı';

  @override
  String get navHistory => 'Geçmiş';

  @override
  String get navStats => 'İstatistik';

  @override
  String get navViolations => 'İhlaller';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get databaseStartupError =>
      'Yerel veritabanı açılamadı. Depolama alanını kontrol edip yeniden deneyin.';

  @override
  String get stageScaffoldOnly =>
      'Bu ekran uygulama iskeletinde hazır. İşlevi, planlanan sonraki geliştirme aşamalarında eklenecek.';

  @override
  String get commonCancel => 'Vazgeç';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonConfirm => 'Onayla';

  @override
  String get commonAll => 'Tümü';

  @override
  String get commonNone => 'Yok';

  @override
  String get commonLoading => 'Yükleniyor…';

  @override
  String get commonError => 'Bir şeyler ters gitti';

  @override
  String get commonApply => 'Uygula';

  @override
  String get commonClear => 'Temizle';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonToday => 'Bugün';

  @override
  String get commonYesterday => 'Dün';

  @override
  String get commonUnknown => 'Bilinmiyor';

  @override
  String get vehicleCar => 'Araba';

  @override
  String get vehicleMotorcycle => 'Motosiklet';

  @override
  String get vehicleBus => 'Otobüs';

  @override
  String get vehicleTruck => 'Kamyon';

  @override
  String get directionInbound => 'Giren';

  @override
  String get directionOutbound => 'Çıkan';

  @override
  String get classLabel => 'Sınıf';

  @override
  String get directionLabel => 'Yön';

  @override
  String get speedLabel => 'Hız';

  @override
  String get noSpeed => 'Hız yok';

  @override
  String get liveTitle => 'Canlı sayım';

  @override
  String get liveStart => 'Başlat';

  @override
  String get liveStop => 'Bitir';

  @override
  String get livePause => 'Duraklat';

  @override
  String get liveResume => 'Devam';

  @override
  String get liveReset => 'Sayaçları sıfırla';

  @override
  String get liveResetTitle => 'Sayaçlar sıfırlansın mı?';

  @override
  String get liveResetBody =>
      'Oturum çalışmaya devam eder, sayaçlar ve son araç listesi sıfırlanır. Kayıtlı olaylar silinmez.';

  @override
  String get liveTotal => 'Toplam';

  @override
  String get liveByClass => 'Sınıfa göre';

  @override
  String get liveByDirection => 'Yöne göre';

  @override
  String get liveLastVehicles => 'Son 5 araç';

  @override
  String get liveNoVehicles => 'Henüz araç sayılmadı';

  @override
  String get liveAvgSpeed => 'Ortalama';

  @override
  String get liveMaxSpeed => 'En yüksek';

  @override
  String get livePerHour => 'Araç / saat';

  @override
  String get liveDetectionWaiting => 'Kareler analiz ediliyor…';

  @override
  String get liveNothingDetected => 'Araç tespit edilmedi';

  @override
  String liveDetectionCount(Object count) {
    return '$count araç tespit edildi';
  }

  @override
  String get liveCountingRule =>
      'Araç, A çizgisini geçince sayılır. Hız için iki çizgiyi de geçmesi gerekir.';

  @override
  String get liveFpsWarning => 'Düşük kare hızı';

  @override
  String get liveFpsWarningBody =>
      'Cihaz yetişemiyor, görüntü kalitesi otomatik düşürüldü.';

  @override
  String get liveHeatWarning => 'Cihaz ısınıyor';

  @override
  String get liveHeatWarningBody =>
      'Hedef FPS\'i düşürün veya telefonu serin bir yere alın.';

  @override
  String get liveStorageFull => 'Depolama dolu';

  @override
  String get liveStorageFullBody =>
      'Olaylar kaydedilemediği için sayım durduruldu. Yer açıp tekrar deneyin.';

  @override
  String get liveNeedsCalibration => 'Kalibrasyon gerekli';

  @override
  String get liveNeedsCalibrationBody =>
      'Sayımdan önce A ve B çizgilerini çizip gerçek mesafeyi girin.';

  @override
  String get liveGoToCalibration => 'Kalibrasyonu aç';

  @override
  String get liveCameraPermission => 'Kamera izni verilmedi';

  @override
  String get liveCameraPermissionBody =>
      'Araç saymak için kameraya ihtiyaç var. Hiçbir görüntü yüklenmez.';

  @override
  String get liveOpenSystemSettings => 'Uygulama ayarlarını aç';

  @override
  String get liveModelError => 'Tespit modeli yüklenemedi';

  @override
  String get liveModelErrorBody =>
      'Uygulamayı yeniden kurun veya model dosyasının varlığını kontrol edin.';

  @override
  String get liveCameraError => 'Kamera başlatılamadı';

  @override
  String get liveSessionRunning => 'Oturum çalışıyor';

  @override
  String get liveCameraMoved => 'Kamera kalibrasyondan sonra oynamış olabilir';

  @override
  String get liveCameraMovedBody =>
      'Güncel görüntüyü kayıtlı referans görüntüyle karşılaştırın.';

  @override
  String get liveShowOverlay => 'Kutular';

  @override
  String get livePrivacy =>
      'Plaka veya yüz tanıma yok. Görsel yalnızca hız ihlallerinde saklanır.';

  @override
  String get calibrationTitle => 'Kalibrasyon';

  @override
  String get calibrationLineA => 'A çizgisi (sayım)';

  @override
  String get calibrationLineB => 'B çizgisi (hız)';

  @override
  String get calibrationDragHint =>
      'Tutamakları sürükleyerek çizgileri yolun üzerine yerleştirin.';

  @override
  String get calibrationDistance => 'A ile B arasındaki gerçek mesafe';

  @override
  String get calibrationDistanceHint => 'Metre';

  @override
  String get calibrationSave => 'Kalibrasyonu kaydet';

  @override
  String get calibrationSaved => 'Kalibrasyon yeni sürüm olarak kaydedildi';

  @override
  String get calibrationTestMode => 'Test geçişi modu';

  @override
  String get calibrationTestModeHint =>
      'Sayım simüle edilir, veritabanına hiçbir şey yazılmaz.';

  @override
  String get calibrationReference => 'Referans görüntü';

  @override
  String get calibrationRefreshReference => 'Referans görüntüyü güncelle';

  @override
  String get calibrationVersions => 'Kayıtlı sürümler';

  @override
  String get calibrationActive => 'Etkin';

  @override
  String get calibrationSetActive => 'Bu sürümü kullan';

  @override
  String get calibrationInvalid =>
      'Önce iki çizgiyi de yolun üzerine yerleştirin';

  @override
  String get calibrationDistanceInvalid =>
      '1 ile 500 metre arasında bir mesafe girin';

  @override
  String get calibrationResetLines => 'Çizgileri sıfırla';

  @override
  String get calibrationNoCamera =>
      'Kamera önizlemesi yok, alttaki ızgarayı kullanın.';

  @override
  String get historyTitle => 'Geçmiş';

  @override
  String get historyNoSessions => 'Henüz oturum yok';

  @override
  String get historySession => 'Oturum';

  @override
  String get historyStarted => 'Başlangıç';

  @override
  String get historyEnded => 'Bitiş';

  @override
  String get historyDuration => 'Süre';

  @override
  String get historyEvents => 'Olaylar';

  @override
  String get historyOpen => 'Aç';

  @override
  String get historyDeleteTitle => 'Oturum silinsin mi?';

  @override
  String get historyDeleteBody =>
      'Bu oturumun tüm olayları, ihlalleri ve görselleri kalıcı olarak silinir.';

  @override
  String get historyDeleted => 'Oturum silindi';

  @override
  String get historyFilters => 'Filtreler';

  @override
  String get historyDateFrom => 'Başlangıç';

  @override
  String get historyDateTo => 'Bitiş';

  @override
  String get historyOnlyMeasured => 'Sadece hızı ölçülenler';

  @override
  String get historySpeedMin => 'En az hız';

  @override
  String get historySpeedMax => 'En çok hız';

  @override
  String get historyMarkInvalid => 'Yanlış tespit olarak işaretle';

  @override
  String get historyMarkValid => 'İstatistiğe geri al';

  @override
  String get historyChangeClass => 'Sınıfı düzelt';

  @override
  String get historyEdit => 'Olayı düzenle';

  @override
  String get historyNoEvents => 'Bu filtreye uyan olay yok';

  @override
  String get historyEventTime => 'Zaman';

  @override
  String get historyConfidence => 'Güven';

  @override
  String get historyTrackId => 'Takip';

  @override
  String get historyInvalidBadge => 'Hariç';

  @override
  String get historySpeedUnknown => '—';

  @override
  String get historyCount => 'sayıldı';

  @override
  String get historyMeasured => 'ölçüldü';

  @override
  String get statsTitle => 'İstatistik';

  @override
  String get statsPeriodToday => 'Bugün';

  @override
  String get statsPeriod7 => '7 gün';

  @override
  String get statsPeriod30 => '30 gün';

  @override
  String get statsPeriodAll => 'Tüm zamanlar';

  @override
  String get statsTotal => 'Toplam araç';

  @override
  String get statsMeasured => 'Hızı ölçülen';

  @override
  String get statsMean => 'Ortalama';

  @override
  String get statsMedian => 'Medyan';

  @override
  String get statsP85 => '85. yüzdelik';

  @override
  String get statsMax => 'En yüksek';

  @override
  String get statsMin => 'En düşük';

  @override
  String get statsHourly => 'Saatlik dağılım';

  @override
  String get statsDaily => 'Günlük dağılım';

  @override
  String get statsHistogram => 'Hız histogramı (5 km/s)';

  @override
  String get statsBusiest => 'En yoğun saat';

  @override
  String get statsClasses => 'Sınıf dağılımı';

  @override
  String get statsDirections => 'Yön dağılımı';

  @override
  String get statsNoData => 'Bu dönem için yeterli veri yok';

  @override
  String get statsCompare => 'Dönem karşılaştırma';

  @override
  String get statsCompareA => 'Dönem A';

  @override
  String get statsCompareB => 'Dönem B';

  @override
  String get statsMeasuredRatio => 'ölçülen oran';

  @override
  String get violationsTitle => 'İhlaller';

  @override
  String get violationsEmpty => 'Kayıtlı ihlal yok';

  @override
  String get violationsPending => 'Yeni';

  @override
  String get violationsReviewed => 'İncelendi';

  @override
  String get violationsIgnored => 'Yoksay';

  @override
  String get violationsMarkReviewed => 'İncelendi olarak işaretle';

  @override
  String get violationsMarkIgnored => 'Yoksay';

  @override
  String get violationsLimit => 'Limit';

  @override
  String get violationsOver => 'Aşım';

  @override
  String get violationsNoImage => 'Görsel yok';

  @override
  String get violationsShowImage => 'Görseli göster';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSpeedLimit => 'Hız limiti';

  @override
  String get settingsSpeedLimitHint =>
      'İhlaller ve kırmızı vurgu için kullanılır';

  @override
  String get settingsUnit => 'Birim';

  @override
  String get settingsFps => 'Hedef FPS';

  @override
  String get settingsQuality => 'Kamera kalitesi';

  @override
  String get settingsQualityLow => 'Düşük';

  @override
  String get settingsQualityMedium => 'Orta';

  @override
  String get settingsQualityHigh => 'Yüksek';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsRetention => 'Görsel saklama süresi';

  @override
  String get settingsRetentionHint =>
      'Bu süreden eski ihlal görselleri otomatik silinir';

  @override
  String get settingsDays => 'gün';

  @override
  String get settingsBackup => 'Yedekleme';

  @override
  String get settingsBackupNow => 'Şimdi yedekle';

  @override
  String get settingsRestore => 'Dosyadan geri yükle';

  @override
  String get settingsLastBackup => 'Son yedek';

  @override
  String get settingsNever => 'Hiç';

  @override
  String get settingsBackupReminder => 'Haftalık hatırlat';

  @override
  String get settingsBackupReminderBody =>
      'Son yedeğinizin üzerinden bir haftadan fazla geçti.';

  @override
  String get settingsRestoreTitle => 'Yedek geri yüklensin mi?';

  @override
  String get settingsRestoreBody =>
      'Mevcut veriler arşivin içeriğiyle değiştirilir.';

  @override
  String get settingsRestoreDone => 'Yedek geri yüklendi';

  @override
  String get settingsRestoreFailed => 'Bu dosya geçerli bir yedek değil';

  @override
  String get settingsExport => 'Raporlar';

  @override
  String get settingsExportCsv => 'CSV dışa aktar';

  @override
  String get settingsExportPdf => 'PDF raporu';

  @override
  String get settingsExportAll => 'Tüm verileri dışa aktar';

  @override
  String get settingsDangerZone => 'Veri silme';

  @override
  String get settingsDeleteAll => 'Tüm verileri sil';

  @override
  String get settingsDeleteAllTitle => 'Her şey silinsin mi?';

  @override
  String get settingsDeleteAllBody =>
      'Oturumlar, olaylar, kalibrasyonlar ve görseller silinir. Bu işlem geri alınamaz.';

  @override
  String get settingsDeleted => 'Tüm veriler silindi';

  @override
  String get settingsStorage => 'Depolama';

  @override
  String get settingsStorageUsage => 'Veritabanı boyutu';

  @override
  String get settingsBatteryNote =>
      'Sayım ekranı açık tutar ve kamerayı sürekli kullanır. Pil daha hızlı biter ve telefon ısınabilir.';

  @override
  String get settingsPrivacy =>
      'Her şey bu cihazda kalır. Hesap yok, sunucu yok, analitik yok.';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get settingsBackupDone => 'Yedek hazır';

  @override
  String get settingsBackupReminderTitle => 'Yedek zamanı';

  @override
  String get settingsBackupNowShort => 'Yedekle';

  @override
  String get notifChannelName => 'Sayım servisi';

  @override
  String get notifTitle => 'Araç sayımı sürüyor';

  @override
  String get notifBody => 'Kamera çalışıyor. Uygulamaya dönmek için dokunun.';

  @override
  String get notifStop => 'Durdur';

  @override
  String get errorPermissionDenied => 'İzin verilmedi';

  @override
  String get errorStorageFull => 'Depolama dolu';

  @override
  String get errorFileAccess => 'Dosya erişimi başarısız';

  @override
  String get errorDatabase => 'Veritabanı hatası';
}
