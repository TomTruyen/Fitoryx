import 'dart:async';
import 'package:fittrack/screens/history/HistoryViewPage.dart';
import 'package:fittrack/screens/workout/WorkoutRestTimerPage.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/GradientIcon.dart';
import 'package:fittrack/shared/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/screens/workout/popups/EndWorkoutWarningPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/shared/GradientButton.dart';

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
  Stopwatch stopwatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void startTimer() {
    Timer(duration, keepRunning);

    setState(() {
      isStarted = true;
    });
  }

  void stopTimer() {
    setState(() {
      isStarted = false;
    });
  }

  void keepRunning() {
    if (stopwatch.isRunning) {
      startTimer();
    }

    setState(() {
      if (stopwatch.elapsed.inHours < 1) {
        timeToDisplay =
            (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
                ":" +
                (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      } else {
        timeToDisplay = stopwatch.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      }
    });
  }

  void startWorkout() {
    stopwatch.start();
    startTimer();
  }

  void endWorkout() {
    stopwatch.stop();
    stopTimer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    stopwatch.stop();

    super.dispose();
  }

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
            actions: stopwatch.elapsed.inMilliseconds > 0
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
                        if (stopwatch.elapsed.inMilliseconds > 0) {
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
                              stopwatch.elapsed.inMilliseconds,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            timeToDisplay,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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

                return Card(
                  key: UniqueKey(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: GradientText(
                                  text: _exercise.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (_exercise.restEnabled == 1)
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: <Widget>[
                                    GradientIcon(
                                      icon: Icon(Icons.schedule),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    GradientText(
                                      text:
                                          "${_exercise.restSeconds ~/ 60}:${(_exercise.restSeconds % 60).toString().padLeft(2, '0')}",
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (_exercise.hasNotes == 1)
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              16.0,
                              0.0,
                              16.0,
                              12.0,
                            ),
                            child: TextFormField(
                              autofocus: false,
                              maxLines: null,
                              initialValue: _exercise.notes,
                              decoration: InputDecoration(
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
                                _exercise.notes = value;
                              },
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'SET',
                                  style: TextStyle(fontSize: 11.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  globals.sqlDatabase.settings.weightUnit
                                      .toUpperCase(),
                                  style: TextStyle(fontSize: 11.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'REPS',
                                  style: TextStyle(fontSize: 11.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Spacer(flex: 1),
                            ],
                          ),
                        ),
                        for (int i = 0; i < _exercise.sets.length; i++)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: GradientText(
                                    text: (i + 1).toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      initialValue: _exercise.sets[i].weight
                                              ?.toString() ??
                                          '0.0',
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: '50',
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
                                        contentPadding: EdgeInsets.all(6.0),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      initialValue:
                                          _exercise.sets[i].reps?.toString() ??
                                              '0',
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: '10',
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
                                        contentPadding: EdgeInsets.all(6.0),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: AbsorbPointer(
                                    absorbing: !isStarted,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 2.0),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          color: _exercise.sets[i].isCompleted
                                              ? Colors.green[400]
                                              : null,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: _exercise.sets[i].isCompleted
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        if (isStarted) {
                                          if (_exercise.restEnabled == 1 &&
                                              !_exercise.sets[i].isCompleted) {
                                            if (globals.sqlDatabase.settings
                                                    .isRestTimerEnabled ==
                                                1) {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  fullscreenDialog: true,
                                                  builder:
                                                      (BuildContext context) =>
                                                          WorkoutRestTimerPage(
                                                    restSeconds:
                                                        _exercise.restSeconds,
                                                  ),
                                                ),
                                              );
                                            }
                                          }

                                          setState(() {
                                            _exercise.sets[i].isCompleted =
                                                !_exercise.sets[i].isCompleted;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              childCount: widget.workout.exercises.length,
            ),
          )
        ],
      ),
    );
  }
}
