import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _transitionTimer = Timer(const Duration(seconds: 2), _openOnboarding);
  }

  void _openOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: _SplashLogo()),
    );
  }
}

class _SplashLogo extends StatefulWidget {
  const _SplashLogo();

  @override
  State<_SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<_SplashLogo> {
  double _logoOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _logoOpacity = 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _logoOpacity,
      duration: const Duration(milliseconds: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('lib/theme/logo.png', width: 140, height: 140),
          const SizedBox(height: 24),
          const Text(
            'monex',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
