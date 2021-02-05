import 'package:flutter/material.dart';

import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Future<bool> showPopupDeleteHistory(
  BuildContext context,
  int id,
  Function updateWorkoutsHistory,
) async {
  bool isDeleted = false;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[100],
                border: Border.all(
                  width: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Color.fromRGBO(70, 70, 70, 1),
                  unselectedWidgetColor: Color.fromRGBO(
                    200,
                    200,
                    200,
                    1,
                  ),
                ),
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
                            'Are you sure?',
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Are you sure you want to delete this workout from your history?',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  tryPopContext(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  dynamic result = await globals.sqlDatabase
                                      .deleteWorkoutHistory(id);

                                  if (result != null) {
                                    await updateWorkoutsHistory();

                                    isDeleted = true;

                                    tryPopContext(context);
                                  } else {
                                    tryPopContext(context);

                                    showPopupError(
                                      context,
                                      'Failed to delete',
                                      'Something went wrong deleting this history. Please try again.',
                                    );
                                  }
                                },
                              ),
                            ],
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

  return isDeleted;
}
