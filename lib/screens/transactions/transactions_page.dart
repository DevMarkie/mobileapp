import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/transaction_record.dart';
import '../../services/transaction_service.dart';
import '../../widgets/transaction_card.dart';
import 'add_transaction_screen.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({
    super.key,
    this.filterType,
    this.customTitle,
    this.customSubtitle,
  });

  final TransactionType? filterType;
  final String? customTitle;
  final String? customSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final transactionService = TransactionService.instance;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          customTitle ?? localizations.transactionsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionService.listenable,
        builder: (context, transactions, _) {
          final records = filterType == null
              ? transactions
              : transactions
                    .where((record) => record.type == filterType)
                    .toList();

          if (records.isEmpty) {
            return _EmptyState(localizations: localizations);
          }

          final grouped = _groupedByMonth(records, localizations.locale);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Text(
                customSubtitle ?? _subtitleForFilter(localizations, filterType),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              for (final entry in grouped.entries)
                _MonthSection(
                  monthLabel: _capitalize(entry.key, localizations.locale),
                  transactions: entry.value,
                  localizations: localizations,
                ),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _capitalize(String value, Locale locale) {
    if (value.isEmpty) return value;
    if (locale.languageCode == 'vi') {
      return value[0].toUpperCase() + value.substring(1);
    }
    return toBeginningOfSentenceCase(value) ?? value;
  }

  Map<String, List<TransactionRecord>> _groupedByMonth(
    List<TransactionRecord> records,
    Locale locale,
  ) {
    final DateFormat formatter = DateFormat.yMMMM(locale.toLanguageTag());
    final Map<String, List<TransactionRecord>> grouped = {};
    for (final record in records) {
      final String key = formatter.format(record.date);
      grouped.putIfAbsent(key, () => []).add(record);
    }

    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        final DateTime parsedA = formatter.parse(a.key);
        final DateTime parsedB = formatter.parse(b.key);
        return parsedB.compareTo(parsedA);
      });

    return LinkedHashMap<String, List<TransactionRecord>>.fromEntries(
      sortedEntries,
    );
  }

  String _subtitleForFilter(
    AppLocalizations localizations,
    TransactionType? filter,
  ) {
    if (filter == null) {
      return localizations.transactionsSubtitle;
    }
    final suffix = filter == TransactionType.income
        ? localizations.incomeLabel
        : localizations.expensesLabel;
    return '${localizations.transactionsSubtitle} • $suffix';
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({
    required this.monthLabel,
    required this.transactions,
    required this.localizations,
  });

  final String monthLabel;
  final List<TransactionRecord> transactions;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final locale = localizations.locale;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthLabel,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          for (final record in transactions)
            TransactionCard(
              record: record,
              locale: locale,
              onEdit: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(localizations.transactionsEditComingSoon),
                    ),
                  );
              },
              onDelete: () => _confirmDelete(context, record),
              editLabel: localizations.transactionsEditAction,
              deleteLabel: localizations.transactionsDeleteAction,
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TransactionRecord record,
  ) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(localizations.transactionsDeleteConfirmTitle),
            content: Text(localizations.transactionsDeleteConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(localizations.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                ),
                child: Text(localizations.transactionsDeleteConfirmAccept),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    TransactionService.instance.removeTransaction(record.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(localizations.transactionsDeletedMessage)),
        );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.transactionsEmptyState,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
