import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ValueNotifier<Locale> {
  AppLocaleController._() : super(const Locale('en'));

  static final AppLocaleController instance = AppLocaleController._();
  static const _storageKey = 'cavo_locale_code';

  SharedPreferences? _prefs;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('ru'),
    Locale('de'),
  ];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedCode = _prefs?.getString(_storageKey);
    if (savedCode != null && savedCode.isNotEmpty) {
      setByCode(savedCode, save: false);
    }
  }

  void setLocale(Locale locale, {bool save = true}) {
    value = locale;
    if (save) {
      _prefs?.setString(_storageKey, locale.languageCode);
    }
  }

  void setByCode(String code, {bool save = true}) {
    switch (code.toLowerCase()) {
      case 'ar':
        setLocale(const Locale('ar'), save: save);
        break;
      case 'ru':
        setLocale(const Locale('ru'), save: save);
        break;
      case 'de':
        setLocale(const Locale('de'), save: save);
        break;
      default:
        setLocale(const Locale('en'), save: save);
    }
  }

  String get code => value.languageCode.toUpperCase();
}
