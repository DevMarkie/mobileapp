import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/auth/login_screen.dart';
import 'package:flutter_application_1/screens/home/home_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';
import 'package:flutter_application_1/widgets/monex_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if ([
      name,
      email,
      password,
      confirmPassword,
    ].any((value) => value.isEmpty)) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters long.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await AuthService.signUpWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await UserService.ensureUserProfile(
          uid: user.uid,
          name: name,
          email: user.email ?? email,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'FirebaseAuthException during sign up: ${error.code} - ${error.message}',
      );
      final message = switch (error.code) {
        'email-already-in-use' =>
          'This email is already associated with another account.',
        'invalid-email' => 'The email address is invalid.',
        'weak-password' => 'Password must be at least 6 characters long.',
        'operation-not-allowed' =>
          'Email sign-up is disabled for this project. Enable it in Firebase Console.',
        _ => error.message ?? 'Failed to register.',
      };
      _showMessage(message);
    } on FirebaseException catch (error) {
      debugPrint(
        'FirebaseException during profile setup: ${error.code} - ${error.message}',
      );
      _showMessage(error.message ?? 'Unable to finish account setup.');
    } catch (error, stackTrace) {
      debugPrint('Unexpected error during sign up: $error\n$stackTrace');
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('lib/theme/logo.png', width: 80, height: 80),
              const SizedBox(height: 16),
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 28),
              MonexTextField(
                controller: _nameController,
                hintText: 'Full Name',
                icon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18),
              MonexTextField(
                controller: _emailController,
                hintText: 'Email Address',
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
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18),
              MonexTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: GradientButton(
                  label: 'REGISTER',
                  isLoading: _isLoading,
                  onTap: _handleRegister,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
