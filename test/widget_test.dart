// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/controllers/settings_controller.dart';

void main() {
  testWidgets('Splash screen displays the Monex brand', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settingsController = SettingsController();
    await settingsController.load();

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsController>.value(
        value: settingsController,
        child: const MonexApp(),
      ),
    );

    // Allow the first frame to build.
    await tester.pump();

    expect(find.text('monex'), findsWidgets);
  });
}
