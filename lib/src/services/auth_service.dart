import 'package:firebase_auth/firebase_auth.dart';

import 'storage_service.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Currently signed in user (nullable)
  static User? get currentUser => _auth.currentUser;

  /// Sign in with email & password
  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Create account with email & password
  static Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign out
  static Future<void> signOut() async {
    await KodoStorageService.instance.clear();
    return _auth.signOut();
  }
}
