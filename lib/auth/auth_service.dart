import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  /// Ensure Firebase is initialized before calling any auth API.
  static Future<void> ensureInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }

  /// Sign out from Firebase Auth, and attempt to sign out Google if used.
  static Future<void> signOut() async {
    await ensureInitialized();
    // If you additionally use GoogleSignIn directly in the UI, you can
    // optionally sign out there too. FirebaseAuth signOut is sufficient for
    // ending the Firebase session.
    await FirebaseAuth.instance.signOut();
  }

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  static Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await ensureInitialized();
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  static Future<UserCredential> createUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await ensureInitialized();
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }
}
