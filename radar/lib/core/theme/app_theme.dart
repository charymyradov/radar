import 'package:flutter/material.dart';

/// Dark, high contrast theme: the camera image is the hero, the UI must not
/// steal attention at night.
class AppTheme {
  static const Color accent = Color(0xFF39D98A);
  static const Color danger = Color(0xFFFF4D4F);
  static const Color warning = Color(0xFFFFB020);
  static const Color background = Color(0xFF0B0F14);
  static const Color surface = Color(0xFF141A21);
  static const Color surfaceHigh = Color(0xFF1C242D);

  /// Tabular figures look much better for counters and speeds.
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: accent,
      onPrimary: Color(0xFF04160D),
      secondary: Color(0xFF5AA9FF),
      onSecondary: Color(0xFF04121F),
      error: danger,
      onError: Colors.white,
      surface: surface,
      onSurface: Color(0xFFE6EDF3),
      surfaceContainerHighest: surfaceHigh,
      outline: Color(0xFF39434F),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        isDense: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFE6EDF3),
        displayColor: const Color(0xFFE6EDF3),
      ),
    );
  }

  /// Monospaced-ish style for big numbers.
  static TextStyle numeric(TextStyle? base, {double size = 32}) =>
      (base ?? const TextStyle()).copyWith(
        fontSize: size,
        fontWeight: FontWeight.w700,
        fontFeatures: _tabular,
        letterSpacing: -0.5,
      );
}
