import 'package:fitoryx/screens/sign_in.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final _authService = AuthService();

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverFillRemaining(
            child: TextButton(
              child: const Text('Logout'),
              onPressed: () {
                _authService.signOut();

                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SignIn(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
