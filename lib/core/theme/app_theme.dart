import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    const colorScheme = ColorScheme.dark(
      primary: CavoColors.gold,
      secondary: CavoColors.goldSoft,
      surface: CavoColors.surface,
      error: CavoColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: CavoColors.textPrimary,
      onError: Colors.white,
    );

    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: CavoColors.background,
      colorScheme: colorScheme,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerColor: CavoColors.divider,
      canvasColor: CavoColors.background,
      cardColor: CavoColors.surface,
      shadowColor: CavoColors.darkShadow,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: CavoColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        displayMedium: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: CavoColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: CavoColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          color: CavoColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CavoColors.gold,
          foregroundColor: Colors.black,
          disabledBackgroundColor: CavoColors.gold.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.black54,
          elevation: 0,
          shadowColor: CavoColors.gold.withValues(alpha: 0.26),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CavoColors.textPrimary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: CavoColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CavoColors.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: const TextStyle(
          color: CavoColors.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CavoColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CavoColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CavoColors.gold, width: 1.2),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: CavoColors.gold,
        unselectedItemColor: CavoColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: CavoColors.surfaceSoft,
        selectedColor: CavoColors.gold,
        disabledColor: CavoColors.surfaceSoft,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        side: const BorderSide(color: CavoColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelStyle: const TextStyle(
          color: CavoColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    const colorScheme = ColorScheme.light(
      primary: CavoColors.gold,
      secondary: CavoColors.goldSoft,
      surface: CavoColors.lightSurface,
      error: CavoColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: CavoColors.lightTextPrimary,
      onError: Colors.white,
    );

    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: CavoColors.lightBackground,
      colorScheme: colorScheme,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerColor: CavoColors.lightDivider,
      canvasColor: CavoColors.lightBackground,
      cardColor: CavoColors.lightSurface,
      shadowColor: CavoColors.lightShadow,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: CavoColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        displayMedium: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: CavoColors.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: CavoColors.lightTextSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          color: CavoColors.lightTextMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CavoColors.gold,
          foregroundColor: Colors.black,
          disabledBackgroundColor: CavoColors.gold.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.black54,
          elevation: 0,
          shadowColor: CavoColors.lightShadow.withValues(alpha: 0.30),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CavoColors.lightTextPrimary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: CavoColors.lightBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF6F9FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: const TextStyle(
          color: CavoColors.lightTextMuted,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CavoColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CavoColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CavoColors.gold, width: 1.2),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: CavoColors.gold,
        unselectedItemColor: CavoColors.lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: CavoColors.lightSurfaceSoft,
        selectedColor: CavoColors.selectedChipLight,
        disabledColor: CavoColors.lightSurfaceMuted,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        side: const BorderSide(color: CavoColors.lightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelStyle: const TextStyle(
          color: CavoColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        shadowColor: CavoColors.lightShadow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(color: CavoColors.lightBorder, width: 1.1),
        ),
      ),
    );
  }
}
