import 'dart:async';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/screens/workout/popups/EndWorkoutWarningPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

class WorkoutStartPage extends StatefulWidget {
  final Workout workout;

  WorkoutStartPage({this.workout});

  @override
  _WorkoutStartPageState createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  bool isStarted = false;

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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.workout.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.schedule,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        timeToDisplay,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () async {
                if (isStarted) {
                  bool isCompleted = widget.workout.isWorkoutCompleted();

                  if (!isCompleted) {
                    bool confirmsCompletion =
                        await showEndWorkoutWarningDialog(context, true);

                    if (confirmsCompletion) {
                      endWorkout();
                      tryPopContext(context);
                    }
                  } else {
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
            child: Container(
              height: 60.0,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  isStarted ? 'End Workout' : 'Start Workout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: isStarted ? Colors.red : Theme.of(context).accentColor,
                onPressed: () async {
                  if (!isStarted) {
                    startWorkout();
                  } else {
                    bool isCompleted = widget.workout.isWorkoutCompleted();

                    if (!isCompleted) {
                      bool confirmsCompletion =
                          await showEndWorkoutWarningDialog(context, false);

                      if (confirmsCompletion) {
                        endWorkout();
                      }
                    } else {
                      endWorkout();
                    }
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
                                child: Text(
                                  _exercise.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ),
                            if (_exercise.restEnabled == 1)
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.schedule,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      "${_exercise.restSeconds ~/ 60}:${(_exercise.restSeconds % 60).toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    )
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
                                  widget.workout.weightUnit.toUpperCase(),
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
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (i + 1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
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
                                        _exercise.sets[i].weight?.toString(),
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.black),
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
                                        _exercise.sets[i].reps?.toString(),
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.black),
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
