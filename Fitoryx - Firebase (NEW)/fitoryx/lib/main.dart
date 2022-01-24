import 'package:firebase_core/firebase_core.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/sign_up.dart';
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
        home: _authService.getUser() == null ? SignUp() : const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            child: Text('Logout'),
            onPressed: () async {
              _authService.signOut();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
          ),
        ],
      )),
    );
  }
}
