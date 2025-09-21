import 'package:flutter/material.dart';
// Liên kết SplashPage bên ngoài
import 'Code/Intro/splash_screen.dart';

// AppTheme giữ nguyên tạm thời ở đây (có thể tách ra file riêng sau)

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MonexApp());
}

class MonexApp extends StatefulWidget {
  const MonexApp({super.key});
  @override
  State<MonexApp> createState() => _MonexAppState();
}

class _MonexAppState extends State<MonexApp> {
  // Mặc định theo hệ thống (System Dark/Light)
  ThemeMode _mode = ThemeMode.system;

  // Gợi ý: nếu muốn toggle trong runtime, bạn có thể
  // truyền callback này xuống HomePage và gắn vào 1 switch.
  void setThemeMode(ThemeMode m) => setState(() => _mode = m);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monex',
      debugShowCheckedModeBanner:
          false, // -> đổi sang ThemeMode.dark/light để test nhanh
      themeMode: _mode,
      // Màn hình đầu tiên: SplashScreen (logo + chuyển hướng Intro)
      home: const SplashScreen(),
    );
  }
}
