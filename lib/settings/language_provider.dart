import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageProvider() {
    _loadSavedLocale();
  }

  static const _prefKey = 'app_language_code';

  Locale _locale = AppLocalizations.supportedLocales.first;
  bool _initialized = false;

  Locale get locale => _locale;
  bool get initialized => _initialized;

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    )) {
      return;
    }

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null &&
        AppLocalizations.supportedLocales.any(
          (locale) => locale.languageCode == code,
        )) {
      _locale = Locale(code);
    }
    _initialized = true;
    notifyListeners();
  }
}
