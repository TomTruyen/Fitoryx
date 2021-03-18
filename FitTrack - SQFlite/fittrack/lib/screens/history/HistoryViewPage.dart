import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/screens/history/popups/DeleteHistoryPopup.dart';
import 'package:fittrack/screens/workout/WorkoutStartPage.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/shared/WorkoutExerciseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryViewPage extends StatelessWidget {
  final Workout workout;
  final Function updateWorkoutsHistory;
  final bool isHistory;

  HistoryViewPage({
    this.workout,
    this.updateWorkoutsHistory,
    this.isHistory = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
            title: Text(
              workout.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: isHistory
                ? <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: Color.fromRGBO(35, 35, 35, 1),
                        dividerColor: Color.fromRGBO(70, 70, 70, 1),
                      ),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        icon: Icon(Icons.more_vert, color: Colors.black),
                        onSelected: (selection) async {
                          if (selection == 'template') {
                            dynamic result =
                                globals.sqlDatabase.addWorkout(workout.clone());

                            if (result != null) {
                              await globals.sqlDatabase.fetchWorkouts();

                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      WorkoutStartPage(
                                    workout:
                                        globals.sqlDatabase.workouts[0].clone(),
                                  ),
                                ),
                              );
                            } else {
                              showPopupError(
                                context,
                                'Failed to save',
                                'Something went wrong saving history as a workout. Please try again.',
                              );
                            }
                          } else if (selection == 'delete') {
                            bool isDeleted = await showPopupDeleteHistory(
                              context,
                              workout.id,
                              updateWorkoutsHistory,
                            );

                            if (isDeleted) {
                              tryPopContext(context);
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuItem>[
                          PopupMenuItem(
                            height: 40.0,
                            value: 'template',
                            child: Text(
                              'Save as workout',
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
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
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getFormattedDateTimeFromMillisecondsSinceEpoch(
                      workout.timeInMillisSinceEpoch,
                    ),
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize:
                          Theme.of(context).textTheme.bodyText2.fontSize * 1.2,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Duration: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: workout.duration,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Total Volume: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: tryConvertDoubleToInt(workout.getTotalVolume())
                                  .toString() +
                              " " +
                              globals.sqlDatabase.settings.weightUnit,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Note: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: workout.note != "" ? workout.note : "/",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Exercise _exercise = workout.exercises[index];

                if (_exercise.type == 'weight') {
                  return WorkoutExerciseWidget(
                    exercise: _exercise,
                    workout: workout,
                    exerciseIndex: index,
                    isTime: false,
                    isStart: false,
                    isHistory: true,
                  );
                } else {
                  return WorkoutExerciseWidget(
                    exercise: _exercise,
                    workout: workout,
                    exerciseIndex: index,
                    isTime: true,
                    isStart: false,
                    isHistory: true,
                  );
                }
              },
              childCount: workout.exercises.length,
            ),
          ),
        ],
      ),
    );
  }
}
