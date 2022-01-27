import 'dart:async';

import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:flutter/material.dart';

class WorkoutTimer extends StatefulWidget {
  final bool started;
  final WorkoutChangeNotifier workout;

  const WorkoutTimer({Key? key, required this.started, required this.workout})
      : super(key: key);

  @override
  State<WorkoutTimer> createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  String _time = "00:00";
  final Stopwatch _stopwatch = Stopwatch();
  final _duration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopwatch.stop();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _startTimer() {
    Timer(_duration, _keepRunning);
  }

  void _keepRunning() {
    if (_stopwatch.isRunning) {
      _startTimer();
    }

    String newTime =
        "${addZeroPadding(_stopwatch.elapsed.inMinutes % 60)}:${addZeroPadding(_stopwatch.elapsed.inSeconds % 60)}";

    if (_stopwatch.elapsed.inHours >= 1) {
      newTime = "${addZeroPadding(_stopwatch.elapsed.inHours % 60)}:$newTime";
    }

    widget.workout.duration = newTime;

    setState(() {
      _time = newTime;
    });
  }

  void _startWorkout() {
    _stopwatch.start();
    _startTimer();
  }

  void _endWorkout() {
    _stopwatch.stop();
  }

  void _updateTime() {
    if (widget.started) {
      if (!_stopwatch.isRunning) {
        _startWorkout();
      }
    } else {
      _endWorkout();
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateTime();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 2.0,
      ),
      child: Text(
        _time,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
