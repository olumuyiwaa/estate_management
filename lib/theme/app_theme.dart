import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette - Deep navy + warm gold + clean white
  static const Color primary = Color(0xFF0D1B2A);      // Deep Navy
  static const Color secondary = Color(0xFF1B4F72);    // Mid Navy
  static const Color accent = Color(0xFFC9973A);       // Warm Gold
  static const Color accentLight = Color(0xFFF0C95F);  // Light Gold
  static const Color surface = Color(0xFFF8F9FA);      // Off White
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFE67E22);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF2980B9);
  static const Color textDark = Color(0xFF0D1B2A);
  static const Color textMid = Color(0xFF5D6D7E);
  static const Color textLight = Color(0xFF95A5A6);
  static const Color divider = Color(0xFFECF0F1);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: surface,
        background: surface,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32, fontWeight: FontWeight.w700, color: textDark,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 26, fontWeight: FontWeight.w700, color: textDark,
        ),
        headlineLarge: GoogleFonts.dmSans(
          fontSize: 22, fontWeight: FontWeight.w700, color: textDark,
        ),
        headlineMedium: GoogleFonts.dmSans(
          fontSize: 18, fontWeight: FontWeight.w600, color: textDark,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 16, fontWeight: FontWeight.w600, color: textDark,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w500, color: textDark,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15, fontWeight: FontWeight.w400, color: textDark,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w400, color: textMid,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w600, color: primary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: accent,
        unselectedItemColor: textLight,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }
}