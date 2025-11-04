import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/transaction_record.dart';
import '../../services/transaction_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/currency_utils.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  static const List<Color> _categoryColors = [
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFF0EA5E9),
    Color(0xFFF97316),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.statsTitle)),
      body: ValueListenableBuilder<List<TransactionRecord>>(
        valueListenable: TransactionService.instance.listenable,
        builder: (context, transactions, _) {
          final double income = transactions
              .where((record) => record.isIncome)
              .fold<double>(0, (total, record) => total + record.amount);
          final double expenses = transactions
              .where((record) => !record.isIncome)
              .fold<double>(0, (total, record) => total + record.amount);
          final double savings = income - expenses;

          final summaryItems = [
            _SummaryItem(
              label: localizations.incomeLabel,
              value: formatCurrencyVND(income),
              color: const Color(0xFF22C55E),
            ),
            _SummaryItem(
              label: localizations.expensesLabel,
              value: formatCurrencyVND(expenses),
              color: const Color(0xFFEF4444),
            ),
            _SummaryItem(
              label: localizations.savingsLabel,
              value: formatCurrencyVND(savings),
              color: savings >= 0
                  ? AppColors.primaryBlue
                  : const Color(0xFFEF4444),
            ),
          ];

          final categoryStats = _buildCategoryStats(transactions, expenses);

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              _SummaryStrip(items: summaryItems),
              const SizedBox(height: 32),
              if (categoryStats.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(text: localizations.categoryBreakdown),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        localizations.transactionsEmptyState,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      title: localizations.categoryBreakdown,
                      child: _CategoryPieChart(stats: categoryStats),
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(text: localizations.categoryBreakdown),
                    const SizedBox(height: 12),
                    for (final stat in categoryStats)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _CategoryTile(stat: stat),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  static List<_CategoryBreakdown> _buildCategoryStats(
    List<TransactionRecord> transactions,
    double totalExpenses,
  ) {
    if (totalExpenses <= 0) return const [];

    final Map<String, double> totals = <String, double>{};
    for (final record in transactions) {
      if (record.isIncome) continue;
      totals.update(
        record.category,
        (value) => value + record.amount,
        ifAbsent: () => record.amount,
      );
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<_CategoryBreakdown> stats = [];
    for (var i = 0; i < entries.length; i++) {
      final color = _categoryColors[i % _categoryColors.length];
      final amount = entries[i].value;
      stats.add(
        _CategoryBreakdown(
          category: entries[i].key,
          amount: amount,
          percentage: (amount / totalExpenses) * 100,
          icon: iconForCategory(entries[i].key),
          color: color,
        ),
      );
    }

    return stats;
  }
}

String _formatPercentage(double percentage) {
  if (percentage == 0) return '0%';
  if ((percentage - percentage.round()).abs() < 0.1) {
    return '${percentage.round()}%';
  }
  return '${percentage.toStringAsFixed(1)}%';
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1C2F80ED),
            offset: Offset(0, 12),
            blurRadius: 24,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.surface.withAlpha(235),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.items});

  final List<_SummaryItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x102F80ED),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _SummaryCell(
                item: items[i],
                showDivider: i != items.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({required this.item, required this.showDivider});

  final _SummaryItem item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(right: showDivider ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: item.color,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Positioned(
            right: 0,
            top: 6,
            bottom: 6,
            child: Container(
              width: 1,
              color: theme.colorScheme.outlineVariant.withAlpha(120),
            ),
          ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.stat});

  final _CategoryBreakdown stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountText = formatCurrencyVND(stat.amount);
    final percentage = stat.percentage;
    final percentageText = _formatPercentage(percentage);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stat.color.withAlpha(36),
                ),
                child: Icon(stat.icon, color: stat.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.category,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amountText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                percentageText,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: stat.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0, 1),
              minHeight: 8,
              backgroundColor: stat.color.withAlpha(26),
              valueColor: AlwaysStoppedAnimation<Color>(stat.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPieChart extends StatefulWidget {
  const _CategoryPieChart({required this.stats});

  final List<_CategoryBreakdown> stats;

  @override
  State<_CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<_CategoryPieChart> {
  int _touchedIndex = -1;

  void _handleTouch(FlTouchEvent event, PieTouchResponse? response) {
    if (!mounted) return;
    if (!event.isInterestedForInteractions || response == null) {
      if (_touchedIndex != -1) {
        setState(() => _touchedIndex = -1);
      }
      return;
    }

    final index = response.touchedSection?.touchedSectionIndex ?? -1;
    if (index != _touchedIndex) {
      setState(() => _touchedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    final theme = Theme.of(context);
    final touched = _touchedIndex >= 0 && _touchedIndex < stats.length
        ? stats[_touchedIndex]
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;
        final baseRadius = isCompact ? 54.0 : 64.0;

        final sections = [
          for (var i = 0; i < stats.length; i++)
            PieChartSectionData(
              color: stats[i].color,
              value: stats[i].amount,
              title: i == _touchedIndex
                  ? stats[i].category
                  : stats[i].percentage >= 7
                  ? _formatPercentage(stats[i].percentage)
                  : '',
              radius: i == _touchedIndex ? baseRadius + 6 : baseRadius,
              titleStyle:
                  theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ) ??
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
            ),
        ];

        final chart = SizedBox(
          height: isCompact ? 220 : 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: isCompact ? 44 : 52,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(touchCallback: _handleTouch),
                ),
              ),
              if (touched != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      touched.category,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPercentage(touched.percentage),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );

        final legend = Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final stat in stats) _CategoryLegendEntry(stat: stat),
          ],
        );

        if (isCompact) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [chart, const SizedBox(height: 20), legend],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 3, child: chart),
            const SizedBox(width: 24),
            Expanded(flex: 4, child: legend),
          ],
        );
      },
    );
  }
}

class _CategoryLegendEntry extends StatelessWidget {
  const _CategoryLegendEntry({required this.stat});

  final _CategoryBreakdown stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: stat.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatPercentage(stat.percentage),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _SummaryItem {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;
}

class _CategoryBreakdown {
  const _CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  final String category;
  final double amount;
  final double percentage;
  final IconData icon;
  final Color color;
}
