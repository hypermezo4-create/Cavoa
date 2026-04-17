import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController._() : super(ThemeMode.dark);

  static final ThemeModeController instance = ThemeModeController._();
  static const _storageKey = 'cavo_theme_mode';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedMode = _prefs?.getString(_storageKey);
    if (savedMode == 'light') {
      value = ThemeMode.light;
    } else if (savedMode == 'dark') {
      value = ThemeMode.dark;
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
    if (value == ThemeMode.dark) {
      setLight();
    } else {
      setDark();
    }
  }
}
