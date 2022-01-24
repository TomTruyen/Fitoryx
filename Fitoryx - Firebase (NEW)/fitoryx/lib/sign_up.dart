import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _signUp(email, password) async {
    try {
      await _authService.signUpWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          print('Email is invalid');
          break;
        case 'weak-password':
          print('The password provided is too weak');
          break;
        case 'email-already-in-use':
          print('Email is already in use');
          break;
        default:
          print('Something went wrong');
          break;
      }
    }
  }
}
