import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserService {
  const UserService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  static CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(_collection);

  static Future<void> ensureUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    final docRef = _usersRef.doc(uid);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.update({
        'name': name,
        'email': email,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await docRef.set({
      'name': name,
      'email': email,
      'membershipTier': 'Basic',
      'phone': null,
      'address': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<UserProfile?> profileStream(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserProfile.fromDocument(snapshot);
    });
  }

  static Future<UserProfile?> fetchProfile(String uid) async {
    final snapshot = await _usersRef.doc(uid).get();
    if (!snapshot.exists) return null;
    return UserProfile.fromDocument(snapshot);
  }

  static Future<void> updateProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _usersRef.doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
