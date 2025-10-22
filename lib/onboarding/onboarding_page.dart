import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';

/// Monex onboarding flow with three slides.
class MonexOnboarding extends StatefulWidget {
  const MonexOnboarding({super.key});

  @override
  State<MonexOnboarding> createState() => _MonexOnboardingState();
}

class _MonexOnboardingState extends State<MonexOnboarding> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <_OnboardingData>[
      _OnboardingData(
        imagePath: 'lib/theme/Page-1.png',
        titleKey: AppStrings.onboardingSlide1Title,
        subtitleKey: AppStrings.onboardingSlide1Subtitle,
        buttonKey: AppStrings.onboardingNext,
      ),
      _OnboardingData(
        imagePath: 'lib/theme/Safety Box 1.png',
        titleKey: AppStrings.onboardingSlide2Title,
        subtitleKey: AppStrings.onboardingSlide2Subtitle,
        buttonKey: AppStrings.onboardingNext,
      ),
      _OnboardingData(
        imagePath: 'lib/theme/Trading 1.png',
        titleKey: AppStrings.onboardingSlide3Title,
        subtitleKey: AppStrings.onboardingSlide3Subtitle,
        buttonKey: AppStrings.onboardingGetStarted,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Small logo on top
            Center(
              child: Image.asset('lib/theme/Launch-Screen.png', height: 36),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: pages.length,
                itemBuilder: (context, i) => _OnboardingSlide(data: pages[i]),
              ),
            ),
            const SizedBox(height: 8),
            _Dots(count: pages.length, index: _index),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: _GradientButton(
                text: context.loc(pages[_index].buttonKey),
                onPressed: () async {
                  if (_index < pages.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else {
                    // Finished -> go to Welcome page
                    Navigator.of(context).pushReplacementNamed('/welcome');
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                data.imagePath,
                height: 260,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.loc(data.titleKey),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF0B2AA3), // deep blue like design
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.loc(data.subtitleKey),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280), // gray
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFFB027F5), Color(0xFF1E78FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right_alt, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E78FF) : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _OnboardingData {
  final String imagePath;
  final String titleKey;
  final String subtitleKey;
  final String buttonKey;

  const _OnboardingData({
    required this.imagePath,
    required this.titleKey,
    required this.subtitleKey,
    required this.buttonKey,
  });
}
