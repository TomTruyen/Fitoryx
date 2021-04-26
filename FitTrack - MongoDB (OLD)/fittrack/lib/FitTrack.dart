// Dart Packages
import 'dart:isolate';
import 'dart:math';

// Flutter Packages
import 'package:fittrack/model/Appdata.dart';
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/model/workout/Workout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Packages
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/model/settings/Settings.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/pages/profile/ProfilePage.dart';
import 'package:fittrack/pages/history/HistoryPage.dart';
import 'package:fittrack/pages/workout/WorkoutPage.dart';
import 'package:fittrack/pages/exercise/ExercisePage.dart';
import 'package:fittrack/pages/food/FoodPage.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class FitTrack extends StatefulWidget {
  // This file will be the same as the Home.dart file from the old version

  @override
  _FitTrackState createState() => _FitTrackState();
}

class _FitTrackState extends State<FitTrack> {
  bool isLoading = true;

  int _selectedIndex = 2;

  final _pages = <Widget>[
    ProfilePage(),
    HistoryPage(),
    WorkoutPage(),
    ExercisePage(),
    FoodPage(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.settings == null ||
          globals.appdata == null ||
          globals.workoutHistory == null ||
          globals.workouts == null ||
          globals.exercises == null ||
          globals.categories == null ||
          globals.equipment == null ||
          globals.nutritionHistory == null) {
        ReceivePort receivePort = ReceivePort();
        Isolate isolate = await Isolate.spawn(
          _loadDatabase,
          {"sendPort": receivePort.sendPort, "uid": globals.uid},
        );

        receivePort.listen((data) {
          Appdata appdata = data['appdata'];
          Settings settings = data['settings'];
          List<WorkoutHistory> workoutHistory = data['workoutHistory'];
          List<Workout> workouts = data['workouts'];
          List<Exercise> exercises = data['exercises'];
          List<ExerciseCategory> categories = data['categories'];
          List<ExerciseEquipment> equipment = data['equipment'];
          List<Nutrition> nutritionHistory = data['nutritionHistory'];

          globals.settings = settings;
          globals.appdata = appdata;
          globals.workoutHistory = workoutHistory;
          globals.workouts = workouts;
          globals.exercises = exercises;
          globals.categories = categories;
          globals.equipment = equipment;
          globals.nutritionHistory = nutritionHistory;

          setState(() {
            isLoading = false;
          });

          receivePort.close();
          isolate.kill();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  static void _loadDatabase(Map<String, dynamic> map) async {
    SendPort _sendPort = map["sendPort"];
    String _uid = map["uid"];

    Map _data = await Database(uid: _uid).loadDatabase();

    _sendPort.send(_data);
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter exerciseFilter =
        Provider.of<ExerciseFilter>(context, listen: false) ?? null;

    return Scaffold(
      body: isLoading
          ? LoaderWithMessage(text: "Loading...")
          : _pages[_selectedIndex],
      bottomNavigationBar: isLoading
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                if (index == 3 && exerciseFilter != null) {
                  exerciseFilter.clearFilters();
                }

                setState(() {
                  _selectedIndex = index;
                });
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.watch_later),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Workout',
                ),
                BottomNavigationBarItem(
                  icon: Transform.rotate(
                    angle: -pi / 4,
                    child: Icon(Icons.fitness_center),
                  ),
                  label: 'Exercises',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  label: 'Nutrition',
                ),
              ],
            ),
    );
  }
}
