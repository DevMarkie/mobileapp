import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import '../profile/profile_store.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _emailError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  bool get _isValidEmail {
    final v = _emailCtrl.text.trim();
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(v);
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final pwd = _pwdCtrl.text;
    setState(() {
      _emailError = _isValidEmail ? null : 'The email address is incomplete.';
    });
    if (_emailError != null || pwd.isEmpty) return;
    setState(() => _loading = true);
    try {
      final cred = await AuthService.signInWithEmailPassword(
        email: email,
        password: pwd,
      );
      final user = cred.user;
      final uid = user?.uid;
      if (!mounted) return;
      try {
        bool complete = user?.displayName?.trim().isNotEmpty ?? false;
        if (!complete && uid != null) {
          complete = await ProfileStore.isProfileComplete(uid);
        }
        // If displayName is empty, try to set it from stored profile
        if (uid != null &&
            (user?.displayName == null || user!.displayName!.trim().isEmpty)) {
          final data = await ProfileStore.getProfile(uid);
          final uname = (data?['username'] ?? '').toString().trim();
          if (uname.isNotEmpty) {
            await user!.updateDisplayName(uname);
          }
        }
        if (!mounted) return;
        if (complete) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false);
        } else {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/profile', (route) => false);
        }
      } catch (e) {
        // If Firestore not available or rules/network errors, still allow user to complete profile
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to check profile, continue to profile: $e'),
          ),
        );
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/profile', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      final msg = e.message ?? e.code;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed: $msg')));
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
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
            // Header gradient with logo and welcome text
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
                    const Positioned(
                      left: 24,
                      bottom: 24,
                      child: Text(
                        'WELCOME\nBACK',
                        style: TextStyle(
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

            // Form
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
                    const Text(
                      'SIGN-IN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Email
                    const Text(
                      'Email address',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: '.....@gmail.com',
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

                    // Password
                    const Text(
                      'Password',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                    TextField(
                      controller: _pwdCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: '********',
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
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          color: const Color(0xFF6B7280),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        // TODO: forgot password
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF6C8CFF),
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign In button
                    _PrimaryGradientButton(
                      text: _loading ? 'Signing in...' : 'Sign In',
                      onPressed: _loading ? null : () => _submit(),
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
          gradient: LinearGradient(
            begin: const Alignment(0.07, -0.25),
            end: const Alignment(0.67, 1.99),
            colors: const [Color(0xFF4960F9), Color(0xFF1433FF)],
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
