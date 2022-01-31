import 'package:fitoryx/utils/int_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<int> showTimeDialog(
  BuildContext context,
  int? time, {
  int interval = 10,
  int max = 3590,
}) async {
  bool shouldUpdate = false;
  int newTime = time ?? 5;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.width * 0.2,
                maxHeight: MediaQuery.of(context).size.width * 0.6,
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                            initialItem: (newTime ~/ interval),
                          ),
                          squeeze: 1.0,
                          looping: true,
                          diameterRatio: 100.0,
                          itemExtent: 40.0,
                          onSelectedItemChanged: (int index) {
                            int seconds = 0 + (index * interval);

                            newTime = seconds;
                          },
                          useMagnifier: true,
                          magnification: 1.5,
                          children: <Widget>[
                            for (int i = 0; i <= max; i += interval)
                              Center(
                                child: Text(
                                  '${(i / 60).floor()}:${(i % 60).withZeroPadding()}',
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
                            shouldUpdate = true;
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  if (shouldUpdate) return newTime;

  return time!;
}
