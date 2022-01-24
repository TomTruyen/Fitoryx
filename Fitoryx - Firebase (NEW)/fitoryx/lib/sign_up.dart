import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/sign_in.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _authService = AuthService();

  final _signUpFormKey = GlobalKey<FormState>();

  bool _isBusy = false;
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: _signUpFormKey,
            child: Column(
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
                        'Let\'s get started!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Create an account to start your journey',
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
                  text: 'SIGN UP',
                  onPressed: () {
                    _signUp(_email, _password);
                  },
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => SignIn(),
                      ),
                    );
                  },
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.blue[600],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(email, password) async {
    if (_signUpFormKey.currentState != null &&
        _signUpFormKey.currentState!.validate()) {
      clearFocus(context);

      try {
        setState(() => _isBusy = true);

        await _authService.signUpWithEmailAndPassword(email, password);
      } on FirebaseAuthException catch (e) {
        String error = "";

        switch (e.code) {
          case 'invalid-email':
            error = "Email is invalid";
            break;
          case 'weak-password':
            error = "Password is too weak.";
            break;
          case 'email-already-in-use':
            error = "Email is already taken.";
            break;
          default:
            error = "Something went wrong. Please try again.";
            break;
        }

        showAlert(context, title: "Error", content: error);

        setState(() => _isBusy = false);
      }
    }
  }
}
