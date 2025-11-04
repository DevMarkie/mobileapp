import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionRecord {
  const TransactionRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    this.icon,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? note;
  final IconData? icon;

  bool get isIncome => type == TransactionType.income;

  TransactionRecord copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    TransactionType? type,
    DateTime? date,
    String? note,
    IconData? icon,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      icon: icon ?? this.icon,
    );
  }
}
