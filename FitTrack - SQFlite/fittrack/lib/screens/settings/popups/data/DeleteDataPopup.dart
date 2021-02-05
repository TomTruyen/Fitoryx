// Flutter Packages
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupDeleteData(
  BuildContext context,
  Function updateSettings,
) async {
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
                color: Colors.grey[50],
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
                            'Delete all data',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
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
                              'Are you sure you want to delete all data from your account?',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  dynamic result =
                                      globals.sqlDatabase.resetDatabase();

                                  if (result != null) {
                                    Settings newSettings = new Settings();
                                    updateSettings(newSettings);

                                    tryPopContext(context);
                                  } else {
                                    tryPopContext(context);

                                    showPopupError(
                                      context,
                                      'Failed to delete data',
                                      'Something went wrong deleting your date. Please try again.',
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
}
