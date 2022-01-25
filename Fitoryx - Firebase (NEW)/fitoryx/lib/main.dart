import 'package:firebase_core/firebase_core.dart';
import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/screens/sign_in.dart';
import 'package:fitoryx/screens/wrapper.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExerciseFilter>(
          create: (_) => ExerciseFilter(),
        ),
      ],
      child: MaterialApp(
        title: 'Fitoryx',
        debugShowCheckedModeBanner: false,
        theme: _themeData(),
        home: _authService.getUser() == null ? const SignIn() : const Wrapper(),
      ),
    );
  }

  ThemeData _themeData() {
    return ThemeData(
      fontFamily: 'OpenSans',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor: Colors.grey,
        unselectedIconTheme: IconThemeData(
          size: 24.0,
        ),
        selectedIconTheme: IconThemeData(
          size: 26.0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.grey[900],
        ),
      ),
      textTheme: TextTheme(
        // Main Text
        bodyText2: TextStyle(
          color: Colors.grey[900],
          fontSize: 16.0,
        ),
        // ListView Text
        subtitle2: TextStyle(
          color: Colors.grey[700],
          fontSize: 14.0,
        ),
        // ListView Subtitle Text
        caption: TextStyle(
          color: Colors.grey[700],
          fontSize: 13.0,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.blue[900],
        selectionColor: Colors.blue[100],
      ),
    );
  }
}
