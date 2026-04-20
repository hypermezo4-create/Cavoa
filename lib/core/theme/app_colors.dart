import 'package:flutter/material.dart';

abstract final class CavoColors {
  // Existing dark palette
  static const Color background = Color(0xFF070707);
  static const Color backgroundSecondary = Color(0xFF0E0E0E);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceSoft = Color(0xFF1B1B1B);

  static const Color gold = Color(0xFFD4AF37);
  static const Color goldSoft = Color(0xFFC89B2A);
  static const Color goldLight = Color(0xFFF1D27A);

  static const Color textPrimary = Color(0xFFF5F1E8);
  static const Color textSecondary = Color(0xFFB8B1A3);
  static const Color textMuted = Color(0xFF7F786B);

  static const Color border = Color(0xFF2A2418);
  static const Color divider = Color(0xFF211C14);

  static const Color success = Color(0xFF3DDC97);
  static const Color error = Color(0xFFE35D5D);

  // New light palette
  static const Color lightBackground = Color(0xFFF5F7FB);
  static const Color lightBackgroundSecondary = Color(0xFFEDF1F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFF7F9FD);
  static const Color lightSurfaceMuted = Color(0xFFE9EEF8);

  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5565);
  static const Color lightTextMuted = Color(0xFF7A8597);

  static const Color lightBorder = Color(0xFFDDE3EE);
  static const Color lightDivider = Color(0xFFD5DCE8);

  // Glass / blur helpers
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassDark = Color(0x99121212);
  static const Color glassStrokeLight = Color(0xB3FFFFFF);
  static const Color glassStrokeDark = Color(0x33F1D27A);

  // Extra UI helpers for the upcoming redesign
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color heroDarkGlow = Color(0x1AD4AF37);
  static const Color heroLightGlow = Color(0x26D4AF37);

  static const Color darkShadow = Color(0x40000000);
  static const Color lightShadow = Color(0x1A1C2330);

  static const Color productImageLight = Color(0xFFF4F1EA);
  static const Color productImageDark = Color(0xFF111111);

  static const Color selectedChipLight = Color(0xFFF1E5BE);
  static const Color selectedChipDark = Color(0x33D4AF37);

  static const Color quantityLight = Color(0xFFF8F5EE);
  static const Color quantityDark = Color(0xFF171717);

  static const Color pillLight = Color(0xFFF3EFE5);
  static const Color pillDark = Color(0xFF181818);

  static const Color bottomBarLight = Color(0xF2FFFFFF);
  static const Color bottomBarDark = Color(0xF2181818);
}
