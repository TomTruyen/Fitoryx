import 'package:fitoryx/screens/sign_in.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  WorkoutPage({Key? key}) : super(key: key);

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Email: ${_authService.getUser()?.email}"),
            Text("UID: ${_authService.getUser()?.uid}"),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                _authService.signOut();

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SignIn(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
