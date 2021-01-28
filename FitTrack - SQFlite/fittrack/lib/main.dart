import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/screens/Wrapper.dart';
import 'package:fittrack/services/SQLDatabase.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        title: 'FitTrack',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          accentColor: Colors.blue[900],
          iconTheme: IconThemeData(
            color: Colors.blue[900],
          ),
          buttonColor: Colors.blue[900],
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue[900],
            unselectedIconTheme: IconThemeData(
              size: 24.0,
            ),
            selectedIconTheme: IconThemeData(
              size: 26.0,
            ),
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
