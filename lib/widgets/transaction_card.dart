import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_record.dart';
import '../services/transaction_service.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.record,
    required this.locale,
    this.onEdit,
    this.onDelete,
    this.editLabel,
    this.deleteLabel,
  });

  final TransactionRecord record;
  final Locale locale;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? editLabel;
  final String? deleteLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isIncome = record.isIncome;
    final Color amountColor = isIncome
        ? const Color(0xFF1ABC9C)
        : colorScheme.error;
    final String amountLabel = TransactionService.instance.formatAmount(
      record,
      locale,
    );
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    final IconData icon =
        record.icon ??
        iconForCategory(
          record.category.isEmpty ? record.title : record.category,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isIncome
                      ? colorScheme.primary.withOpacity(
                          colorScheme.brightness == Brightness.dark
                              ? 0.25
                              : 0.12,
                        )
                      : colorScheme.error.withOpacity(
                          colorScheme.brightness == Brightness.dark
                              ? 0.22
                              : 0.12,
                        ),
                ),
                child: Icon(icon, color: amountColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormatter.format(record.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if ((record.note != null && record.note!.trim().isNotEmpty) ||
              onEdit != null ||
              onDelete != null) ...[
            const SizedBox(height: 12),
          ],
          if (record.note != null && record.note!.trim().isNotEmpty)
            Text(record.note!, style: theme.textTheme.bodyMedium),
          if (onEdit != null || onDelete != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  if (onEdit != null)
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: Text(editLabel ?? 'Edit'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        overlayColor: colorScheme.primary.withOpacity(0.08),
                      ),
                    ),
                  if (onEdit != null && onDelete != null)
                    const SizedBox(width: 12),
                  if (onDelete != null)
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: Text(deleteLabel ?? 'Delete'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                        overlayColor: colorScheme.error.withOpacity(0.08),
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
