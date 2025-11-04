import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/models/transaction_record.dart';
import 'package:flutter_application_1/screens/cards/card_management_page.dart';
import 'package:flutter_application_1/screens/notifications/notifications_page.dart';
import 'package:flutter_application_1/screens/profile/profile_page.dart';
import 'package:flutter_application_1/screens/savings/savings_page.dart';
import 'package:flutter_application_1/screens/settings/settings_page.dart';
import 'package:flutter_application_1/screens/stats/stats_page.dart';
import 'package:flutter_application_1/screens/transactions/add_transaction_screen.dart';
import 'package:flutter_application_1/screens/transactions/transactions_page.dart';
import 'package:flutter_application_1/services/transaction_service.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/widgets/dots_indicator.dart';
import 'package:flutter_application_1/utils/currency_utils.dart';
import 'package:intl/intl.dart';

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

  static const List<_TagData> _tags = [
    _TagData(
      type: _TagType.stats,
      icon: Icons.bar_chart_rounded,
      label: 'Stats',
    ),
    _TagData(
      type: _TagType.savings,
      icon: Icons.savings_outlined,
      label: 'Savings',
    ),
    _TagData(
      type: _TagType.notifications,
      icon: Icons.notifications_outlined,
      label: 'Remind',
    ),
    _TagData(type: _TagType.cards, icon: Icons.credit_card, label: 'Cards'),
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
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
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
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withAlpha(24),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
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
                          localizations.overview,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          localizations.homeDateLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: Stack(
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
                    ValueListenableBuilder<List<TransactionRecord>>(
                      valueListenable: TransactionService.instance.listenable,
                      builder: (context, transactions, _) {
                        final double income = transactions
                            .where((record) => record.isIncome)
                            .fold<double>(
                              0,
                              (total, record) => total + record.amount,
                            );
                        final double expenses = transactions
                            .where((record) => !record.isIncome)
                            .fold<double>(
                              0,
                              (total, record) => total + record.amount,
                            );
                        final double savings = income - expenses;

                        final summaryCards = <_SummaryCardData>[
                          _SummaryCardData(
                            category: _SummaryCategory.income,
                            title: localizations.summarySalaryTitle,
                            amount: formatCurrencyVND(income),
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                          _SummaryCardData(
                            category: _SummaryCategory.expense,
                            title: localizations.summaryExpenseTitle,
                            amount: formatCurrencyVND(expenses),
                            icon: Icons.credit_card,
                            highlighted: true,
                          ),
                          _SummaryCardData(
                            category: _SummaryCategory.monthly,
                            title: localizations.summaryMonthlyTitle,
                            amount: formatCurrencyVND(savings),
                            icon: Icons.trending_up,
                          ),
                        ];

                        return Column(
                          children: [
                            SizedBox(
                              height: 190,
                              child: PageView.builder(
                                controller: _cardController,
                                itemCount: summaryCards.length,
                                padEnds: false,
                                onPageChanged: (index) =>
                                    setState(() => _activeCardIndex = index),
                                itemBuilder: (context, index) {
                                  final card = summaryCards[index];
                                  final isActive = _activeCardIndex == index;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index == summaryCards.length - 1
                                          ? 0
                                          : 16,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => _handleSummaryCardTap(
                                        card,
                                        localizations,
                                      ),
                                      child: _OverviewCard(
                                        data: card,
                                        isActive: isActive,
                                        colorScheme: colorScheme,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            DotsIndicator(
                              count: summaryCards.length,
                              currentIndex: _activeCardIndex,
                            ),
                            const SizedBox(height: 28),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 46,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final tag = _tags[index];
                          final isSelected = index == _selectedTagIndex;
                          final label = tag.localizedLabel(localizations);
                          return _TagChip(
                            label: label,
                            icon: tag.icon,
                            selected: isSelected,
                            onTap: () {
                              setState(() => _selectedTagIndex = index);
                              switch (tag.type) {
                                case _TagType.stats:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const StatsPage(),
                                    ),
                                  );
                                  break;
                                case _TagType.savings:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SavingsPage(),
                                    ),
                                  );
                                  break;
                                case _TagType.notifications:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const NotificationsPage(),
                                    ),
                                  );
                                  break;
                                case _TagType.cards:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CardManagementPage(),
                                    ),
                                  );
                                  break;
                              }
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: _tags.length,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            localizations.latestEntries,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TransactionsPage(),
                              ),
                            );
                          },
                          child: Text(localizations.viewAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<List<TransactionRecord>>(
                      valueListenable: TransactionService.instance.listenable,
                      builder: (context, transactions, _) {
                        final latest = transactions.take(3).toList();
                        if (latest.isEmpty) {
                          return Text(
                            localizations.transactionsEmptyState,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        }
                        return Column(
                          children: [
                            for (var i = 0; i < latest.length; i++)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: i == latest.length - 1 ? 0 : 12,
                                ),
                                child: _LatestEntryTile(
                                  record: latest[i],
                                  locale: localizations.locale,
                                ),
                              ),
                          ],
                        );
                      },
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
                    child: _NavItem(
                      icon: Icons.home_rounded,
                      label: localizations.homeNav,
                      isActive: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.stacked_bar_chart,
                      label: localizations.statsNav,
                      isActive: _selectedIndex == 1,
                      onTap: () async {
                        setState(() => _selectedIndex = 1);
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const StatsPage()),
                        );
                        if (!mounted) return;
                        setState(() => _selectedIndex = 0);
                      },
                    ),
                  ),
                  const SizedBox(width: 56),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.notifications_rounded,
                      label: localizations.alertsNav,
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
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.settings_outlined,
                      label: localizations.settingsNav,
                      isActive: _selectedIndex == 3,
                      onTap: () async {
                        setState(() => _selectedIndex = 3);
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                        if (!mounted) return;
                        setState(() => _selectedIndex = 0);
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

  Future<void> _handleSummaryCardTap(
    _SummaryCardData card,
    AppLocalizations localizations,
  ) async {
    switch (card.category) {
      case _SummaryCategory.income:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TransactionsPage(
              filterType: TransactionType.income,
              customTitle: localizations.summarySalaryTitle,
              customSubtitle:
                  '${localizations.transactionsSubtitle} • ${localizations.incomeLabel}',
            ),
          ),
        );
        break;
      case _SummaryCategory.expense:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TransactionsPage(
              filterType: TransactionType.expense,
              customTitle: localizations.summaryExpenseTitle,
              customSubtitle:
                  '${localizations.transactionsSubtitle} • ${localizations.expensesLabel}',
            ),
          ),
        );
        break;
      case _SummaryCategory.monthly:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const StatsPage()));
        break;
    }
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.category,
    required this.title,
    required this.amount,
    required this.icon,
    this.highlighted = false,
  });

  final _SummaryCategory category;
  final String title;
  final String amount;
  final IconData icon;
  final bool highlighted;
}

class _TagData {
  const _TagData({required this.type, required this.icon, required this.label});

  final _TagType type;
  final IconData icon;
  final String label;

  String localizedLabel(AppLocalizations localizations) {
    switch (type) {
      case _TagType.stats:
        return localizations.statsTag;
      case _TagType.savings:
        return localizations.savingsTag;
      case _TagType.notifications:
        return localizations.notificationsTag;
      case _TagType.cards:
        return localizations.cardTag;
    }
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.data,
    required this.isActive,
    required this.colorScheme,
  });

  final _SummaryCardData data;
  final bool isActive;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final bool shouldHighlight = data.highlighted || isActive;
    final Color surface = colorScheme.surfaceContainerHighest;
    final Color outline = colorScheme.outlineVariant;
    final Color onSurface = colorScheme.onSurface;
    final Color onSurfaceVariant = colorScheme.onSurfaceVariant;
    final Color primary = colorScheme.primary;
    final Color baseTextColor = shouldHighlight ? Colors.white : onSurface;
    final Color iconBackground = shouldHighlight
        ? Colors.white.withOpacity(0.3)
        : primary.withOpacity(
            colorScheme.brightness == Brightness.dark ? 0.22 : 0.12,
          );

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
        color: shouldHighlight ? null : surface,
        border: shouldHighlight
            ? null
            : Border.all(color: outline.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(30),
            blurRadius: 24,
            offset: const Offset(0, 12),
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
              color: iconBackground,
            ),
            child: Icon(
              data.icon,
              color: shouldHighlight ? Colors.white : primary,
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 14,
              color: shouldHighlight
                  ? Colors.white.withOpacity(0.8)
                  : onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: baseTextColor,
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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 6),
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
                color: selected ? Colors.white : colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : colorScheme.primary,
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
    final colorScheme = Theme.of(context).colorScheme;
    final Color activeColor = colorScheme.primary;
    final Color inactiveColor = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? activeColor : inactiveColor, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? activeColor : inactiveColor,
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

class _LatestEntryTile extends StatelessWidget {
  const _LatestEntryTile({required this.record, required this.locale});

  final TransactionRecord record;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color amountColor = record.isIncome
        ? const Color(0xFF1ABC9C)
        : const Color(0xFFE74C3C);
    final String amountLabel = TransactionService.instance.formatAmount(
      record,
      locale,
    );
    final String subtitle = record.note?.isNotEmpty == true
        ? record.note!
        : record.category;
    final IconData icon =
        record.icon ??
        iconForCategory(
          record.category.isNotEmpty ? record.category : record.title,
        );
    final DateFormat formatter = DateFormat(
      'dd/MM/yyyy',
      locale.toLanguageTag(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 10),
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
              color: colorScheme.primary.withAlpha(32),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountLabel,
                style: TextStyle(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatter.format(record.date),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _TagType { stats, savings, notifications, cards }

enum _SummaryCategory { income, expense, monthly }
