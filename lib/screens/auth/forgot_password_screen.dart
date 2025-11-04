import 'package:flutter/material.dart';

import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';
import 'package:flutter_application_1/widgets/monex_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.forgotPasswordTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.forgotPasswordSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                MonexTextField(
                  controller: _emailController,
                  hintText: localizations.forgotPasswordEmailPlaceholder,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                MonexTextField(
                  controller: _passwordController,
                  hintText: localizations.forgotPasswordNewPasswordPlaceholder,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                MonexTextField(
                  controller: _confirmPasswordController,
                  hintText:
                      localizations.forgotPasswordConfirmPasswordPlaceholder,
                  icon: Icons.lock_reset_outlined,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: GradientButton(
                    label: localizations.forgotPasswordSetPassword,
                    isLoading: _isProcessing,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _handleResetPassword(localizations);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword(AppLocalizations localizations) async {
    if (_isProcessing) return;

    final email = _emailController.text.trim();
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.isEmpty || !emailPattern.hasMatch(email)) {
      _showSnack(localizations.forgotPasswordEmailInvalid);
      return;
    }

    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    if (newPassword.length < 6) {
      _showSnack(localizations.forgotPasswordPasswordTooShort);
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnack(localizations.forgotPasswordPasswordMismatch);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });
    _showSnack(localizations.forgotPasswordSuccess);
    Navigator.of(context).pop();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
