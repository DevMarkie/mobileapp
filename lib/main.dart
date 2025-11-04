import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controllers/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final settingsController = SettingsController();
  await settingsController.load();

  runApp(
    ChangeNotifierProvider.value(
      value: settingsController,
      child: const MonexApp(),
    ),
  );
}
