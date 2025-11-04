import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_record.dart';
import '../utils/currency_utils.dart';

class TransactionService {
  TransactionService._internal();

  static final TransactionService instance = TransactionService._internal();

  final ValueNotifier<List<TransactionRecord>> _transactions =
      ValueNotifier<List<TransactionRecord>>(_seedTransactions);

  ValueListenable<List<TransactionRecord>> get listenable => _transactions;

  UnmodifiableListView<TransactionRecord> get transactions =>
      UnmodifiableListView(_transactions.value);

  void addTransaction(TransactionRecord record) {
    final updated = [record, ..._transactions.value];
    _transactions.value = updated;
  }

  void removeTransaction(String id) {
    final updated = _transactions.value.where((item) => item.id != id).toList();
    _transactions.value = updated;
  }

  void upsertTransaction(TransactionRecord record) {
    final existingIndex = _transactions.value.indexWhere(
      (item) => item.id == record.id,
    );
    if (existingIndex == -1) {
      addTransaction(record);
      return;
    }
    final List<TransactionRecord> updated = List.of(_transactions.value);
    updated[existingIndex] = record;
    _transactions.value = updated;
  }

  Map<String, List<TransactionRecord>> groupedByMonth(Locale locale) {
    final DateFormat formatter = DateFormat.yMMMM(locale.toLanguageTag());
    final Map<String, List<TransactionRecord>> grouped = {};
    for (final record in _transactions.value) {
      final String key = formatter.format(record.date);
      grouped.putIfAbsent(key, () => []).add(record);
    }
    return SplayTreeMap<String, List<TransactionRecord>>.from(grouped, (a, b) {
      final DateTime parsedA = formatter.parse(a);
      final DateTime parsedB = formatter.parse(b);
      return parsedB.compareTo(parsedA);
    });
  }

  String formatAmount(TransactionRecord record, Locale locale) {
    final String formatted = formatCurrencyVNDAbs(record.amount);
    return record.isIncome ? '+$formatted' : '-$formatted';
  }
}

IconData iconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'ăn uống':
    case 'an uong':
    case 'food':
      return Icons.fastfood_outlined;
    case 'sức khỏe':
    case 'suc khoe':
    case 'health':
      return Icons.favorite_border_rounded;
    case 'giải trí':
    case 'giai tri':
    case 'entertainment':
      return Icons.movie_outlined;
    case 'di chuyển':
    case 'di chuyen':
    case 'travel':
    case 'transport':
      return Icons.directions_car_outlined;
    case 'khác':
    case 'khac':
    case 'others':
    case 'other':
      return Icons.category_outlined;
    case 'lương':
    case 'luong':
    case 'salary':
      return Icons.work_outline;
    default:
      return Icons.attach_money;
  }
}

final List<TransactionRecord> _seedTransactions = [
  TransactionRecord(
    id: 'tx-1',
    title: 'Lương tháng 2',
    category: 'Lương',
    amount: 10000000,
    type: TransactionType.income,
    date: DateTime(2024, 2, 28),
    note: 'Thu nhập chính',
    icon: Icons.account_balance_wallet_outlined,
  ),
  TransactionRecord(
    id: 'tx-2',
    title: 'Tiền thuê nhà',
    category: 'Nhà ở',
    amount: 2500000,
    type: TransactionType.expense,
    date: DateTime(2024, 2, 25),
    note: 'Căn hộ tháng 2',
    icon: Icons.home_outlined,
  ),
  TransactionRecord(
    id: 'tx-3',
    title: 'Siêu thị cuối tuần',
    category: 'Ăn uống',
    amount: 1200000,
    type: TransactionType.expense,
    date: DateTime(2024, 2, 23),
    note: 'Đồ ăn và thực phẩm',
    icon: Icons.shopping_basket_outlined,
  ),
  TransactionRecord(
    id: 'tx-4',
    title: 'Đi lại tháng 2',
    category: 'Di chuyển',
    amount: 300000,
    type: TransactionType.expense,
    date: DateTime(2024, 2, 21),
    note: 'Xăng xe và taxi',
    icon: Icons.directions_car_outlined,
  ),
  TransactionRecord(
    id: 'tx-5',
    title: 'Giải trí cuối tuần',
    category: 'Giải trí',
    amount: 500000,
    type: TransactionType.expense,
    date: DateTime(2024, 2, 18),
    note: 'Xem phim và ăn tối',
    icon: Icons.movie_filter_outlined,
  ),
];
