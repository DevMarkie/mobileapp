import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/auth/forgot_password_screen.dart';
import 'package:flutter_application_1/screens/auth/signup_screen.dart';
import 'package:flutter_application_1/screens/home/home_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';
import 'package:flutter_application_1/widgets/monex_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.initialMessage});

  final String? initialMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _didShowInitialMessage = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didShowInitialMessage) return;
        _didShowInitialMessage = true;
        _showMessage(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter both email and password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.signInWithEmail(email: email, password: password);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Failed to sign in.');
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleComingSoon(String provider) {
    _showMessage('$provider sign-in will be available soon.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final outline = colorScheme.outlineVariant;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Image.asset('lib/theme/logo.png', width: 90, height: 90),
              const SizedBox(height: 16),
              Text(
                'monex',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              MonexTextField(
                controller: _emailController,
                hintText: 'Email address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18),
              MonexTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: GradientButton(
                  label: 'LOGIN',
                  isLoading: _isLoading,
                  onTap: _handleLogin,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'FORGOT PASSWORD',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Divider(color: outline)),
                  const SizedBox(width: 12),
                  Text(
                    'Or',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Divider(color: outline)),
                ],
              ),
              const SizedBox(height: 20),
              _SocialButton(
                assetPath: 'lib/theme/flat-color-icons_google.png',
                icon: Icons.g_mobiledata,
                label: 'CONTINUE WITH GOOGLE',
                onPressed: () => _handleComingSoon('Google'),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                assetPath: 'lib/theme/ant-design_apple-filled.png',
                icon: Icons.apple,
                label: 'CONTINUE WITH APPLE',
                onPressed: () => _handleComingSoon('Apple'),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Register here',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    this.assetPath,
    this.icon,
    required this.label,
    this.onPressed,
  }) : assert(assetPath != null || icon != null);

  final String? assetPath;
  final IconData? icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final outline = colorScheme.outlineVariant;
    final surface = colorScheme.surface;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fallbackIconColor = isDark ? onSurface : Colors.black87;
    final Widget leading = assetPath != null
        ? Image.asset(
            assetPath!,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => icon != null
                ? Icon(icon, color: fallbackIconColor, size: 24)
                : Icon(
                    Icons.image_not_supported_outlined,
                    color: onSurfaceVariant,
                    size: 24,
                  ),
          )
        : Icon(
            icon ?? Icons.image_outlined,
            color: fallbackIconColor,
            size: 24,
          );

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: onSurface,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
