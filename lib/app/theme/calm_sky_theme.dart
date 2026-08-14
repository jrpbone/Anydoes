import 'package:flutter/material.dart';

abstract final class CalmSkyTheme {
  static const _sky = Color(0xFF2878E3);
  static const _canvas = Color(0xFFF4F7FB);

  static ThemeData light({bool highContrast = false}) =>
      _theme(brightness: Brightness.light, highContrast: highContrast);

  static ThemeData dark({bool highContrast = false}) =>
      _theme(brightness: Brightness.dark, highContrast: highContrast);

  static ThemeData _theme({
    required Brightness brightness,
    required bool highContrast,
  }) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _sky,
          brightness: brightness,
          surface: dark ? const Color(0xFF10151D) : _canvas,
        ).copyWith(
          primary: dark ? const Color(0xFF9CC4FF) : _sky,
          primaryContainer: dark
              ? const Color(0xFF17477E)
              : const Color(0xFFDCEAFF),
          onPrimaryContainer: dark
              ? const Color(0xFFE7F1FF)
              : const Color(0xFF0B3C7D),
          surface: dark ? const Color(0xFF10151D) : _canvas,
          surfaceContainerLowest: dark ? const Color(0xFF151B24) : Colors.white,
          surfaceContainerLow: dark
              ? const Color(0xFF1B222D)
              : const Color(0xFFF9FBFF),
          outline: highContrast
              ? (dark ? Colors.white : const Color(0xFF26354A))
              : (dark ? const Color(0xFF8793A4) : const Color(0xFFC8D2E1)),
          outlineVariant: highContrast
              ? (dark ? const Color(0xFFD7E2F2) : const Color(0xFF596A82))
              : (dark ? const Color(0xFF394452) : const Color(0xFFE1E7F0)),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.45),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.4),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        selectedLabelTextStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
