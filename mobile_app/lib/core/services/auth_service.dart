import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> checkAndSignInWithToken() async {
    final token = await getToken();
    print(token);
    if (token != null) {
      return true;
    }
    return false;
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
        final idToken = await value.user!.getIdToken();
        print(idToken);
        if (idToken != null) {
          await saveToken(idToken);
        }
      });
      
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}