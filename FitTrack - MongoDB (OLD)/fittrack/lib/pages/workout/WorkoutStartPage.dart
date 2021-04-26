// Dart Packages
import 'dart:async';
import 'dart:isolate';

// Flutter Packages
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:provider/provider.dart';

// My Packages
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/misc/workouts/WorkoutViewPageFunctions.dart';
import 'package:fittrack/pages/workout/popups/WorkoutNotCompletedPopup.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/shared/Snackbars.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class WorkoutStartPage extends StatefulWidget {
  @override
  _WorkoutStartPageState createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  WorkoutChangeNotifier workout;

  String timeToDisplay = "00:00";
  Stopwatch stopwatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void startTimer() {
    Timer(duration, keepRunning);
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

  @override
  void initState() {
    super.initState();

    stopwatch.start();
    startTimer();
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

  void toggleWorkoutComplete(int index, int setIndex) {
    setState(() {
      workout.exercises[index].sets[setIndex].setComplete =
          !workout.exercises[index].sets[setIndex].setComplete;
    });
  }

  Future<bool> refreshWorkoutHistory() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadWorkoutHistory,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<WorkoutHistory> _workoutHistory = data;

      globals.workoutHistory = _workoutHistory;

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

  static void _loadWorkoutHistory(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<WorkoutHistory> workouts =
        await Database(uid: _uid).getWorkoutHistory() ?? [];

    _sendPort.send(workouts);
  }

  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout =
        Provider.of<WorkoutChangeNotifier>(context);

    if (workout == null && _workout != null) {
      workout = _workout;
    }

    return _WorkoutStartPageView(this);
  }
}

class _WorkoutStartPageView extends StatelessWidget {
  final _WorkoutStartPageState state;

  _WorkoutStartPageView(this.state);

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout = state.workout;
    final String _timeToDisplay = state.timeToDisplay;

    final Function _refreshWorkoutHistory = state.refreshWorkoutHistory;

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
              title: Text('Workout'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    if (_workout.finishedWorkout()) {
                      state.stopwatch.stop();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        savingSnackbar,
                      );

                      bool isSaved = await Database(uid: globals.uid)
                          .finishWorkout(_workout, _timeToDisplay);

                      if (isSaved) {
                        await _refreshWorkoutHistory();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          saveSuccessSnackbar,
                        );

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          saveFailSnackbar,
                        );
                      }
                    } else {
                      workoutNotCompletedPopup(context);
                    }
                  },
                ),
              ],
            ),
            SliverFillRemaining(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        _workout.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(_timeToDisplay),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: TextFormField(
                        autofocus: false,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Workout note',
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
                          _workout.workoutNote = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _workout.exercises.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: index > 0
                                ? EdgeInsets.symmetric(vertical: 24.0)
                                : EdgeInsets.only(bottom: 24.0),
                            child: buildWorkoutExercises(
                              context,
                              _workout,
                              index,
                              state.toggleWorkoutComplete,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
