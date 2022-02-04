import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<int> showAmountPicker(
  BuildContext context, {
  required String title,
  required int goal,
  required int amount,
}) async {
  bool shouldUpdate = false;
  int newGoal = goal;

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
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
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
                          initialItem: newGoal - 1,
                        ),
                        squeeze: 1.0,
                        looping: true,
                        diameterRatio: 100.0,
                        itemExtent: 40.0,
                        onSelectedItemChanged: (int index) {
                          newGoal = index + 1;
                        },
                        useMagnifier: true,
                        magnification: 1.5,
                        children: <Widget>[
                          for (int i = 0; i < amount; i++)
                            Center(
                              child: Text(
                                (i + 1).toString(),
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            )
                        ],
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

  if (shouldUpdate) {
    return newGoal;
  }

  return goal;
}
