export 'home/home_page.dart';

/*
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/dots_indicator.dart';
import 'add_transaction_screen.dart';
import 'savings_page.dart';
import 'notifications_page.dart';
import 'reminders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _cardController;
  int _selectedIndex = 0;
  int _activeCardIndex = 1;
  int _selectedTagIndex = 0;

  static const List<_SummaryCardData> _summaryCards = [
    _SummaryCardData(
      title: 'Total Salary',
      amount: '32.000.000 ₫',
      icon: Icons.account_balance_wallet_outlined,
    ),
    _SummaryCardData(
      title: 'Total Expense',
      amount: '7.850.000 ₫',
      icon: Icons.credit_card,
      highlighted: true,
    ),
    _SummaryCardData(
      title: 'Monthly',
      amount: '3.380.000 ₫',
      icon: Icons.trending_up,
    ),
  ];

  static const List<_TagData> _tags = [
    _TagData(label: 'Savings', icon: Icons.savings_outlined),
    _TagData(label: 'Remind', icon: Icons.notifications_outlined),
    _TagData(label: 'Budget', icon: Icons.calendar_today_outlined),
    _TagData(label: 'Invest', icon: Icons.show_chart_outlined),
  ];

  static const List<_EntryData> _entries = [
    _EntryData(
      icon: Icons.fastfood_outlined,
      title: 'Food',
      date: '20 Feb 2024',
  amountLabel: '+ 120.000 ₫',
      method: 'Google Pay',
      isIncome: true,
    ),
    _EntryData(
      icon: Icons.directions_car_outlined,
      title: 'Uber',
      date: '13 Mar 2024',
  amountLabel: '- 85.000 ₫',
      method: 'Cash',
    ),
    _EntryData(
      icon: Icons.shopping_bag_outlined,
      title: 'Shopping',
      date: '11 Mar 2024',
  amountLabel: '- 2.800.000 ₫',
      method: 'Paytm',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cardController = PageController(
      viewportFraction: 0.78,
      initialPage: _activeCardIndex,
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x102F80ED),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Fri, 28 Feb 2024',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ],
                          ),
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFF7676),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 190,
                      child: PageView.builder(
                        controller: _cardController,
                        itemCount: _summaryCards.length,
                        padEnds: false,
                        onPageChanged: (index) =>
                            setState(() => _activeCardIndex = index),
                        itemBuilder: (context, index) {
                          final card = _summaryCards[index];
                          final isActive = _activeCardIndex == index;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == _summaryCards.length - 1 ? 0 : 16,
                            ),
                            child: _OverviewCard(
                              data: card,
                              isActive: isActive,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    DotsIndicator(
                      count: _summaryCards.length,
                      currentIndex: _activeCardIndex,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 46,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final tag = _tags[index];
                          final isSelected = index == _selectedTagIndex;
                          return _TagChip(
                            label: tag.label,
                            icon: tag.icon,
                            selected: isSelected,
                            onTap: () {
                              setState(() => _selectedTagIndex = index);
                              if (index == 0) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SavingsPage(),
                                  ),
                                );
                              } else if (index == 1) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RemindersPage(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: _tags.length,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Latest Entries',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < _entries.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == _entries.length - 1 ? 0 : 12,
                        ),
                        child: _LatestEntryTile(entry: _entries[i]),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
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
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavItem(
                icon: Icons.stacked_bar_chart,
                label: 'Stats',
                isActive: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              const SizedBox(width: 48),
              _NavItem(
                icon: Icons.notifications_rounded,
                label: 'Alerts',
                isActive: _selectedIndex == 2,
                onTap: () async {
                  setState(() => _selectedIndex = 2);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                  if (!mounted) return;
                  setState(() => _selectedIndex = 0);
                },
              ),
              _NavItem(
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

class _SummaryCardData {
  const _SummaryCardData({
    required this.title,
    required this.amount,
    required this.icon,
    this.highlighted = false,
  });

  final String title;
  final String amount;
  final IconData icon;
  final bool highlighted;
}

class _TagData {
  const _TagData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _EntryData {
  const _EntryData({
    required this.icon,
    required this.title,
    required this.date,
    required this.amountLabel,
    required this.method,
    this.isIncome = false,
  });

  final IconData icon;
  final String title;
  final String date;
  final String amountLabel;
  final String method;
  final bool isIncome;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
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
    final color = isActive ? AppColors.primaryBlue : Colors.grey[500];
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

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.data, required this.isActive});

  final _SummaryCardData data;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bool shouldHighlight = data.highlighted || isActive;
    final Color baseColor = shouldHighlight ? Colors.white : Colors.black87;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(
        top: isActive ? 0 : 12,
        bottom: isActive ? 12 : 24,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: shouldHighlight
            ? const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: shouldHighlight ? null : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1C2F80ED),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shouldHighlight
                  ? baseColor.withValues(alpha: 0.2)
                  : const Color(0xFFEFF2F7),
            ),
            child: Icon(
              data.icon,
              color: shouldHighlight ? Colors.white : AppColors.primaryBlue,
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 14,
              color: shouldHighlight
                  ? baseColor.withValues(alpha: 0.85)
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: baseColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [AppColors.gradientStart, AppColors.gradientEnd],
    );
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x112F80ED),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestEntryTile extends StatelessWidget {
  const _LatestEntryTile({required this.entry});

  final _EntryData entry;

  @override
  Widget build(BuildContext context) {
    final Color amountColor = entry.isIncome
        ? const Color(0xFF1ABC9C)
        : const Color(0xFFE74C3C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x102F80ED),
            blurRadius: 16,
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
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFFEFF3FB),
            ),
            child: Icon(entry.icon, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.amountLabel,
                style: TextStyle(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.method,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );

  }
}
*/
