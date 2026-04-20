import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController._() : super(ThemeMode.dark);

  static final ThemeModeController instance = ThemeModeController._();
  static const _storageKey = 'cavo_theme_mode';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs?.getString(_storageKey);
    switch (stored) {
      case 'light':
        value = ThemeMode.light;
        break;
      case 'dark':
        value = ThemeMode.dark;
        break;
      case 'system':
        value = ThemeMode.system;
        break;
      default:
        value = ThemeMode.dark;
        await _prefs?.setString(_storageKey, 'dark');
    }
  }

  void setLight() {
    value = ThemeMode.light;
    _prefs?.setString(_storageKey, 'light');
  }

  void setDark() {
    value = ThemeMode.dark;
    _prefs?.setString(_storageKey, 'dark');
  }

  void toggle() {
    if (value == ThemeMode.light) {
      setDark();
    } else {
      setLight();
    }
  }
}
