import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _authService.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          print('Email is invalid');
          break;
        case 'user-disabled':
          print('Account is disabled');
          break;
        case 'user-not-found':
          print('Invalid email/password combination');
          break;
        case 'wrong-password':
          print('Invalid email/password combination');
          break;
        default:
          print('Something went wrong');
          break;
      }
    }
  }
}
