import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette inspired by Corvanta.ng
  static const Color primary = Color(0xFF0D6EFD);      // Bright Blue
  static const Color secondary = Color(0xFF6610F2);    // Deep Purple
  static const Color accent = Color(0xFF0DCAF0);       // Cyan
  static const Color accentLight = Color(0xFFE3F8FF);  // Light Cyan
  static const Color surface = Color(0xFFFFFFFF);      // White
  static const Color cardBg = Color(0xFFF8FAFB);
  static const Color success = Color(0xFF20C997);      // Green
  static const Color warning = Color(0xFFFFC107);      // Amber
  static const Color error = Color(0xFFDC3545);        // Red
  static const Color info = Color(0xFF0DCAF0);         // Cyan
  static const Color textDark = Color(0xFF212529);     // Dark Gray
  static const Color textMid = Color(0xFF495057);      // Medium Gray
  static const Color textLight = Color(0xFF6C757D);    // Light Gray
  static const Color divider = Color(0xFFDEE2E6);      // Pale Gray

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