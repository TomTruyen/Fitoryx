import 'package:flutter/material.dart';

import 'package:fittrack/screens/Wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        iconTheme: IconThemeData(
          color: Color.fromRGBO(50, 100, 200, 1),
        ),
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
    );
  }
}
