import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalProfileCache {
  static String _key(String uid) => 'profile.$uid';

  static Future<void> save({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(uid), jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> load(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(uid));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) return map;
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isComplete(String uid) async {
    final data = await load(uid);
    if (data == null) return false;
    bool has(String k) => (data[k] ?? '').toString().trim().isNotEmpty;
    return has('username') && has('firstName') && has('lastName') && has('dob');
  }
}
