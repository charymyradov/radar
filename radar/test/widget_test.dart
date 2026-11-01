import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radar/core/navigation/radar_app.dart';
import 'package:radar/core/providers.dart';
import 'package:radar/features/settings/domain/app_settings.dart';
import 'package:radar/l10n/generated/app_localizations.dart';

class _TestSettingsController extends SettingsController {
  @override
  Future<AppSettings> build() async => const AppSettings();
}

void main() {
  testWidgets('application starts on the live route with all destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsProvider.overrideWith(_TestSettingsController.new)],
        child: const RadarApp(),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('tr'));
    expect(find.text(l10n.liveTitle), findsOneWidget);
    expect(find.text(l10n.navLive), findsOneWidget);
    expect(find.text(l10n.calibrationTitle), findsOneWidget);
    expect(find.text(l10n.navHistory), findsOneWidget);
    expect(find.text(l10n.navStats), findsOneWidget);
    expect(find.text(l10n.navViolations), findsOneWidget);
    expect(find.text(l10n.navSettings), findsOneWidget);
  });
}
