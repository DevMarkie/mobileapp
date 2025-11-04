import 'package:flutter/material.dart';

enum NotificationKind { income, expense, reminder, system }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.kind,
    required this.icon,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationKind kind;
  final IconData icon;

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationKind? kind,
    IconData? icon,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      kind: kind ?? this.kind,
      icon: icon ?? this.icon,
    );
  }
}
