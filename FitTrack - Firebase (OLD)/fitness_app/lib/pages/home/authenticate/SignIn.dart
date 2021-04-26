import 'package:fitness_app/services/Auth.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = "";
  String password = "";
  String error = "";

  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              forceElevated: true,
              floating: true,
              pinned: true,
              title: Text('Sign in'),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: isLoggingIn
                    ? Loading(
                        text: 'Signing in...',
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.transparent,
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoggingIn = true;
                              });

                              dynamic result = await _auth.googleSignIn();

                              if (result == null) {
                                setState(() {
                                  isLoggingIn = false;
                                  error = 'Failed to sign-in with Google';
                                });
                              }
                            },
                            child: ButtonDesign(
                              imageURL: "assets/google_logo.png",
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.transparent,
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoggingIn = true;
                              });

                              dynamic result = await _auth.facebookSignIn();

                              if (result == null) {
                                setState(() {
                                  isLoggingIn = false;
                                  error = 'Failed to sign-in with Facebook';
                                });
                              }
                            },
                            child: ButtonDesign(
                              imageURL: "assets/facebook_logo.png",
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonDesign extends StatelessWidget {
  final String imageURL;

  ButtonDesign({
    this.imageURL = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 75.0,
      width: 75.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Image(
        image: AssetImage(imageURL),
        width: 50,
      ),
    );
  }
}
