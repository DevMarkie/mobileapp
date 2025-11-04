import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/settings_controller.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_colors.dart';

class MonexApp extends StatelessWidget {
  const MonexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settings, _) {
        final lightTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            primary: AppColors.primaryBlue,
            secondary: AppColors.accentBlue,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          useMaterial3: true,
        );

        final darkTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            primary: AppColors.primaryBlue,
            secondary: AppColors.accentBlue,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          useMaterial3: true,
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.themeMode,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SplashScreen(),
        );
      },
    );
  }
}
