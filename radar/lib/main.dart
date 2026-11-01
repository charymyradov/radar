import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/radar_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Detection, calibration and the overlay all work in the upright (portrait)
  // frame. Locking the UI keeps that space stable instead of rotating the
  // camera stream at runtime for every device orientation.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: RadarApp()));
}
