import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/models/app_notification.dart';
import 'package:flutter_application_1/screens/settings/settings_page.dart';
import 'package:flutter_application_1/screens/stats/stats_page.dart';
import 'package:flutter_application_1/screens/transactions/add_transaction_screen.dart';
import 'package:flutter_application_1/services/notification_center.dart';
import 'package:flutter_application_1/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          localizations.alertsNav,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<AppNotification>>(
        valueListenable: NotificationCenter.instance.listenable,
        builder: (context, notifications, _) {
          if (notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  localizations.notificationsEmptyState,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = notifications[index];
              final timeAgo = _formatTimeAgo(data.timestamp, localizations);
              return _NotificationTile(
                data: data,
                timeAgo: timeAgo,
                colorScheme: colorScheme,
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 64,
        width: 64,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x552F6BFF),
                offset: Offset(0, 12),
                blurRadius: 24,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 8,
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
            child: SizedBox(
              height: kBottomNavigationBarHeight + 12,
              child: Row(
                children: [
                  Expanded(
                    child: _NotificationsNavItem(
                      icon: Icons.home_rounded,
                      label: localizations.homeNav,
                      isActive: _selectedIndex == 0,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Expanded(
                    child: _NotificationsNavItem(
                      icon: Icons.stacked_bar_chart,
                      label: localizations.statsNav,
                      isActive: _selectedIndex == 1,
                      onTap: () {
                        if (_selectedIndex == 1) return;
                        setState(() => _selectedIndex = 1);
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => const StatsPage(),
                              ),
                            )
                            .then((_) {
                              if (!mounted) return;
                              setState(() => _selectedIndex = 2);
                            });
                      },
                    ),
                  ),
                  const SizedBox(width: 56),
                  Expanded(
                    child: _NotificationsNavItem(
                      icon: Icons.notifications_rounded,
                      label: localizations.alertsNav,
                      isActive: _selectedIndex == 2,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: _NotificationsNavItem(
                      icon: Icons.settings_outlined,
                      label: localizations.settingsNav,
                      isActive: _selectedIndex == 3,
                      onTap: () {
                        if (_selectedIndex == 3) return;
                        setState(() => _selectedIndex = 3);
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            )
                            .then((_) {
                              if (!mounted) return;
                              setState(() => _selectedIndex = 2);
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.data,
    required this.timeAgo,
    required this.colorScheme,
  });

  final AppNotification data;
  final String timeAgo;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final onSurface = colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(18),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.primaryContainer.withValues(alpha: 0.18),
            ),
            child: Icon(data.icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timeAgo,
            style: TextStyle(
              fontSize: 12,
              color: onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsNavItem extends StatelessWidget {
  const _NotificationsNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color color = isActive
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTimeAgo(DateTime timestamp, AppLocalizations localizations) {
  final Duration difference = DateTime.now().difference(timestamp);
  if (difference.inMinutes < 1) return localizations.notificationsTimeJustNow;
  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    if (minutes == 1) return localizations.notificationsTimeMinute;
    return localizations.notificationsTimeMinutes.replaceFirst(
      '{count}',
      minutes.toString(),
    );
  }
  if (difference.inHours < 24) {
    final hours = difference.inHours;
    if (hours == 1) return localizations.notificationsTimeHour;
    return localizations.notificationsTimeHours.replaceFirst(
      '{count}',
      hours.toString(),
    );
  }
  final days = difference.inDays;
  if (days < 7) {
    if (days == 1) return localizations.notificationsTimeYesterday;
    return localizations.notificationsTimeDays.replaceFirst(
      '{count}',
      days.toString(),
    );
  }
  return DateFormat.yMd(localizations.locale.toLanguageTag()).format(timestamp);
}
