import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'profile_store.dart';

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
    final user = AuthService.currentUser;
    // Prefill from current user/displayName/email before async load
    if (user != null) {
      final email = user.email ?? '';
      final emailName = email.contains('@') ? email.split('@').first : email;
      String display = (user.displayName ?? '').trim();
      if (display.isEmpty) display = emailName;
      username = display;
      // Try to infer first/last name from display or email tokens
      List<String> tokens = display
          .split(RegExp(r"[\s_\.-]+"))
          .where((t) => t.trim().isNotEmpty)
          .toList();
      if (tokens.isEmpty && emailName.isNotEmpty) {
        tokens = emailName
            .split(RegExp(r"[\s_\.-]+"))
            .where((t) => t.trim().isNotEmpty)
            .toList();
      }
      String cap(String s) => s.isEmpty
          ? s
          : s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
      if (tokens.isNotEmpty && firstName.isEmpty) firstName = cap(tokens[0]);
      if (tokens.length > 1 && lastName.isEmpty) lastName = cap(tokens[1]);

      ProfileStore.getProfile(user.uid)
          .then((data) {
            if (!mounted) return;
            setState(() {
              username = (data?['username'] ?? user.displayName ?? username)
                  .toString();
              firstName = (data?['firstName'] ?? firstName).toString();
              lastName = (data?['lastName'] ?? lastName).toString();
              dob = (data?['dob'] ?? dob).toString();
            });
          })
          .catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.34;
    final email = AuthService.currentUser?.email ?? '';
    final emailName = email.contains('@') ? email.split('@').first : email;
    final displayName = username.isNotEmpty
        ? username
        : (emailName.isNotEmpty ? emailName : 'User');
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
  });

  final String displayName;
  final String initials;
  final String firstName;
  final String lastName;
  final String dob;
  final double headerHeight;
  final VoidCallback onSignOut;

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
                const Positioned(
                  left: 24,
                  top: 24,
                  child: Text(
                    'Profile',
                    style: TextStyle(
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
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFF34D399),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'online',
                                  style: TextStyle(color: Colors.white70),
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
                _InfoField(label: 'Username', value: displayName),
                _InfoField(
                  label: 'First Name',
                  value: firstName.isNotEmpty ? firstName : '—',
                ),
                _InfoField(
                  label: 'Last Name',
                  value: lastName.isNotEmpty ? lastName : '—',
                ),
                _InfoField(
                  label: 'Date of Birth',
                  value: dob.isNotEmpty ? dob : '—',
                ),
                const SizedBox(height: 24),
                _SignOutButton(onPressed: onSignOut),
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
    final user = AuthService.currentUser;
    if (user != null) {
      // Prefill from displayName/email
      final email = user.email ?? '';
      final emailName = email.contains('@') ? email.split('@').first : email;
      String display = (user.displayName ?? '').trim();
      if (display.isEmpty) display = emailName;
      username = display;
      List<String> tokens = display
          .split(RegExp(r"[\s_\.-]+"))
          .where((t) => t.trim().isNotEmpty)
          .toList();
      if (tokens.isEmpty && emailName.isNotEmpty) {
        tokens = emailName
            .split(RegExp(r"[\s_\.-]+"))
            .where((t) => t.trim().isNotEmpty)
            .toList();
      }
      String cap(String s) => s.isEmpty
          ? s
          : s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
      if (tokens.isNotEmpty && firstName.isEmpty) firstName = cap(tokens[0]);
      if (tokens.length > 1 && lastName.isEmpty) lastName = cap(tokens[1]);

      // Load from ProfileStore
      ProfileStore.getProfile(user.uid)
          .then((data) {
            if (!mounted) return;
            setState(() {
              username = (data?['username'] ?? user.displayName ?? username)
                  .toString();
              firstName = (data?['firstName'] ?? firstName).toString();
              lastName = (data?['lastName'] ?? lastName).toString();
              dob = (data?['dob'] ?? dob).toString();
            });
          })
          .catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.34;
    final email = AuthService.currentUser?.email ?? '';
    final emailName = email.contains('@') ? email.split('@').first : email;
    final displayName = username.isNotEmpty
        ? username
        : (emailName.isNotEmpty ? emailName : 'User');
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
      width: 160,
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
        child: const Text('Sign out'),
      ),
    );
  }
}
