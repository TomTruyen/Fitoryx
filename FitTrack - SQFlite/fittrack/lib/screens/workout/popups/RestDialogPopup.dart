import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showRestDialog(
  BuildContext context,
  WorkoutChangeNotifier workout,
  Exercise _exercise,
) async {
  int currentExerciseRestEnabled =
      _exercise.restEnabled ?? globals.sqlDatabase.settings.isRestTimerEnabled;
  int currentExerciseRestSeconds =
      _exercise.restSeconds ?? globals.sqlDatabase.settings.defaultRestTime;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[50],
                  border: Border.all(
                    width: 0,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                child: Material(
                  color: Colors.grey[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Enabled',
                              ),
                            ),
                            Flexible(
                              child: Switch(
                                activeColor: Colors.blueAccent[700],
                                value: currentExerciseRestEnabled == 1
                                    ? true
                                    : false,
                                onChanged: (bool value) {
                                  setState(() {
                                    currentExerciseRestEnabled = value ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(top: 16.0),
                            height: 100.0,
                            child: Opacity(
                              opacity:
                                  currentExerciseRestEnabled == 1 ? 1 : 0.5,
                              child: AbsorbPointer(
                                absorbing: currentExerciseRestEnabled == 0,
                                child: CupertinoPicker(
                                  selectionOverlay: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey[200],
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.grey[200],
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  scrollController: FixedExtentScrollController(
                                    initialItem:
                                        (currentExerciseRestSeconds ~/ 5) - 1,
                                  ),
                                  squeeze: 1.0,
                                  looping: true,
                                  diameterRatio: 100.0,
                                  itemExtent: 40.0,
                                  onSelectedItemChanged: (int index) {
                                    int seconds = 5 + (index * 5);

                                    currentExerciseRestSeconds = seconds;
                                  },
                                  useMagnifier: true,
                                  magnification: 1.5,
                                  children: <Widget>[
                                    for (int i = 5; i <= 300; i += 5)
                                      Center(
                                        child: Text(
                                          '${(i / 60).floor()}:${(i % 60).toString().padLeft(2, "0")}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              _exercise.restEnabled =
                                  currentExerciseRestEnabled;
                              _exercise.restSeconds =
                                  currentExerciseRestSeconds;

                              tryPopContext(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
