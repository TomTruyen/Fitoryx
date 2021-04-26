// Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// PubDev Packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// My Files
import 'package:fittrack/SignIn.dart';
import 'package:fittrack/FitTrack.dart';
import 'package:fittrack/shared/Theme.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';

// Global Variables
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _uid;

  @override
  void initState() {
    super.initState();

    _uid = _prefs.then((SharedPreferences prefs) {
      String uid = prefs.getString("uid") ?? "";
      String email = prefs.getString("email") ?? "";
      String name = prefs.getString("name") ?? "";

      globals.uid = uid;
      globals.email = email;
      globals.name = name;

      return uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExerciseFilter>(
          create: (_) => ExerciseFilter(),
        ),
        ChangeNotifierProvider<WorkoutChangeNotifier>(
          create: (_) => WorkoutChangeNotifier(),
        ),
      ],
      child: MaterialApp(
        title: 'FitTrack',
        theme: theme,
        home: FutureBuilder<String>(
          future: _uid,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return Loader();
            } else {
              if (snapshot.hasError || snapshot.data == "") {
                return SignIn();
              } else {
                return FitTrack();
              }
            }
          },
        ),
      ),
    );
  }
}
