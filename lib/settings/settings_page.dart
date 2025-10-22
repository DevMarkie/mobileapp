import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';
import 'language_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final locale = languageProvider.locale;

    return Scaffold(
      appBar: AppBar(title: Text(context.loc(AppStrings.settingsTitle))),
      body: languageProvider.initialized
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    context.loc(AppStrings.settingsLanguageSection),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                RadioListTile<String>(
                  value: 'en',
                  groupValue: locale.languageCode,
                  onChanged: (_) =>
                      _changeLanguage(context, const Locale('en')),
                  title: Text(context.loc(AppStrings.settingsLanguageEnglish)),
                ),
                RadioListTile<String>(
                  value: 'vi',
                  groupValue: locale.languageCode,
                  onChanged: (_) =>
                      _changeLanguage(context, const Locale('vi')),
                  title: Text(
                    context.loc(AppStrings.settingsLanguageVietnamese),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    final provider = context.read<LanguageProvider>();
    if (provider.locale.languageCode == locale.languageCode) {
      return;
    }
    await provider.setLocale(locale);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.loc(AppStrings.settingsLanguageApplied))),
    );
  }
}
