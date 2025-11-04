import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/models/transaction_record.dart';
import 'package:flutter_application_1/services/notification_center.dart';
import 'package:flutter_application_1/services/transaction_service.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';
import 'package:flutter_application_1/widgets/transaction_card.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final transactionService = TransactionService.instance;
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
        title: Text(
          localizations.transactionsAddHeader,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: localizations.transactionsAddIncomeTitle,
                    subtitle: localizations.transactionsAddIncomeSubtitle,
                    icon: Icons.call_made_rounded,
                    onTap: () async {
                      final result = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => TransactionFormScreen(
                            title: localizations.transactionsAddIncomeTitle,
                            buttonLabel:
                                localizations.transactionsFormAddIncomeCta,
                            categories:
                                localizations.transactionsIncomeCategories,
                            isIncome: true,
                          ),
                        ),
                      );
                      if (!context.mounted) return;
                      if (result != null && result.isNotEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result)));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionCard(
                    title: localizations.transactionsAddExpenseTitle,
                    subtitle: localizations.transactionsAddExpenseSubtitle,
                    icon: Icons.call_received_rounded,
                    highlight: true,
                    onTap: () async {
                      final result = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => TransactionFormScreen(
                            title: localizations.transactionsAddExpenseTitle,
                            buttonLabel:
                                localizations.transactionsFormAddExpenseCta,
                            categories:
                                localizations.transactionsExpenseCategories,
                            isIncome: false,
                          ),
                        ),
                      );
                      if (!context.mounted) return;
                      if (result != null && result.isNotEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result)));
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              localizations.latestEntries,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<List<TransactionRecord>>(
              valueListenable: transactionService.listenable,
              builder: (context, transactions, _) {
                final recent = transactions.take(4).toList();
                if (recent.isEmpty) {
                  return Text(
                    localizations.transactionsEmptyState,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final record in recent)
                      TransactionCard(
                        record: record,
                        locale: localizations.locale,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color textColor = highlight ? Colors.white : Colors.black87;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: highlight
              ? const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: highlight ? null : Colors.white,
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
                color: highlight
                    ? Colors.white.withAlpha(51)
                    : const Color(0xFFEFF2F7),
              ),
              child: Icon(
                icon,
                color: highlight ? Colors.white : AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: textColor.withAlpha(179)),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.categories,
    required this.isIncome,
  });

  final String title;
  final String buttonLabel;
  final List<String> categories;
  final bool isIncome;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleSubmit() {
    final localizations = AppLocalizations.of(context);
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      _showMessage(localizations.transactionsFormAmountError);
      return;
    }

    final String cleanedAmount = amountText.replaceAll(RegExp(r'[^0-9.]'), '');
    final double? amount = double.tryParse(cleanedAmount);
    if (amount == null || amount <= 0) {
      _showMessage(localizations.transactionsFormAmountInvalid);
      return;
    }

    final category = widget.categories[_selectedCategoryIndex];
    NotificationCenter.instance.recordTransaction(
      amount: amount,
      category: category,
      isIncome: widget.isIncome,
      localizations: localizations,
      timestamp: _selectedDate,
    );
    final note = _noteController.text.trim();
    final record = TransactionRecord(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      title: note.isEmpty ? category : note,
      category: category,
      amount: amount,
      type: widget.isIncome ? TransactionType.income : TransactionType.expense,
      date: _selectedDate,
      note: note.isEmpty ? null : note,
      icon: iconForCategory(category),
    );
    TransactionService.instance.addTransaction(record);

    Navigator.of(context).pop(localizations.transactionsToastSaved);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');
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
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.transactionsFormAmountLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: '\$',
                hintText: '0.00',
                filled: true,
                fillColor: Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  borderSide: BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.transactionsFormCategoryLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var i = 0; i < widget.categories.length; i++)
                  ChoiceChip(
                    label: Text(widget.categories[i]),
                    selected: _selectedCategoryIndex == i,
                    onSelected: (_) =>
                        setState(() => _selectedCategoryIndex = i),
                    labelStyle: TextStyle(
                      color: _selectedCategoryIndex == i
                          ? Colors.white
                          : AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: const Color(0xFFEFF3FB),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              localizations.transactionsFormDateLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat.format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      _DateArrowButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => setState(
                          () => _selectedDate = _selectedDate.subtract(
                            const Duration(days: 1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _DateArrowButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        onTap: () => setState(
                          () => _selectedDate = _selectedDate.add(
                            const Duration(days: 1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: _selectDate,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.transactionsFormNoteLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: localizations.transactionsFormNoteHint,
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  borderSide: BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: GradientButton(
                label: widget.buttonLabel,
                onTap: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateArrowButton extends StatelessWidget {
  const _DateArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: AppColors.primaryBlue),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
