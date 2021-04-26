// Dart Packages
import 'dart:math';

// Flutter Packages
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:vibration/vibration.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class WorkoutStartTimerPage extends StatefulWidget {
  final int restSeconds;

  WorkoutStartTimerPage({this.restSeconds = 60});

  @override
  _WorkoutStartTimerPageState createState() =>
      _WorkoutStartTimerPageState(restSeconds: this.restSeconds);
}

class _WorkoutStartTimerPageState extends State<WorkoutStartTimerPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  int elapsedSeconds = 0;
  int restSeconds;

  // Disable - incrementValue Button, if not updated by clicking
  bool canDecrementValue = true;

  // Settings (Database)
  bool vibrateUponFinish = globals.settings.isVibrateUponFinishEnabled;
  int timerIncrementValue = globals.settings.timerIncrementValue;

  // Vibrate Variables
  int vibrateCheckSeconds = 60;

  _WorkoutStartTimerPageState({this.restSeconds});

  void _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 1000);
    }
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;

    if (duration.inSeconds <= timerIncrementValue) {
      if (canDecrementValue) {
        Future.delayed(
          Duration(milliseconds: 100),
          () => {
            setState(
              () {
                canDecrementValue = false;
              },
            )
          },
        );
      }
    } else {
      if (!canDecrementValue) {
        Future.delayed(
          Duration(milliseconds: 100),
          () => {
            setState(
              () {
                canDecrementValue = true;
              },
            )
          },
        );
      }
    }

    if (vibrateUponFinish &&
        duration.inSeconds != vibrateCheckSeconds &&
        duration.inSeconds <= 5 &&
        duration.inSeconds % 2 != 0) {
      vibrateCheckSeconds = duration.inSeconds;
      _vibrate();
    }

    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: restSeconds),
    );

    if (!controller.isAnimating) {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }

    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        popContextWhenPossible(context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text('Rest timer'),
            ),
            SliverFillRemaining(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  color: Colors.grey[300],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return Text(
                              timerString,
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '-$timerIncrementValue SEC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: controller.duration.inSeconds <=
                                      timerIncrementValue ||
                                  !canDecrementValue
                              ? Colors.grey[500]
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: controller.duration.inSeconds <=
                                timerIncrementValue ||
                            !canDecrementValue
                        ? null
                        : () {
                            setState(() {
                              if (controller.duration.inSeconds -
                                      timerIncrementValue <=
                                  0) {
                                popContextWhenPossible(context);
                              } else {
                                controller.duration = new Duration(
                                  seconds: (controller.duration.inSeconds -
                                      timerIncrementValue),
                                );

                                elapsedSeconds +=
                                    controller.lastElapsedDuration.inSeconds;

                                double value = 1 -
                                    (elapsedSeconds /
                                        controller.duration.inSeconds);

                                controller.reverse(
                                  from: controller.value == 0.0 ? 1.0 : value,
                                );
                              }
                            });
                          },
                  );
                }),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '+$timerIncrementValue SEC',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                controller.duration = new Duration(
                  seconds:
                      (controller.duration.inSeconds + timerIncrementValue),
                );

                elapsedSeconds += controller.lastElapsedDuration.inSeconds;

                double value =
                    1 - (elapsedSeconds / controller.duration.inSeconds);

                controller.reverse(
                  from: controller.value == 0.0 ? 1.0 : value,
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  popContextWhenPossible(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
