# Radar

Telefonda çevrimdışı çalışan, tek kullanıcılı araç sayma ve hız ölçme
uygulaması.

## Çalıştırma

```shell
flutter pub get
flutter run
```

Testler için `flutter test`, statik analiz için `flutter analyze` çalıştırın.

## Özellikler

- Android arka kamera önizlemesi ve cihaz üzerinde YOLO TFLite araç tespiti.
- A/B çizgileriyle kalibrasyon; A çizgisinde sayım ve iki çizgi arasındaki
  geçiş süresinden yaklaşık hız ölçümü.
- Oturum, olay, hız ihlali ve ihlal görsellerinin yerel Drift veritabanına
  kaydı.
- Oturum ve araç geçmişi, olay düzeltme/eleme, dönem istatistikleri ve ihlal
  inceleme ekranları.
- Türkçe/İngilizce dil, hız birimi/limiti ve kamera performans ayarları;
  CSV/PDF dışa aktarma ve görselleri de içeren yedekleme/geri yükleme.

Tespit canlı oturum başlatıldıktan sonra çalışır. Araç sayılması için A çizgisini
geçmesi gerekir; hız hesaplamak için aynı yönde A ve B çizgilerinden geçmesi
gerekir. Hız, kamera konumuna ve kalibrasyona bağlı yaklaşık ölçümdür; resmi
trafik denetimi veya sertifikalı radar ölçümü yerine geçmez. Kamerayı sabitleyin,
çizgileri yolun tamamını kesecek şekilde yerleştirin ve aralarındaki gerçek
mesafeyi ölçün.

Testler için `flutter test`, statik analiz için `flutter analyze` çalıştırın.
Android release APK'sı `flutter build apk --release` ile
`build/app/outputs/flutter-apk/app-release.apk` konumuna üretilir.

## Varsayımlar

- Uygulama tek bir varsayılan istasyon kullanır; hesap veya sunucu yoktur.
- Hızlar veritabanında km/h olarak tutulur; gösterim birimi ayarlardan gelir.
- Kalibrasyon koordinatları, döndürülmüş kamera görüntüsüne göre normalize edilir.
- Kamera ve kalibrasyon ekranları, algılama koordinatlarıyla hizayı korumak için
  portre yönelimine kilitlenir.
- Yalnızca hız ihlallerinde görsel saklanır; olağan tespitlerde görsel tutulmaz.
