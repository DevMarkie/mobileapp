import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../profile/profile_store.dart';
import '../menu/home_drawer.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_info_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _nameOverride;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final fallback = 'there';
    final name =
        _nameOverride ??
        ((user?.displayName?.trim().isNotEmpty ?? false)
            ? user!.displayName!.trim()
            : fallback);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      drawerScrimColor: Colors.black.withValues(alpha: 0.30),
      drawer: HomeDrawer(name: name, email: user?.email ?? ''),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // Home dashboard content (existing)
            Stack(
              children: [
                if (_nameOverride == null &&
                    (user?.displayName == null ||
                        user!.displayName!.trim().isEmpty) &&
                    user != null)
                  FutureBuilder<Map<String, dynamic>?>(
                    future: ProfileStore.getProfile(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        final data = snapshot.data!;
                        final uname = (data['username'] ?? '')
                            .toString()
                            .trim();
                        final first = (data['firstName'] ?? '')
                            .toString()
                            .trim();
                        final last = (data['lastName'] ?? '').toString().trim();
                        final computed = uname.isNotEmpty
                            ? uname
                            : [
                                first,
                                last,
                              ].where((e) => e.isNotEmpty).join(' ').trim();
                        if (computed.isNotEmpty && mounted) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted)
                              setState(() => _nameOverride = computed);
                          });
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (ctx) => IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () => Scaffold.of(ctx).openDrawer(),
                            ),
                          ),
                          const Spacer(),
                          _Avatar(name: name),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_greeting()},',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        name.endsWith(',')
                            ? name
                            : (name.endsWith('.') ? name : '$name,'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _BalanceCard(),
                      const SizedBox(height: 18),
                      const _SecondaryCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
            // Notifications content inline
            const Padding(
              padding: EdgeInsets.only(top: 0),
              child: NotificationsBody(),
            ),
            // Wallet placeholder (keep existing style)
            const Center(
              child: Icon(
                Icons.wallet_outlined,
                size: 64,
                color: Colors.black26,
              ),
            ),
            // Profile info inline (loads data)
            const ProfileInfoTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1433FF),
        unselectedItemColor: Colors.black38,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wallet_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Stack(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF6789FF),
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              border: Border.all(color: Colors.white, width: 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final bars = const [60.0, 40.0, 80.0, 30.0, 55.0, 65.0, 90.0];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Your total balance',
                style: TextStyle(color: Colors.black54),
              ),
              Spacer(),
              Icon(Icons.more_horiz, color: Colors.black38),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '\$8000.0',
            style: TextStyle(
              color: Color(0xFF1433FF),
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: _Bar(height: bars[i].toDouble(), index: i),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.index});
  final double height;
  final int index;

  @override
  Widget build(BuildContext context) {
    final base = Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFF1433FF).withValues(alpha: 0.8),
            const Color(0xFF67B0FF).withValues(alpha: 0.8),
          ],
        ),
      ),
    );
    return Align(alignment: Alignment.bottomCenter, child: base);
  }
}

class _SecondaryCard extends StatelessWidget {
  const _SecondaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
          begin: Alignment(0.07, -0.25),
          end: Alignment(0.67, 1.99),
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    'Check your bank\naccounts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
