import 'package:flutter/material.dart';

class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController._() : super(ThemeMode.dark);

  static final ThemeModeController instance = ThemeModeController._();

  void setLight() => value = ThemeMode.light;

  void setDark() => value = ThemeMode.dark;

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}