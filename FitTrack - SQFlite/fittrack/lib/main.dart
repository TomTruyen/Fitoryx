import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/screens/Wrapper.dart';
import 'package:fittrack/services/SQLDatabase.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_database == null) {
        ReceivePort receivePort = new ReceivePort();
        Isolate isolate = await Isolate.spawn(
          _setupDatabase,
          receivePort.sendPort,
        );

        receivePort.listen((dynamic database) {
          if (database != null) {
            _database = database;
          }

          receivePort.close();
          isolate.kill();
        });
      }
    });
  }

  static void _setupDatabase(SendPort _sendPort) async {
    globals.sqlDatabase = new SQLDatabase();
    dynamic database = await globals.sqlDatabase.setupDatabase();

    _sendPort.send(database);
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
