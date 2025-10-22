import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';
import 'auth_service.dart';
import '../profile/profile_store.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;
  String? _emailError;
  String? _pwdError;

  bool get _isValidEmail {
    final v = _emailCtrl.text.trim();
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(v);
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final pwd = _pwdCtrl.text;
    final pwd2 = _pwd2Ctrl.text;
    setState(() {
      _emailError = _isValidEmail
          ? null
          : context.loc(AppStrings.signInErrorInvalidEmail);
      _pwdError = (pwd.length < 6 || pwd != pwd2)
          ? context.loc(AppStrings.signUpPasswordError)
          : null;
    });
    if (_emailError != null || _pwdError != null) return;
    setState(() => _loading = true);
    try {
      final cred = await AuthService.createUserWithEmailPassword(
        email: email,
        password: pwd,
      );
      if (!mounted) return;
      final user = cred.user;
      final uid = user?.uid;
      try {
        bool complete = user?.displayName?.trim().isNotEmpty ?? false;
        if (!complete && uid != null) {
          complete = await ProfileStore.isProfileComplete(uid);
        }
        if (!mounted) return;
        if (complete) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
        } else {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/profile', (r) => false);
        }
      } catch (e) {
        // If Firestore not available or rules/network errors, still proceed to profile completion
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.loc(
                AppStrings.signInErrorUnableProfile,
                params: {'error': e.toString()},
              ),
            ),
          ),
        );
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/profile', (r) => false);
      }
    } on FirebaseAuthException catch (e) {
      final msg = e.message ?? e.code;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.loc(AppStrings.signUpError, params: {'error': msg}),
          ),
        ),
      );
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.loc(
              AppStrings.signUpError,
              params: {'error': e.toString()},
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.36;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: SizedBox(
                height: headerH.clamp(240.0, 360.0),
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
                    Positioned(
                      right: -80,
                      top: -40,
                      child: _softCircle(170, 0.22),
                    ),
                    Positioned(
                      right: -120,
                      bottom: -90,
                      child: _softCircle(300, 0.18),
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
                    Positioned(
                      left: 24,
                      bottom: 24,
                      child: Text(
                        context.loc(AppStrings.signInWelcome),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      context.loc(AppStrings.signUpTitle),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      context.loc(AppStrings.authEmailLabel),
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: context.loc(AppStrings.authEmailHint),
                        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFB8C2FF),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6C8CFF),
                            width: 1.6,
                          ),
                        ),
                        errorText: _emailError,
                        suffixIcon: _isValidEmail
                            ? const Icon(Icons.check, color: Color(0xFF6C8CFF))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.loc(AppStrings.authPasswordLabel),
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: _pwdCtrl,
                      obscureText: _obscure1,
                      decoration: InputDecoration(
                        hintText: context.loc(AppStrings.authPasswordHint),
                        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFB8C2FF),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6C8CFF),
                            width: 1.6,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure1 ? Icons.visibility_off : Icons.visibility,
                          ),
                          color: const Color(0xFF6B7280),
                          onPressed: () =>
                              setState(() => _obscure1 = !_obscure1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.loc(AppStrings.signUpPasswordConfirm),
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: _pwd2Ctrl,
                      obscureText: _obscure2,
                      decoration: InputDecoration(
                        hintText: context.loc(
                          AppStrings.signUpPasswordConfirmHint,
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFB8C2FF),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6C8CFF),
                            width: 1.6,
                          ),
                        ),
                        errorText: _pwdError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure2 ? Icons.visibility_off : Icons.visibility,
                          ),
                          color: const Color(0xFF6B7280),
                          onPressed: () =>
                              setState(() => _obscure2 = !_obscure2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _PrimaryGradientButton(
                      text: _loading
                          ? context.loc(AppStrings.signUpLoading)
                          : context.loc(AppStrings.signUpButton),
                      onPressed: _loading ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softCircle(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      shape: BoxShape.circle,
    ),
  );
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({required this.text, required this.onPressed});
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const radius = 28.0;
    return Center(
      child: Container(
        width: 315,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(
            begin: Alignment(0.07, -0.25),
            end: Alignment(0.67, 1.99),
            colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onPressed,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                ),
                const Positioned(
                  right: 20,
                  child: Icon(Icons.arrow_right_alt, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
