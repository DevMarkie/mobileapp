import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_notification.dart';
import '../utils/currency_utils.dart';

class NotificationCenter {
  NotificationCenter._internal();

  static final NotificationCenter instance = NotificationCenter._internal();

  final ValueNotifier<List<AppNotification>> _notifications =
      ValueNotifier<List<AppNotification>>(_seedData);

  ValueListenable<List<AppNotification>> get listenable => _notifications;

  UnmodifiableListView<AppNotification> get notifications =>
      UnmodifiableListView(_notifications.value);

  void addNotification(AppNotification notification) {
    final updated = [notification, ..._notifications.value];
    _notifications.value = updated;
  }

  void clear() {
    _notifications.value = const [];
  }

  String recordTransaction({
    required double amount,
    required String category,
    required bool isIncome,
    required AppLocalizations localizations,
    DateTime? timestamp,
  }) {
    final DateTime time = timestamp ?? DateTime.now();
    final String formattedAmount = formatCurrencyVNDAbs(amount);
    final NotificationKind kind = isIncome
        ? NotificationKind.income
        : NotificationKind.expense;
    final IconData icon = isIncome
        ? Icons.call_made_rounded
        : Icons.call_received_rounded;

    final String title = isIncome
        ? localizations.notificationsIncomeTitle
        : localizations.notificationsExpenseTitle;

    final String messageTemplate = isIncome
        ? localizations.notificationsIncomeMessage
        : localizations.notificationsExpenseMessage;

    final String message = messageTemplate
        .replaceFirst('{amount}', formattedAmount)
        .replaceFirst('{category}', category);

    addNotification(
      AppNotification(
        id: '${time.millisecondsSinceEpoch}-${kind.name}',
        title: title,
        message: message,
        timestamp: time,
        kind: kind,
        icon: icon,
      ),
    );

    return message;
  }
}

final List<AppNotification> _seedData = [
  AppNotification(
    id: 'seed-1',
    title: 'Giải trí',
    message: 'Bạn đã thanh toán Netflix Plan 129.000₫.',
    timestamp: DateTime(2024, 10, 28, 9, 30),
    kind: NotificationKind.expense,
    icon: Icons.movie_outlined,
  ),
  AppNotification(
    id: 'seed-2',
    title: 'Nhắc nhở hóa đơn',
    message: 'Hóa đơn Internet sẽ đến hạn trong 3 ngày nữa.',
    timestamp: DateTime(2024, 10, 27, 18, 10),
    kind: NotificationKind.system,
    icon: Icons.receipt_long_outlined,
  ),
  AppNotification(
    id: 'seed-3',
    title: 'Thu nhập',
    message: 'Tiền thưởng tháng 10 đã được ghi nhận 2.500.000₫.',
    timestamp: DateTime(2024, 10, 25, 14, 5),
    kind: NotificationKind.income,
    icon: Icons.card_giftcard,
  ),
];
