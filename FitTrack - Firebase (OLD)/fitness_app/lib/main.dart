import 'package:fitness_app/models/AppData.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/exercises/Exercise.dart';
import 'package:fitness_app/models/exercises/ExerciseCategory.dart';
import 'package:fitness_app/models/exercises/ExerciseEquipment.dart';
import 'package:fitness_app/models/exercises/ExerciseFilter.dart';
import 'package:fitness_app/models/exercises/UserExercise.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/models/food/Nutrition.dart';
import 'package:fitness_app/pages/home/authenticate/SignIn.dart';
import 'package:fitness_app/services/Auth.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/pages/home/Wrapper.dart';
import 'package:fitness_app/shared/Themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
        StreamProvider<User>(
          create: (_) => AuthService().user,
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final user = Provider.of<User>(context) ?? null;

          return user == null
              ? MaterialApp(
                  theme: lightTheme,
                  home: SignIn(),
                )
              : MultiProvider(
                  providers: [
                    StreamProvider<List<Exercise>>(
                      create: (_) => DatabaseService().exercises,
                    ),
                    StreamProvider<List<ExerciseCategory>>(
                      create: (_) => DatabaseService().categories,
                    ),
                    StreamProvider<List<ExerciseEquipment>>(
                      create: (_) => DatabaseService().equipment,
                    ),
                    StreamProvider<AppData>(
                      create: (_) => DatabaseService().appdata,
                    ),
                    ChangeNotifierProvider<ExerciseFilter>(
                      create: (_) => ExerciseFilter(),
                    ),
                    ChangeNotifierProvider<WorkoutChangeNotifier>(
                      create: (_) => WorkoutChangeNotifier(),
                    ),
                    StreamProvider<List<UserExercise>>(
                      create: (_) =>
                          DatabaseService(uid: user != null ? user.uid : '')
                              .userExercises,
                    ),
                    StreamProvider<List<WorkoutStreamProvider>>(
                        create: (_) =>
                            DatabaseService(uid: user != null ? user.uid : '')
                                .workouts),
                    StreamProvider<List<WorkoutHistory>>(
                      create: (_) =>
                          DatabaseService(uid: user != null ? user.uid : '')
                              .workoutHistory,
                    ),
                    StreamProvider<UserSettings>(
                      create: (_) =>
                          DatabaseService(uid: user != null ? user.uid : '')
                              .settings,
                    ),
                    StreamProvider<Nutrition>(
                      create: (_) =>
                          DatabaseService(uid: user != null ? user.uid : '')
                              .nutrition,
                    ),
                  ],
                  child: MaterialApp(
                    theme: lightTheme,
                    home: Wrapper(),
                  ),
                );
        },
      ),
    );
  }
}
