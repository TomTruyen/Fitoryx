import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showRestDialog(
  BuildContext context,
  WorkoutChangeNotifier workout,
  Exercise _exercise,
) async {
  bool enabled = _exercise.restEnabled;
  int seconds = _exercise.restSeconds;

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
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
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
                            const Expanded(
                              child: Text(
                                'Enabled',
                              ),
                            ),
                            Flexible(
                              child: Switch(
                                activeColor: Colors.blueAccent[700],
                                value: enabled,
                                onChanged: (bool value) {
                                  setState(() {
                                    enabled = !enabled;
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
                            margin: const EdgeInsets.only(top: 16.0),
                            height: 100.0,
                            child: Opacity(
                              opacity: enabled ? 1 : 0.5,
                              child: AbsorbPointer(
                                absorbing: !enabled,
                                child: CupertinoPicker(
                                  selectionOverlay: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  scrollController: FixedExtentScrollController(
                                    initialItem: (seconds ~/ 5) - 1,
                                  ),
                                  squeeze: 1.0,
                                  looping: true,
                                  diameterRatio: 100.0,
                                  itemExtent: 40.0,
                                  onSelectedItemChanged: (int index) {
                                    seconds = 5 + (index * 5);
                                  },
                                  useMagnifier: true,
                                  magnification: 1.5,
                                  children: <Widget>[
                                    for (int i = 5; i <= 300; i += 5)
                                      Center(
                                        child: Text(
                                          '${(i / 60).floor()}:${(i % 60).toString().padLeft(2, "0")}',
                                          style: const TextStyle(
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
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              _exercise.restEnabled = enabled;
                              _exercise.restSeconds = seconds;

                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
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
