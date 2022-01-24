import 'package:firebase_core/firebase_core.dart';
import 'package:fitoryx/screens/sign_in.dart';
import 'package:fitoryx/screens/workout/workout_page.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Firebase Options has to be generated (README.MD)
import 'firebase_options.dart';

void main() async {
  // Firebase Setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authService = AuthService();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _authService.getUser() == null ? const SignIn() : WorkoutPage());
  }
}
