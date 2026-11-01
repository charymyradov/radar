import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../../features/calibration/calibration_page.dart';
import '../../features/history/history_page.dart';
import '../../features/live/live_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/stats/stats_page.dart';
import '../../features/violations/violations_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/live',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(
        currentPath: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/live',
          builder: (context, state) => const LivePage(),
        ),
        GoRoute(
          path: '/calibration',
          builder: (context, state) => const CalibrationPage(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryPage(),
          routes: [
            GoRoute(
              path: ':sessionId',
              builder: (context, state) => SessionDetailPage(
                sessionId: state.pathParameters['sessionId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatsPage(),
        ),
        GoRoute(
          path: '/violations',
          builder: (context, state) => const ViolationsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
