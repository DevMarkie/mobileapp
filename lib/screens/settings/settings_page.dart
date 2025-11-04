import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: Consumer<SettingsController>(
        builder: (context, settings, _) {
          final isDarkMode = settings.themeMode == ThemeMode.dark;
          final languageName = settings.locale.languageCode == 'vi'
              ? localizations.vietnamese
              : localizations.english;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              _SectionHeader(text: localizations.appearanceSection),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: SwitchListTile.adaptive(
                  value: isDarkMode,
                  onChanged: (value) => settings.updateThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  ),
                  title: Text(localizations.theme),
                  subtitle: Text(localizations.darkModeSubtitle),
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(text: localizations.languageSection),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: ListTile(
                  title: Text(localizations.language),
                  subtitle: Text(
                    '${localizations.languageSubtitle}\n$languageName',
                  ),
                  trailing: DropdownButton<Locale>(
                    value: settings.locale,
                    underline: const SizedBox.shrink(),
                    onChanged: (value) {
                      if (value != null) settings.updateLocale(value);
                    },
                    items: [
                      DropdownMenuItem(
                        value: const Locale('en'),
                        child: Text(localizations.english),
                      ),
                      DropdownMenuItem(
                        value: const Locale('vi'),
                        child: Text(localizations.vietnamese),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
