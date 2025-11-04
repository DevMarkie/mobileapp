import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralised controller that keeps track of the user's interface preferences.
///
/// The controller exposes a [ThemeMode] and [Locale] for the application to
/// consume. Both preferences are persisted using [SharedPreferences] so they
/// remain intact between sessions.
class SettingsController extends ChangeNotifier {
  SettingsController();

  static const _languageKey = 'settings.language_code';
  static const _themeKey = 'settings.theme_mode';

  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;
  SharedPreferences? _preferences;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  /// Loads persisted preferences, falling back to defaults when necessary.
  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();

    final storedLanguageCode = _preferences?.getString(_languageKey);
    if (storedLanguageCode != null && storedLanguageCode.isNotEmpty) {
      _locale = Locale(storedLanguageCode);
    }

    final storedTheme = _preferences?.getString(_themeKey);
    if (storedTheme != null) {
      _themeMode = storedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    await _ensurePreferences();
    await _preferences!.setString(_languageKey, locale.languageCode);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    await _ensurePreferences();
    await _preferences!.setString(
      _themeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> _ensurePreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }
}
