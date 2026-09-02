import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'eco_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        color: EcoColors.textPrimaryLight,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.outfit(
        color: EcoColors.textPrimaryLight,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.outfit(
        color: EcoColors.textPrimaryLight,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.outfit(
        color: EcoColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        color: EcoColors.textPrimaryLight,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        color: EcoColors.textPrimaryLight,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        color: EcoColors.textSecondaryLight,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        color: EcoColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: EcoColors.obsidianBg,
      primaryColor: EcoColors.emeraldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: EcoColors.emeraldPrimary,
        secondary: EcoColors.savannaGold,
        surface: EcoColors.darkCardBg,
        error: EcoColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: EcoColors.textPrimaryLight,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: EcoColors.darkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: EcoColors.cardBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: EcoColors.obsidianBg,
        elevation: 0,
        iconTheme: IconThemeData(color: EcoColors.textPrimaryLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EcoColors.darkCardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.emeraldPrimary, width: 1.5),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(color: EcoColors.textMuted, fontSize: 13),
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        color: EcoColors.textPrimaryDark,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.outfit(
        color: EcoColors.textPrimaryDark,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.outfit(
        color: EcoColors.textPrimaryDark,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.outfit(
        color: EcoColors.textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        color: EcoColors.textPrimaryDark,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        color: EcoColors.textPrimaryDark,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        color: EcoColors.textSecondaryDark,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        color: EcoColors.textMutedDark,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: EcoColors.lightBg,
      primaryColor: EcoColors.emeraldPrimary,
      colorScheme: const ColorScheme.light(
        primary: EcoColors.emeraldPrimary,
        secondary: EcoColors.savannaGold,
        surface: EcoColors.lightCardBg,
        error: EcoColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: EcoColors.textPrimaryDark,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: EcoColors.lightCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: EcoColors.lightCardBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: EcoColors.textPrimaryDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.lightCardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.lightCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.emeraldPrimary, width: 1.5),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(color: EcoColors.textMutedDark, fontSize: 13),
      ),
    );
  }
}
