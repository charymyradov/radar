import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/live/live_session_controller.dart';
import '../../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

class AppShell extends ConsumerWidget {
  const AppShell({
    required this.currentPath,
    required this.child,
    super.key,
  });

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final destinations = [
      (l10n.navLive, Icons.videocam_rounded, '/live'),
      (l10n.calibrationTitle, Icons.straighten_rounded, '/calibration'),
      (l10n.navHistory, Icons.history_rounded, '/history'),
      (l10n.navStats, Icons.bar_chart_rounded, '/stats'),
      (l10n.navViolations, Icons.speed_rounded, '/violations'),
      (l10n.navSettings, Icons.settings_rounded, '/settings'),
    ];
    final selectedIndex = destinations.indexWhere(
      (destination) => currentPath == destination.$3 ||
          currentPath.startsWith('${destination.$3}/'),
    );
    final selected = selectedIndex < 0 ? 0 : selectedIndex;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          if (index != 0) {
            unawaited(ref.read(liveSessionProvider.notifier).stop());
          }
          context.go(destinations[index].$3);
        },
        destinations: [
          for (var index = 0; index < destinations.length; index++)
            NavigationDestination(
              icon: Icon(destinations[index].$2),
              selectedIcon: Icon(
                destinations[index].$2,
                color: AppTheme.accent,
              ),
              label: destinations[index].$1,
            ),
        ],
      ),
    );
  }
}
