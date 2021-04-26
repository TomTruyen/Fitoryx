// Dart Packages
import 'dart:isolate';
import 'dart:math';

// Flutter Packages
import 'package:flutter/material.dart';

// PubDev Pacakges
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// My Packages
import 'package:fittrack/model/workout/Workout.dart';
import 'package:fittrack/misc/history/WorkoutHistoryPageFunctions.dart';
import 'package:fittrack/misc/history/WorkoutHistoryViewPageFunctions.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/pages/workout/WorkoutStartPage.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/shared/Snackbars.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class HistoryViewPage extends StatelessWidget {
  final WorkoutHistory history;
  final Function refreshWorkoutHistory;

  HistoryViewPage({this.history, this.refreshWorkoutHistory});

  Future<bool> _refreshWorkouts() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadWorkouts,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<Workout> _workouts = data;

      globals.workouts = _workouts;

      receivePort.close();
      isolate.kill();
      isolate = null;
    });

    bool isCompleted = false;

    await Future.doWhile(() async {
      return await Future.delayed(Duration(milliseconds: 500), () {
        return isolate != null;
      });
    });

    return isCompleted;
  }

  static void _loadWorkouts(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<Workout> workouts = await Database(uid: _uid).getWorkouts() ?? [];

    _sendPort.send(workouts);
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context);

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

                        ScaffoldMessenger.of(context)
                            .showSnackBar(savingSnackbar);

                        workout.id = history.id;
                        workout.name = history.name;
                        workout.workoutNote = history.workoutNote;
                        workout.exercises = history.exercises;

                        bool isSaved = await Database(uid: globals.uid)
                            .addWorkout(workout, globals.workouts);

                        if (isSaved) {
                          await _refreshWorkouts();

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context)
                              .showSnackBar(saveSuccessSnackbar);
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context)
                              .showSnackBar(saveFailSnackbar);
                        }
                      } else if (selection == 'delete') {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(deletingSnackbar);

                        bool isDeleted = await Database(uid: globals.uid)
                            .deleteWorkoutHistory(
                                globals.workoutHistory, history.id);

                        if (isDeleted) {
                          await refreshWorkoutHistory();

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context)
                              .showSnackBar(deleteSuccessSnackbar);

                          Future.delayed(
                            Duration(milliseconds: 1000),
                            () {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              popContextWhenPossible(context);
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context)
                              .showSnackBar(deleteFailedSnackbar);
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
                          Text(getTotalWeightLifted(
                                history.exercises,
                                history.weightUnit,
                                globals.settings.weightUnit,
                              ) +
                              globals.settings.weightUnit)
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
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${history.exercises[index].name} (${getExerciseTotalWeightLifted(history.exercises[index].sets, history.weightUnit, globals.settings.weightUnit)}${globals.settings.weightUnit})",
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
                                  getExerciseSet(
                                    i + 1,
                                    history.exercises[index].sets[i],
                                    history.weightUnit,
                                    globals.settings.weightUnit,
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

            Navigator.pushReplacement(
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
