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
  static const _primary = Color(0xFF2563EB);
  static const _secondary = Color(0xFF10B981);
  static const _accent = Color(0xFFF59E0B);
  static const _lightBg = Color(0xFFF8FAFC);
  static const _lightCard = Colors.white;
  static const _darkBg = Color(0xFF0F172A);
  static const _darkCard = Color(0xFF1E293B);
  static const _lightText = Color(0xFF0F172A);
  static const _darkText = Color(0xFFF1F5F9);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      primary: _primary,
      secondary: _secondary,
      surface: _lightCard,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _lightBg,
      textTheme: GoogleFonts.manropeTextTheme(),
    );

    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w800, color: _lightText),
        headlineMedium: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: _lightText),
        titleLarge: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: _lightText),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: _lightCard, foregroundColor: _lightText, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: _primary, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      secondary: _secondary,
      tertiary: _accent,
      surface: _darkCard,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _darkBg,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
    );

    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w800, color: _darkText),
        headlineMedium: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: _darkText),
        titleLarge: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: _darkText),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: _darkCard, foregroundColor: _darkText, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0B1220),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: _primary, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}

