import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoryx/services/cache_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Singleton Setup
  static final AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  // Properties
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up (Email & Password)
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign In (Email & Password)
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // Sign Out
  Future<void> signOut() async {
    CacheService().clear();
    await _auth.signOut();
  }

  // Get User
  User? getUser() {
    return _auth.currentUser;
  }
}
