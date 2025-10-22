import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Drawer(
        // Baseline 390px design -> ~265px drawer (~0.68 of width)
        // Clamp to keep comfortable range on various devices
        width: (MediaQuery.of(context).size.width * 0.68)
            .clamp(240.0, 320.0)
            .toDouble(),
        child: SafeArea(
          child: Column(
            children: [
              // Header (avatar, name, handle)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF6789FF),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF3A3A3A),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            email.isNotEmpty
                                ? '@${email.split('@').first}'
                                : '',
                            style: const TextStyle(
                              color: Color(0xFF3A3A3A),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _MenuItem(
                      icon: Icons.payments_outlined,
                      textKey: AppStrings.drawerPayments,
                    ),
                    _MenuItem(
                      icon: Icons.notifications_none,
                      textKey: AppStrings.drawerNotifications,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/notifications');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.swap_horiz,
                      textKey: AppStrings.drawerTransactions,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/transactions');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.credit_card,
                      textKey: AppStrings.drawerMyCards,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/cards');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.local_offer_outlined,
                      textKey: AppStrings.drawerPromotions,
                    ),
                    _MenuItem(
                      icon: Icons.savings_outlined,
                      textKey: AppStrings.drawerSavings,
                    ),
                    _MenuItem(
                      icon: Icons.person_outline,
                      textKey: AppStrings.drawerProfileInfo,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/profileInfo');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      textKey: AppStrings.drawerSettings,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/settings');
                      },
                    ),
                  ],
                ),
              ),

              // Sign out button (226 x 72, border radius 28, primary color text)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 226,
                    height: 72,
                    child: OutlinedButton(
                      onPressed: () async {
                        await AuthService.signOut();
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/welcome', (r) => false);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: const Color(0xFF1433FF),
                        side: const BorderSide(
                          color: Color(0xFF5264F9),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: Text(context.loc(AppStrings.drawerSignOut)),
                    ),
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

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.textKey, this.onTap});
  final IconData icon;
  final String textKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2F56F8)),
      title: Text(
        context.loc(textKey),
        style: const TextStyle(
          color: Color(0xFF2F56F8),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF2F56F8)),
      onTap:
          onTap ??
          () {
            Navigator.of(context).pop();
            // TODO: Navigate to specific pages when available
          },
    );
  }
}
