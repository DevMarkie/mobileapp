import 'dart:async';
import 'package:flutter/material.dart';
import 'IntroScreen.dart';

// SplashScreen: hiển thị logo ngắn rồi chuyển sang IntroScreen (onboarding đầu tiên)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Bật hiệu ứng fade-in
    Future.microtask(() => setState(() => _visible = true));

    // Chờ 1.6s rồi chuyển sang Home
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const IntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo: đường dẫn phải khớp với phần khai báo trong pubspec.yaml.
                // Có thể chuyển sang assets/images/ để chuẩn hoá sau.
                // Nếu không thấy logo: chạy lại `flutter pub get` hoặc hot restart.
                Image.asset(
                  'lib/theme/Overview/Group.png',
                  width: 144,
                  height: 144,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.error_outline,
                    size: 72,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'monex',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF242C35),
                    fontSize: 46,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.10,
                    letterSpacing: -0.46,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
