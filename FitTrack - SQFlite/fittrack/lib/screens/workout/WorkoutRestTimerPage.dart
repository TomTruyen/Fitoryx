import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class WorkoutRestTimerPage extends StatefulWidget {
  final int restSeconds;

  WorkoutRestTimerPage({this.restSeconds = 60});

  @override
  _WorkoutRestTimerPageState createState() => _WorkoutRestTimerPageState();
}

class _WorkoutRestTimerPageState extends State<WorkoutRestTimerPage>
    with TickerProviderStateMixin {
  int timeLeftSeconds;
  Timer timer;

  void vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 1000);
    }
  }

  String get timerString {
    int minutes = timeLeftSeconds ~/ 60;
    int seconds = timeLeftSeconds % 60;

    // vibrate here for last 5 seconds, every other second
    if (timeLeftSeconds <= 5 && timeLeftSeconds % 2 != 0) {
      if (globals.sqlDatabase.settings.isVibrateUponFinishEnabled == 1) {
        vibrate();
      }
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timeLeftSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          timeLeftSeconds--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    timeLeftSeconds = widget.restSeconds;

    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey[50],
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  tryPopContext(context);
                },
              ),
              title: Text(
                'Rest Timer',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: FractionalOffset.center,
                child: Align(
                  alignment: FractionalOffset.center,
                  child: Text(
                    timerString,
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
