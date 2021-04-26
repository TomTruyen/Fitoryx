import 'dart:math';

import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/models/workout/WorkoutExerciseSet.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/pages/workout/WorkoutStartPage.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryViewPage extends StatelessWidget {
  final WorkoutHistory history;

  HistoryViewPage({this.history});

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context);
    final List<WorkoutStreamProvider> dbWorkouts =
        Provider.of<List<WorkoutStreamProvider>>(context) ?? null;

    final User user = Provider.of<User>(context) ?? null;

    UserSettings settings = Provider.of<UserSettings>(context) ?? null;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  popContextWhenPossible(context);
                },
              ),
              title: Text(history.name),
              actions: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: Color.fromRGBO(35, 35, 35, 1),
                    dividerColor: Color.fromRGBO(70, 70, 70, 1),
                  ),
                  child: PopupMenuButton(
                    offset: Offset(0.0, 80.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    icon: Icon(Icons.more_vert),
                    onSelected: (selection) async {
                      if (selection == 'template') {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        final loadingSnackbar = SnackBar(
                          elevation: 8.0,
                          backgroundColor: Colors.orange[400],
                          content: Text(
                            'Saving...',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(minutes: 1),
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(loadingSnackbar);

                        workout.id = history.id;
                        workout.name = history.name;
                        workout.workoutNote = history.workoutNote;
                        workout.exercises = history.exercises;

                        dynamic result = await DatabaseService(
                                uid: user != null ? user.uid : '')
                            .addWorkout(workout, dbWorkouts);

                        await Future.delayed(
                          Duration(milliseconds: 500),
                          () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        );

                        if (result != null) {
                          final successSnackbar = SnackBar(
                            duration: Duration(seconds: 1),
                            elevation: 8.0,
                            backgroundColor: Colors.green[400],
                            content: GestureDetector(
                              child: Text(
                                'Saved',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackbar);
                        } else {
                          final failureSnackbar = SnackBar(
                            duration: Duration(seconds: 1),
                            elevation: 8.0,
                            backgroundColor: Colors.red[400],
                            content: GestureDetector(
                              child: Text(
                                'Save Failed',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(failureSnackbar);
                        }
                      } else if (selection == 'delete') {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        final loadingSnackbar = SnackBar(
                          elevation: 8.0,
                          backgroundColor: Colors.orange[400],
                          content: Text(
                            'Deleting...',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(minutes: 1),
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(loadingSnackbar);

                        dynamic result = await DatabaseService(uid: user.uid)
                            .removeWorkoutHistory(history.id);

                        await Future.delayed(
                          Duration(milliseconds: 500),
                          () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        );

                        if (result != null) {
                          final successSnackbar = SnackBar(
                            duration: Duration(seconds: 1),
                            elevation: 8.0,
                            backgroundColor: Colors.green[400],
                            content: GestureDetector(
                              child: Text(
                                'Deleted',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackbar);

                          Future.delayed(
                            Duration(milliseconds: 1500),
                            () {
                              popContextWhenPossible(context);
                            },
                          );
                        } else {
                          final failureSnackbar = SnackBar(
                            duration: Duration(seconds: 1),
                            elevation: 8.0,
                            backgroundColor: Colors.red[400],
                            content: GestureDetector(
                              child: Text(
                                'Deleting Failed',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(failureSnackbar);
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuItem>[
                      PopupMenuItem(
                        height: 40.0,
                        value: 'template',
                        child: Text(
                          'Save as workout template',
                          style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      PopupMenuItem(
                        height: 40.0,
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text(DateFormat("EEEE, d MMMM yyyy, H:mm")
                    .format(history.workoutTime)),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.watch_later, size: 18.0),
                          SizedBox(width: 5.0),
                          Text(history.workoutDuration),
                        ],
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Transform.rotate(
                            angle: -pi / 4,
                            child: Icon(Icons.fitness_center, size: 18.0),
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            _getTotalWeightLifted(
                                  history.exercises,
                                  history.weightUnit,
                                  settings.weightUnit,
                                ) +
                                (settings != null
                                    ? settings.weightUnit == 'metric'
                                        ? ' kg'
                                        : ' lbs'
                                    : ' kg'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 10.0,
              ),
            ),
            SliverList(
              delegate: (SliverChildBuilderDelegate(
                (context, index) {
                  // Print all exercises + sets + weight in that set x reps
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            history.exercises[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (int i = 0;
                            i < history.exercises[index].sets.length;
                            i++)
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  _getExerciseSet(
                                    i + 1,
                                    history.exercises[index].sets[i],
                                    history.weightUnit,
                                    settings.weightUnit,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
                childCount: history.exercises.length,
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                width: 1,
                color: Theme.of(context).accentColor,
              ),
            ),
            padding: EdgeInsets.all(14.0),
            backgroundColor: Theme.of(context).accentColor,
          ),
          child: Text(
            'Perform Again',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            workout.id = history.id;
            workout.name = history.name;
            workout.workoutNote = history.workoutNote;
            workout.exercises = history.exercises;

            popContextWhenPossible(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => WorkoutStartPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

String _getExerciseSet(
  int setIndex,
  WorkoutExerciseSet exerciseSet,
  String workoutWeightUnit,
  String settingsWeightUnit,
) {
  String weightUnitValue = workoutWeightUnit == "metric" ? "kg" : "lbs";

  double exerciseWeight = exerciseSet.weight;

  if (workoutWeightUnit != settingsWeightUnit) {
    exerciseWeight = recalculateWeights(exerciseSet.weight, settingsWeightUnit);

    weightUnitValue = settingsWeightUnit == "metric" ? "kg" : "lbs";
  }

  return "$setIndex \t ${exerciseSet.reps} x $exerciseWeight $weightUnitValue";
}

String _getTotalWeightLifted(
  List<WorkoutExercise> exercises,
  String workoutWeightUnit,
  String settingsWeightUnit,
) {
  double totalWeight = 0.0;

  for (int i = 0; i < exercises.length; i++) {
    for (int j = 0; j < exercises[i].sets.length; j++) {
      totalWeight += (exercises[i].sets[j].reps * exercises[i].sets[j].weight);
    }
  }

  if (settingsWeightUnit != workoutWeightUnit) {
    totalWeight = recalculateWeights(totalWeight, settingsWeightUnit);
  }

  final weightFormat = new NumberFormat('# ##0.00', 'en_US');

  return weightFormat.format(totalWeight);
}
