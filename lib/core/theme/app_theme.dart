import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeMode themeModeFromSetting(String setting) {
  switch (setting) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

class AppTheme {
  static const _seed = Color(0xFF0F766E);
  static const _sand = Color(0xFFF7F1E5);
  static const _ink = Color(0xFF132A3A);
  static const _gold = Color(0xFFE8B04B);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      primary: _seed,
      secondary: _gold,
      surface: Colors.white,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _sand,
      textTheme: GoogleFonts.manropeTextTheme(),
    );
    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.dmSerifDisplay(fontSize: 42, color: _ink),
        headlineMedium: GoogleFonts.dmSerifDisplay(fontSize: 30, color: _ink),
        titleLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          fontSize: 22,
          color: _ink,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _ink,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.88),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _gold,
      brightness: Brightness.dark,
      primary: _gold,
      secondary: _seed,
      surface: const Color(0xFF182633),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0F1821),
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
    );
    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.dmSerifDisplay(fontSize: 42, color: Colors.white),
        headlineMedium: GoogleFonts.dmSerifDisplay(fontSize: 30, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF182633),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
