import 'package:fittrack/shared/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/screens/Wrapper.dart';
import 'package:fittrack/services/SQLDatabase.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

void main() {
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

    // Doe deze stappen in een isolate zodat het van de main thread wordt gehaald
    // Geef loader widget een optie voor text mee te geven (en geef in de futurebuilder dan de tekst 'Loading...' mee)
    globals.sqlDatabase = new SQLDatabase();
    _database = globals.sqlDatabase.setupDatabase().then((value) => value);
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
              return Loader();
            } else {
              return Wrapper();
            }
          },
        ),
      ),
    );
  }
}
