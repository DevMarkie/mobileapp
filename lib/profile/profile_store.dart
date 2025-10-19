import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'local_profile_cache.dart';

Map<String, String> _normalizeProfile(Map<String, dynamic>? raw) {
  return {
    'username': (raw?['username'] ?? '').toString().trim(),
    'firstName': (raw?['firstName'] ?? '').toString().trim(),
    'lastName': (raw?['lastName'] ?? '').toString().trim(),
    'dob': (raw?['dob'] ?? '').toString().trim(),
  };
}

bool _profileFilled(Map<String, String> data) {
  return data.values.every((value) => value.isNotEmpty);
}

Future<void> _cacheProfile(String uid, Map<String, String> data) {
  return LocalProfileCache.save(uid: uid, data: data);
}

class ProfileStore {
  static bool _firestoreDisabled = false;

  static bool get _canUseFirestore => !_firestoreDisabled;

  static void _maybeDisableFirestore(Object error) {
    if (error is FirebaseException) {
      final msg = (error.message ?? '').toLowerCase();
      if (error.code == 'not-found' ||
          msg.contains('the database (default) does not exist')) {
        _firestoreDisabled = true;
      }
    }
  }

  static Future<void> ensureInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }

  static CollectionReference<Map<String, dynamic>> _col() =>
      FirebaseFirestore.instance.collection('profiles');

  static Future<void> saveProfile({
    required String uid,
    required String username,
    required String firstName,
    required String lastName,
    required String dob,
  }) async {
    final canonical = _normalizeProfile({
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
    });
    // Try remote first
    if (_canUseFirestore) {
      try {
        await ensureInitialized();
        await _col().doc(uid).set({
          ...canonical,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        _maybeDisableFirestore(e);
        // ignore cloud errors here, we'll persist locally regardless
      }
    }
    // Always cache locally as fallback
    await _cacheProfile(uid, canonical);
  }

  static Future<bool> isProfileComplete(String uid) async {
    final local = _normalizeProfile(await LocalProfileCache.load(uid));
    if (_profileFilled(local)) return true;

    if (_canUseFirestore) {
      try {
        await ensureInitialized();
        final doc = await _col().doc(uid).get();
        if (doc.exists) {
          final remote = _normalizeProfile(doc.data());
          if (_profileFilled(remote)) {
            await _cacheProfile(uid, remote);
            return true;
          }
          final merged = {
            'username': local['username'] ?? '',
            'firstName': local['firstName'] ?? '',
            'lastName': local['lastName'] ?? '',
            'dob': local['dob'] ?? '',
          };
          remote.forEach((key, value) {
            if (value.isNotEmpty) merged[key] = value;
          });
          final mergedClean = _normalizeProfile(merged);
          await _cacheProfile(uid, mergedClean);
          return _profileFilled(mergedClean);
        }
      } catch (e) {
        _maybeDisableFirestore(e);
        // ignore and fallback to local cache state
      }
    }

    return _profileFilled(local);
  }

  static Future<Map<String, dynamic>?> getProfile(String uid) async {
    if (_canUseFirestore) {
      try {
        await ensureInitialized();
        final doc = await _col().doc(uid).get();
        if (doc.exists) {
          final remote = _normalizeProfile(doc.data());
          await _cacheProfile(uid, remote);
          return remote;
        }
      } catch (e) {
        _maybeDisableFirestore(e);
        // ignore
      }
    }
    final local = await LocalProfileCache.load(uid);
    if (local == null) return null;
    return _normalizeProfile(local);
  }
}
