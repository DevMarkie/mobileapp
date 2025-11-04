import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  const AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  static Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    const maxAttempts = 3;
    final sanitizedEmail = email.trim();
    final sanitizedPassword = password.trim();

    FirebaseAuthException? lastAuthError;
    Object? lastError;
    StackTrace? lastStack;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await _auth.createUserWithEmailAndPassword(
          email: sanitizedEmail,
          password: sanitizedPassword,
        );
      } on FirebaseAuthException catch (error, stack) {
        if (!_isTransientAuthError(error.code) || attempt == maxAttempts - 1) {
          rethrow;
        }
        lastAuthError = error;
        lastStack = stack;
        final delay = Duration(milliseconds: 400 * (1 << attempt));
        await Future<void>.delayed(delay);
      } catch (error, stack) {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
        lastError = error;
        lastStack = stack;
        final delay = Duration(milliseconds: 400 * (1 << attempt));
        await Future<void>.delayed(delay);
      }
    }

    if (lastAuthError != null) {
      Error.throwWithStackTrace(lastAuthError, lastStack ?? StackTrace.empty);
    }
    if (lastError != null) {
      Error.throwWithStackTrace(lastError, lastStack ?? StackTrace.empty);
    }

    throw FirebaseAuthException(
      code: 'unknown',
      message: 'Unable to sign up at this time. Please try again later.',
    );
  }

  static Future<void> sendPasswordReset({required String email}) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null ||
        (user.email ?? '').toLowerCase() != email.trim().toLowerCase()) {
      throw FirebaseAuthException(
        code: 'requires-recent-login',
        message: 'Current session does not belong to $email.',
      );
    }

    await user.updatePassword(newPassword.trim());
  }

  static Future<void> signOut() {
    return _auth.signOut();
  }
}

bool _isTransientAuthError(String code) {
  const transientCodes = <String>{
    'internal-error',
    'network-request-failed',
    'service-unavailable',
    'timeout',
  };
  return transientCodes.contains(code);
}
