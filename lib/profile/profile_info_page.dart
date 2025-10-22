import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';
import 'profile_store.dart';

List<String> _splitNameTokens(String source) {
  return source
      .split(RegExp(r"[\s_\.-]+"))
      .where((segment) => segment.trim().isNotEmpty)
      .toList();
}

String _capitalizeToken(String value) {
  if (value.isEmpty) return value;
  return value.substring(0, 1).toUpperCase() + value.substring(1).toLowerCase();
}

String _normalizeField(dynamic value) {
  final raw = (value ?? '').toString().trim();
  if (raw.toLowerCase() == 'null') return '';
  return raw;
}

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  String username = '';
  String firstName = '';
  String lastName = '';
  String dob = '';

  @override
  void initState() {
    super.initState();
    _prefillFromAuthUser();
    _loadProfileFromStore();
  }

  void _prefillFromAuthUser() {
    final user = AuthService.currentUser;
    if (user == null) return;
    final email = user.email ?? '';
    final emailName = email.contains('@') ? email.split('@').first : email;
    String display = (user.displayName ?? '').trim();
    if (display.isEmpty) display = emailName;
    username = display.isNotEmpty ? display : emailName;

    var tokens = _splitNameTokens(display);
    if (tokens.isEmpty && emailName.isNotEmpty) {
      tokens = _splitNameTokens(emailName);
    }
    if (tokens.isNotEmpty && firstName.isEmpty) {
      firstName = _capitalizeToken(tokens[0]);
    }
    if (tokens.length > 1 && lastName.isEmpty) {
      lastName = _capitalizeToken(tokens[1]);
    }
  }

  Future<void> _loadProfileFromStore() async {
    final user = AuthService.currentUser;
    if (user == null) return;
    try {
      final data = await ProfileStore.getProfile(user.uid);
      if (!mounted || data == null) return;
      setState(() {
        final fetchedUsername = _normalizeField(data['username']);
        final fetchedFirst = _normalizeField(data['firstName']);
        final fetchedLast = _normalizeField(data['lastName']);
        final fetchedDob = _normalizeField(data['dob']);

        if (fetchedUsername.isNotEmpty) {
          username = fetchedUsername;
        }
        if (fetchedFirst.isNotEmpty) {
          firstName = fetchedFirst;
        }
        if (fetchedLast.isNotEmpty) {
          lastName = fetchedLast;
        }
        if (fetchedDob.isNotEmpty) {
          dob = fetchedDob;
        }
      });
    } catch (_) {
      // Ignore cache or network issues and keep existing state.
    }
  }

  void _handleEditProfile() {
    Navigator.of(context)
        .pushNamed('/profile')
        .then((updated) async {
          if (updated == true) {
            _prefillFromAuthUser();
            if (mounted) setState(() {});
            await _loadProfileFromStore();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.loc(AppStrings.profileSaved))),
            );
          }
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.34;
    final email = AuthService.currentUser?.email ?? '';
    final emailName = email.contains('@') ? email.split('@').first : email;
    final fallbackName = context.loc(AppStrings.profileInfoPlaceholderUser);
    final displayName = username.isNotEmpty
        ? username
        : (emailName.isNotEmpty ? emailName : fallbackName);
    final initials = displayName.trim().split(RegExp(r"\s+|@")).first;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ProfileInfoBody(
          displayName: displayName,
          initials: initials,
          firstName: firstName,
          lastName: lastName,
          dob: dob,
          headerHeight: headerH,
          onSignOut: () async {
            final navigator = Navigator.of(context);
            await AuthService.signOut();
            if (!mounted) return;
            navigator.pushNamedAndRemoveUntil('/welcome', (r) => false);
          },
          onEditProfile: _handleEditProfile,
          onBack: () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}

class ProfileInfoBody extends StatelessWidget {
  const ProfileInfoBody({
    super.key,
    required this.displayName,
    required this.initials,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.headerHeight,
    required this.onSignOut,
    required this.onEditProfile,
    this.onBack,
  });

  final String displayName;
  final String initials;
  final String firstName;
  final String lastName;
  final String dob;
  final double headerHeight;
  final VoidCallback onSignOut;
  final VoidCallback onEditProfile;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient header with rounded bottom and decorative shape
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Container(
            height: headerHeight.clamp(220.0, 360.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB027F5), Color(0xFF1E78FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                if (onBack != null)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: onBack,
                    ),
                  ),
                Positioned(
                  left: 24,
                  top: 24,
                  child: Text(
                    context.loc(AppStrings.profileInfoTitle),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: const Color(0xFF6789FF),
                          child: Text(
                            initials.isNotEmpty
                                ? initials[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFF34D399),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  context.loc(
                                    AppStrings.profileInfoStatusOnline,
                                  ),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Info fields
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoField(
                  label: context.loc(AppStrings.profileUsernameLabel),
                  value: displayName,
                ),
                _InfoField(
                  label: context.loc(AppStrings.profileFirstNameLabel),
                  value: firstName.isNotEmpty ? firstName : '—',
                ),
                _InfoField(
                  label: context.loc(AppStrings.profileLastNameLabel),
                  value: lastName.isNotEmpty ? lastName : '—',
                ),
                _InfoField(
                  label: context.loc(AppStrings.profileDobLabel),
                  value: dob.isNotEmpty ? dob : '—',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _EditProfileButton(onPressed: onEditProfile),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _SignOutButton(onPressed: onSignOut)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Inline tab version that loads the profile and renders ProfileInfoBody
class ProfileInfoTab extends StatefulWidget {
  const ProfileInfoTab({super.key});

  @override
  State<ProfileInfoTab> createState() => _ProfileInfoTabState();
}

class _ProfileInfoTabState extends State<ProfileInfoTab> {
  String username = '';
  String firstName = '';
  String lastName = '';
  String dob = '';

  @override
  void initState() {
    super.initState();
    _prefillFromAuthUser();
    _loadProfileFromStore();
  }

  void _prefillFromAuthUser() {
    final user = AuthService.currentUser;
    if (user == null) return;
    final email = user.email ?? '';
    final emailName = email.contains('@') ? email.split('@').first : email;
    String display = (user.displayName ?? '').trim();
    if (display.isEmpty) display = emailName;
    username = display.isNotEmpty ? display : emailName;

    var tokens = _splitNameTokens(display);
    if (tokens.isEmpty && emailName.isNotEmpty) {
      tokens = _splitNameTokens(emailName);
    }
    if (tokens.isNotEmpty && firstName.isEmpty) {
      firstName = _capitalizeToken(tokens[0]);
    }
    if (tokens.length > 1 && lastName.isEmpty) {
      lastName = _capitalizeToken(tokens[1]);
    }
  }

  Future<void> _loadProfileFromStore() async {
    final user = AuthService.currentUser;
    if (user == null) return;
    try {
      final data = await ProfileStore.getProfile(user.uid);
      if (!mounted || data == null) return;
      setState(() {
        final fetchedUsername = _normalizeField(data['username']);
        final fetchedFirst = _normalizeField(data['firstName']);
        final fetchedLast = _normalizeField(data['lastName']);
        final fetchedDob = _normalizeField(data['dob']);

        if (fetchedUsername.isNotEmpty) {
          username = fetchedUsername;
        }
        if (fetchedFirst.isNotEmpty) {
          firstName = fetchedFirst;
        }
        if (fetchedLast.isNotEmpty) {
          lastName = fetchedLast;
        }
        if (fetchedDob.isNotEmpty) {
          dob = fetchedDob;
        }
      });
    } catch (_) {
      // Ignore cache or network errors to keep existing UI data.
    }
  }

  void _handleEditProfile() {
    Navigator.of(context)
        .pushNamed('/profile')
        .then((updated) async {
          if (updated == true) {
            _prefillFromAuthUser();
            if (mounted) setState(() {});
            await _loadProfileFromStore();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.loc(AppStrings.profileSaved))),
            );
          }
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.34;
    final email = AuthService.currentUser?.email ?? '';
    final emailName = email.contains('@') ? email.split('@').first : email;
    final fallbackName = context.loc(AppStrings.profileInfoPlaceholderUser);
    final displayName = username.isNotEmpty
        ? username
        : (emailName.isNotEmpty ? emailName : fallbackName);
    final initials = displayName.trim().isNotEmpty
        ? displayName.trim()[0].toUpperCase()
        : '?';

    return ProfileInfoBody(
      displayName: displayName,
      initials: initials,
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      headerHeight: headerH,
      onSignOut: () async {
        final navigator = Navigator.of(context);
        await AuthService.signOut();
        if (!mounted) return;
        navigator.pushNamedAndRemoveUntil('/welcome', (r) => false);
      },
      onEditProfile: _handleEditProfile,
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0B2AA3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFB8C2FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: const Color(0xFF0B2AA3),
        ),
        child: Text(context.loc(AppStrings.drawerSignOut)),
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B2AA3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(context.loc(AppStrings.profileInfoEditProfile)),
      ),
    );
  }
}
