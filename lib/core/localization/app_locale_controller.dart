import 'package:flutter/material.dart';

class AppLocaleController extends ValueNotifier<Locale> {
  AppLocaleController._() : super(const Locale('en'));

  static final AppLocaleController instance = AppLocaleController._();

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('ru'),
    Locale('de'),
  ];

  void setLocale(Locale locale) {
    value = locale;
  }

  void setByCode(String code) {
    switch (code.toLowerCase()) {
      case 'ar':
        value = const Locale('ar');
        break;
      case 'ru':
        value = const Locale('ru');
        break;
      case 'de':
        value = const Locale('de');
        break;
      default:
        value = const Locale('en');
    }
  }

  String get code => value.languageCode.toUpperCase();
}
