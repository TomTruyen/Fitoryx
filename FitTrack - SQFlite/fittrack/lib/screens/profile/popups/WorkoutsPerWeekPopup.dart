import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showWorkoutsPerWeekPopup(
  BuildContext context,
  Settings settings,
  Function updateSettings,
) async {
  int goal = settings.workoutsPerWeekGoal ?? 7;

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
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Material(
                  color: Colors.grey[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Edit goal',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(top: 16.0),
                            height: 100.0,
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: goal - 1,
                              ),
                              squeeze: 1.0,
                              looping: true,
                              diameterRatio: 100.0,
                              itemExtent: 40.0,
                              onSelectedItemChanged: (int index) {
                                goal = index + 1;
                              },
                              useMagnifier: true,
                              magnification: 1.5,
                              children: <Widget>[
                                for (int i = 0; i < 7; i++)
                                  Center(
                                    child: Text(
                                      (i + 1).toString(),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              Settings newSettings = settings.clone();
                              newSettings.workoutsPerWeekGoal = goal;

                              dynamic result = await globals.sqlDatabase
                                  .updateSettings(newSettings);

                              if (result != null) {
                                updateSettings(newSettings);
                                tryPopContext(context);
                              } else {
                                showPopupError(
                                  context,
                                  'Failed to edit goal',
                                  'Something went wrong updating the workouts per week goal. Please try again.',
                                );
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
