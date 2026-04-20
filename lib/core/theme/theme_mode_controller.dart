import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController._() : super(ThemeMode.dark);

  static final ThemeModeController instance = ThemeModeController._();
  static const _storageKey = 'cavo_theme_mode';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    value = ThemeMode.dark;
    await _prefs?.setString(_storageKey, 'dark');
  }

  void setLight() {
    value = ThemeMode.dark;
    _prefs?.setString(_storageKey, 'dark');
  }

  void setDark() {
    value = ThemeMode.dark;
    _prefs?.setString(_storageKey, 'dark');
  }

  void toggle() {
    setDark();
  }
}
