import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutTimer extends StatefulWidget {
  final Function getIsStarted;
  final Function updateTime;

  WorkoutTimer({this.getIsStarted, this.updateTime});

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
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

    String newTimeToDisplay = timeToDisplay;
    if (stopwatch.elapsed.inHours < 1) {
      newTimeToDisplay =
          (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
              ":" +
              (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    } else {
      newTimeToDisplay = stopwatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    }

    widget.updateTime(newTimeToDisplay, stopwatch.elapsed.inMilliseconds);

    setState(() {
      timeToDisplay = newTimeToDisplay;
    });
  }

  void startWorkout() {
    stopwatch.start();
    startTimer();
  }

  void endWorkout() {
    stopwatch.stop();
  }

  void updateTime() {
    bool isStarted = widget.getIsStarted();

    if (isStarted) {
      if (!stopwatch.isRunning) {
        startWorkout();
      }
    } else {
      endWorkout();
    }
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
    updateTime();

    return Container(
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
    );
  }
}
