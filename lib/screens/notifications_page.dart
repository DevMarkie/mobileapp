import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'add_transaction_screen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static final List<_NotificationData> _notifications = [
    _NotificationData(
      icon: Icons.fastfood_outlined,
      title: 'Food',
      message: 'Receipt paid your food',
      timeAgo: 'Just now',
    ),
    _NotificationData(
      icon: Icons.notifications_active_outlined,
      title: 'Reminder',
      message: 'Receipt just sent reminder for you',
      timeAgo: '20 mins ago',
    ),
    _NotificationData(
      icon: Icons.savings_outlined,
      title: 'Goal Achieved',
      message: 'You achieved your savings goal',
      timeAgo: '45 mins ago',
    ),
    _NotificationData(
      icon: Icons.notifications_active_outlined,
      title: 'Reminder',
      message: 'Receipt just sent reminder for you',
      timeAgo: '1 hour ago',
    ),
    _NotificationData(
      icon: Icons.fastfood_outlined,
      title: 'Food',
      message: 'Receipt paid your food',
      timeAgo: '3 hours ago',
    ),
    _NotificationData(
      icon: Icons.receipt_long_outlined,
      title: 'Bill',
      message: 'Receipt paid your fusion bill',
      timeAgo: '5 hours ago',
    ),
    _NotificationData(
      icon: Icons.directions_car_outlined,
      title: 'Uber',
      message: 'Receipt paid your uber',
      timeAgo: '6 hours ago',
    ),
    _NotificationData(
      icon: Icons.airplane_ticket_outlined,
      title: 'Ticket',
      message: 'Receipt paid your ticket',
      timeAgo: '8 hours ago',
    ),
  ];

  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemBuilder: (context, index) {
          final data = _notifications[index];
          return _NotificationTile(data: data);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: _notifications.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 68,
        width: 68,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [
              BoxShadow(
                color: Color(0x552F6BFF),
                offset: Offset(0, 12),
                blurRadius: 24,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 8,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NotificationsNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: _selectedIndex == 0,
                onTap: () => Navigator.of(context).pop(),
              ),
              _NotificationsNavItem(
                icon: Icons.savings_rounded,
                label: 'Savings',
                isActive: _selectedIndex == 1,
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 48),
              _NotificationsNavItem(
                icon: Icons.notifications_rounded,
                label: 'Alerts',
                isActive: _selectedIndex == 2,
                onTap: () {},
              ),
              _NotificationsNavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.data});

  final _NotificationData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2F80ED),
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
              color: const Color(0xFFEFF2F7),
            ),
            child: Icon(data.icon, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.message,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            data.timeAgo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  const _NotificationData({
    required this.icon,
    required this.title,
    required this.message,
    required this.timeAgo,
  });

  final IconData icon;
  final String title;
  final String message;
  final String timeAgo;
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
    final Color color = isActive ? AppColors.primaryBlue : Colors.grey[500]!;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
