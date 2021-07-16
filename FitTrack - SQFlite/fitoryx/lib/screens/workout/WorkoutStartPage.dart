import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/exercises/Exercise.dart';
import 'package:Fitoryx/models/exercises/ExerciseSet.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:Fitoryx/screens/history/HistoryViewPage.dart';
import 'package:Fitoryx/screens/workout/WorkoutTimer.dart';
import 'package:Fitoryx/screens/workout/popups/EndWorkoutWarningPopup.dart';
import 'package:Fitoryx/shared/ErrorPopup.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:Fitoryx/shared/GradientButton.dart';
import 'package:Fitoryx/shared/WorkoutExerciseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutStartPage extends StatefulWidget {
  final Workout workout;

  WorkoutStartPage({this.workout});

  @override
  _WorkoutStartPageState createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  bool isStarted = false;

  String workoutNote = "";

  String timeToDisplay = "00:00";
  int durationMilliseconds = 0;

  void updateTime(String newTimeToDisplay, int newDurationMilliseconds) {
    timeToDisplay = newTimeToDisplay;
    durationMilliseconds = newDurationMilliseconds;
  }
  // Stopwatch stopwatch = Stopwatch();
  // final duration = const Duration(seconds: 1);

  bool getIsStarted() {
    return isStarted;
  }

  void toggleCompleted(ExerciseSet exerciseSet) {
    setState(() {
      exerciseSet.isCompleted = !exerciseSet.isCompleted;
    });
  }

  void startWorkout() {
    setState(() => isStarted = true);
  }

  void endWorkout() {
    setState(() => isStarted = false);
  }

  // void startTimer() {
  //   Timer(duration, keepRunning);
  //
  //   setState(() {
  //     isStarted = true;
  //   });
  // }
  //
  // void stopTimer() {
  //   setState(() {
  //     isStarted = false;
  //   });
  // }
  //
  // void keepRunning() {
  //   if (stopwatch.isRunning) {
  //     startTimer();
  //   }
  //
  //   setState(() {
  //     if (stopwatch.elapsed.inHours < 1) {
  //       timeToDisplay =
  //           (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
  //               ":" +
  //               (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
  //     } else {
  //       timeToDisplay = stopwatch.elapsed.inHours.toString().padLeft(2, "0") +
  //           ":" +
  //           (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
  //           ":" +
  //           (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
  //     }
  //   });
  // }
  //
  // void startWorkout() {
  //   stopwatch.start();
  //   startTimer();
  // }
  //
  // void endWorkout() {
  //   stopwatch.stop();
  //   stopTimer();
  // }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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
            title: Text(
              widget.workout.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: isStarted
                ? <Widget>[
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'FINISH',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (isStarted) {
                          bool navigateToSummaryPage = false;

                          bool isCompleted =
                              widget.workout.isWorkoutCompleted();

                          if (!isCompleted) {
                            bool confirmsCompletion =
                                await showEndWorkoutWarningDialog(
                                    context, false);

                            if (confirmsCompletion) {
                              endWorkout();
                              navigateToSummaryPage = true;
                            }
                          } else {
                            endWorkout();
                            navigateToSummaryPage = true;
                          }

                          if (navigateToSummaryPage) {
                            dynamic result =
                                await globals.sqlDatabase.saveWorkout(
                              widget.workout.clone(),
                              durationMilliseconds,
                              timeToDisplay,
                              workoutNote,
                            );

                            if (result != null) {
                              await globals.sqlDatabase.fetchWorkoutsHistory();

                              Workout _workout =
                                  globals.sqlDatabase.workoutsHistory[0];

                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      HistoryViewPage(
                                    workout: _workout,
                                    isHistory: false,
                                  ),
                                ),
                              );
                            } else {
                              showPopupError(
                                context,
                                'Saving workout failed',
                                'Something went wrong saving your workout. Please try again.',
                              );
                            }
                          }
                        } else {
                          showPopupError(
                            context,
                            'Workout not started',
                            'Please start the workout before attempting to finish it.',
                          );
                        }
                      },
                    ),
                  ]
                : [],
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () async {
                if (isStarted) {
                  bool confirmsCancel =
                      await showEndWorkoutWarningDialog(context, true);

                  if (confirmsCancel) {
                    endWorkout();
                    tryPopContext(context);
                  }
                } else {
                  tryPopContext(context);
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: isStarted
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            widget.workout.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        WorkoutTimer(
                          getIsStarted: getIsStarted,
                          updateTime: updateTime,
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(
                        //     horizontal: 4.0,
                        //     vertical: 2.0,
                        //   ),
                        //   child: Text(
                        //     timeToDisplay,
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          autofocus: false,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Workout Note',
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(8.0),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            workoutNote = value;
                          },
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: GradientButton(
                      text: 'Start Workout',
                      onPressed: () {
                        if (!isStarted) {
                          startWorkout();
                        }
                      },
                    ),
                  ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Exercise _exercise = widget.workout.exercises[index];

                if (_exercise.type == 'weight') {
                  return WorkoutExerciseWidget(
                    exercise: _exercise,
                    workout: widget.workout,
                    exerciseIndex: index,
                    isTime: false,
                    isStart: true,
                    getIsStarted: getIsStarted,
                    toggleCompleted: toggleCompleted,
                  );
                } else {
                  return WorkoutExerciseWidget(
                    exercise: _exercise,
                    workout: widget.workout,
                    exerciseIndex: index,
                    isTime: true,
                    isStart: true,
                    getIsStarted: getIsStarted,
                    toggleCompleted: toggleCompleted,
                  );
                }
              },
              childCount: widget.workout.exercises.length,
            ),
          )
        ],
      ),
    );
  }
}
