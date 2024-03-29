import 'dart:math';

import 'package:Fitoryx/models/exercises/ExerciseFilter.dart';
import 'package:Fitoryx/models/workout/WorkoutChangeNotifier.dart';
import 'package:Fitoryx/screens/Wrapper.dart';
import 'package:Fitoryx/services/SQLDatabase.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:Fitoryx/shared/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  globals.sqlDatabase = new SQLDatabase();
  await globals.sqlDatabase.setupDatabase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<dynamic> _database;

  @override
  void initState() {
    super.initState();

    Random rand = new Random();
    int random = rand.nextInt(3000) + 1500;
    _database = Future.delayed(Duration(milliseconds: random), () => true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExerciseFilter>(
          create: (_) => ExerciseFilter(),
        ),
        ChangeNotifierProvider<WorkoutChangeNotifier>(
          create: (_) => WorkoutChangeNotifier(exercises: []),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fitoryx',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
        ),
        home: FutureBuilder<dynamic>(
          future: _database,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Loader(text: 'Loading...');
            } else {
              return Wrapper();
            }
          },
        ),
      ),
    );
  }
}
