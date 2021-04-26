// Flutter Packages
import 'package:fittrack/services/Auth.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/FitTrack.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/shared/SocialSignInButton.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          slivers: <Widget>[
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
                    ? LoaderWithMessage(text: 'Signing in...')
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            child: SocialSignInButton(
                              imageURL: 'assets/google_logo.png',
                            ),
                            style: TextButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.transparent,
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoggingIn = true;
                              });

                              bool isSignedIn = await Auth().googleSignIn();

                              if (isSignedIn) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FitTrack(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoggingIn = false;
                                });
                              }
                            },
                          ),
                          TextButton(
                            child: SocialSignInButton(
                              imageURL: 'assets/facebook_logo.png',
                            ),
                            style: TextButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.transparent,
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoggingIn = true;
                              });

                              bool isSignedIn = await Auth().facebookSignIn();

                              if (isSignedIn) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FitTrack(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoggingIn = false;
                                });
                              }
                            },
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
