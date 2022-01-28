import 'package:fitoryx/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<int> showTimeDialog(
  BuildContext context,
  int? time,
) async {
  int timeInSeconds = time ?? 5;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 16.0),
                            height: 100.0,
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
                                initialItem: (timeInSeconds ~/ 10),
                              ),
                              squeeze: 1.0,
                              looping: true,
                              diameterRatio: 100.0,
                              itemExtent: 40.0,
                              onSelectedItemChanged: (int index) {
                                int seconds = 0 + (index * 10);

                                timeInSeconds = seconds;
                              },
                              useMagnifier: true,
                              magnification: 1.5,
                              children: <Widget>[
                                for (int i = 0; i <= 3590; i += 10)
                                  Center(
                                    child: Text(
                                      '${(i / 60).floor()}:${addZeroPadding(i % 60)}',
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

  return timeInSeconds;
}
