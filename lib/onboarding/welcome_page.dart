import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.42; // responsive header
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Rounded gradient header with soft decorative circles
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: SizedBox(
                height: headerH.clamp(280, 420),
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB027F5), Color(0xFF1E78FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    // decorative soft circles
                    Positioned(
                      right: -60,
                      top: -30,
                      child: _SoftCircle(
                        diameter: 160,
                        color: Colors.white.withValues(alpha: 0.20),
                      ),
                    ),
                    Positioned(
                      right: -110,
                      bottom: -70,
                      child: _SoftCircle(
                        diameter: 260,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 20,
                      child: Image.asset(
                        'lib/theme/Launch-Screen.png',
                        color: Colors.white,
                        height: 36,
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      bottom: 32,
                      child: Text(
                        'WELCOME\nBACK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          height: 1.1,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PrimaryGradientButton(
                    text: 'Sign In',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signin');
                    },
                  ),
                  const SizedBox(height: 14),
                  _OutlinedPillButton(
                    text: 'Sign Up',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFB027F5), Color(0xFF1E78FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3327449B),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // decorative gradient blob on the right
              Positioned(
                right: 8,
                top: 6,
                bottom: 6,
                child: Container(
                  width: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // centered text
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              // right arrow, independent from text centering
              const Positioned(
                right: 18,
                child: Icon(Icons.arrow_right_alt, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  const _OutlinedPillButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1A27449B),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              side: const BorderSide(color: Color(0xFFB8C2FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onPressed,
            child: const SizedBox(height: 24, width: double.infinity),
          ),
          // centered text
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0B2AA3),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Positioned(
            right: 24,
            child: Icon(Icons.arrow_right_alt, color: Color(0xFF0B2AA3)),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.diameter, required this.color});
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
