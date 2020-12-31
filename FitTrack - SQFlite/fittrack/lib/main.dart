import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/screens/Wrapper.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExerciseFilter>(create: (_) => ExerciseFilter()),
      ],
      child: MaterialApp(
        title: 'FitTrack',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          accentColor: Color.fromRGBO(50, 100, 200, 1),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(50, 100, 200, 1),
          ),
          buttonColor: Color.fromRGBO(50, 100, 200, 1),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color.fromRGBO(50, 100, 200, 1),
            unselectedIconTheme: IconThemeData(
              size: 24.0,
            ),
            selectedIconTheme: IconThemeData(
              size: 26.0,
            ),
          ),
        ),
        home: Wrapper(),
      ),
    );
  }
}
