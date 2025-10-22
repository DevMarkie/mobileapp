import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';
import 'profile_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameCtrl = TextEditingController();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  bool _saving = false;

  bool get _validUsername => _usernameCtrl.text.trim().isNotEmpty;
  bool get _validFirst => _firstCtrl.text.trim().isNotEmpty;
  bool get _validLast => _lastCtrl.text.trim().isNotEmpty;
  bool get _validDob => _dobCtrl.text.trim().isNotEmpty; // Simplified
  bool get _formValid =>
      _validUsername && _validFirst && _validLast && _validDob;

  @override
  void initState() {
    super.initState();
    // Prefill if existing profile
    final user = AuthService.currentUser;
    if (user != null) {
      ProfileStore.getProfile(user.uid)
          .then((data) {
            if (!mounted || data == null) return;
            _usernameCtrl.text = (data['username'] ?? '').toString();
            _firstCtrl.text = (data['firstName'] ?? '').toString();
            _lastCtrl.text = (data['lastName'] ?? '').toString();
            _dobCtrl.text = (data['dob'] ?? '').toString();
            setState(() {});
          })
          .catchError((_) {});
    }
  }

  Future<void> _complete() async {
    if (!_formValid) return;
    setState(() => _saving = true);
    try {
      final user = AuthService.currentUser;
      if (user != null) {
        await user.updateDisplayName(_usernameCtrl.text.trim());
        try {
          await ProfileStore.saveProfile(
            uid: user.uid,
            username: _usernameCtrl.text.trim(),
            firstName: _firstCtrl.text.trim(),
            lastName: _lastCtrl.text.trim(),
            dob: _dobCtrl.text.trim(),
          );
          // Ensure displayName is set for next launches
          if ((user.displayName ?? '').trim().isEmpty) {
            await user.updateDisplayName(_usernameCtrl.text.trim());
          }
        } catch (e) {
          // ProfileStore already caches locally on failure, just show info
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.loc(
                    AppStrings.profileSaveLocalFallback,
                    params: {'error': e.toString()},
                  ),
                ),
              ),
            );
          }
        }
      }
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc(AppStrings.profileSaved))),
        );
        navigator.pushNamedAndRemoveUntil('/home', (r) => false);
      }
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.loc(
              AppStrings.profileSaveFailed,
              params: {'error': e.toString()},
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.36;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB027F5), Color(0xFF1E78FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient and rounded bottom
              Container(
                height: headerH.clamp(240.0, 360.0),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      top: 8,
                      child: IconButton(
                        onPressed: () {
                          final navigator = Navigator.of(context);
                          if (navigator.canPop()) {
                            navigator.pop();
                          } else {
                            navigator.pushNamedAndRemoveUntil(
                              '/home',
                              (route) => false,
                            );
                          }
                        },
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.loc(AppStrings.profileHeaderTitle),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              context.loc(AppStrings.profileHeaderSubtitle),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                      _LabeledField(
                        label: context.loc(AppStrings.profileUsernameLabel),
                        hint: context.loc(AppStrings.profileUsernameHint),
                        controller: _usernameCtrl,
                        valid: _validUsername,
                        onChanged: (_) => setState(() {}),
                      ),
                      _LabeledField(
                        label: context.loc(AppStrings.profileFirstNameLabel),
                        hint: context.loc(AppStrings.profileFirstNameHint),
                        controller: _firstCtrl,
                        valid: _validFirst,
                        onChanged: (_) => setState(() {}),
                      ),
                      _LabeledField(
                        label: context.loc(AppStrings.profileLastNameLabel),
                        hint: context.loc(AppStrings.profileLastNameHint),
                        controller: _lastCtrl,
                        valid: _validLast,
                        onChanged: (_) => setState(() {}),
                      ),
                      _LabeledField(
                        label: context.loc(AppStrings.profileDobLabel),
                        hint: context.loc(AppStrings.profileDobHint),
                        controller: _dobCtrl,
                        valid: _validDob,
                        onChanged: (_) => setState(() {}),
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 28),
                      _CompleteButton(
                        enabled: _formValid && !_saving,
                        onPressed: _formValid && !_saving ? _complete : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.valid,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool valid;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Stack(
            children: [
              TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        controller.text.isEmpty ? hint : '',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
              if (valid)
                const Positioned(
                  right: 0,
                  top: 8,
                  child: Icon(Icons.check, color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.enabled, required this.onPressed});
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const radius = 28.0;
    return Center(
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: SizedBox(
          width: 315,
          height: 72,
          child: DecoratedBox(
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
                onTap: enabled ? onPressed : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      context.loc(AppStrings.profileCompleteButton),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const Positioned(
                      right: 20,
                      child: Icon(Icons.check_box, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
