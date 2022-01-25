import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoryx/screens/sign_up.dart';
import 'package:fitoryx/screens/wrapper.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:fitoryx/widgets/google_button.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _authService = AuthService();
  final _signInFormKey = GlobalKey<FormState>();

  bool _isBusy = false;
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(16),
            child: Form(
              key: _signInFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    height: 100.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sign in to continue on your journey',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                  ),
                  FormInput(
                    hintText: 'Email',
                    radius: 16,
                    inputType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }

                      return null;
                    },
                    onChanged: (String value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  FormInput(
                    hintText: 'Password',
                    radius: 16,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }

                      return null;
                    },
                    onChanged: (String value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  GradientButton(
                    radius: 16,
                    isBusy: _isBusy,
                    text: 'SIGN IN',
                    onPressed: () {
                      _signInWithEmailAndPassword(_email, _password);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const SignUp(),
                        ),
                      );
                    },
                    child: Text(
                      'Need an account?',
                      style: TextStyle(
                        color: Colors.blue[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GoogleButton(onPressed: () => _signInWithGoogle()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() {
    if (_authService.getUser() != null) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Wrapper(),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      _signIn();
    } catch (e) {
      showAlert(
        context,
        content: "Google sign in failed. Please try again.",
      );
    }
  }

  Future<void> _signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (_signInFormKey.currentState != null &&
        _signInFormKey.currentState!.validate()) {
      clearFocus(context);
      try {
        setState(() => _isBusy = true);

        await _authService.signInWithEmailAndPassword(email, password);
        _signIn();
      } on FirebaseAuthException catch (e) {
        String error = "";

        switch (e.code) {
          case 'invalid-email':
            error = "Email is invalid";
            break;
          case 'user-disabled':
            error = "Your account has been disabled";
            break;
          case 'user-not-found':
            error = "Invalid email/password combination";
            break;
          case 'wrong-password':
            error = "Invalid email/password combination";
            break;
          default:
            error = "Something went wrong. Please try again.";
            break;
        }

        showAlert(context, content: error);
      }

      setState(() => _isBusy = false);
    }
  }
}
