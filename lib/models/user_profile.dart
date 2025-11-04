import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.membershipTier,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? membershipTier;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserProfile.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return UserProfile(
      id: snapshot.id,
      name: (data['name'] as String?)?.trim() ?? '',
      email: (data['email'] as String?)?.trim() ?? '',
      phone: _nullableString(data['phone']),
      address: _nullableString(data['address']),
      membershipTier: _nullableString(data['membershipTier']),
      createdAt: _timestampToDate(data['createdAt']),
      updatedAt: _timestampToDate(data['updatedAt']),
    );
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? membershipTier,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      membershipTier: membershipTier ?? this.membershipTier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'membershipTier': membershipTier,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    }..removeWhere((_, value) => value == null);
  }

  static String? _nullableString(dynamic value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  static DateTime? _timestampToDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
