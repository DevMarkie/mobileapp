import 'package:flutter/material.dart';

import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/models/onboarding_page_data.dart';
import 'package:flutter_application_1/screens/auth/login_screen.dart';
import 'package:flutter_application_1/widgets/dots_indicator.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final onboardingPages = [
      OnboardingPageData(
        imagePath: 'lib/theme/2.png',
        title: localizations.onboardingTitle1,
        description: localizations.onboardingDesc1,
      ),
      OnboardingPageData(
        imagePath: 'lib/theme/3.png',
        title: localizations.onboardingTitle2,
        description: localizations.onboardingDesc2,
      ),
      OnboardingPageData(
        imagePath: 'lib/theme/4.png',
        title: localizations.onboardingTitle3,
        description: localizations.onboardingDesc3,
      ),
    ];
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/theme/logo.png', width: 42, height: 42),
                  const SizedBox(width: 10),
                  Text(
                    'monex',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingPages.length,
                  onPageChanged: (index) => _currentPage.value = index,
                  itemBuilder: (context, index) {
                    final page = onboardingPages[index];
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Image.asset(
                              page.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 280,
                          child: Text(
                            page.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, page, _) {
                  return DotsIndicator(
                    count: onboardingPages.length,
                    currentIndex: page,
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (context, page, _) {
                    return GradientButton(
                      label: localizations.onboardingCta,
                      onTap: () {
                        final isLastPage = page == onboardingPages.length - 1;
                        if (isLastPage) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
