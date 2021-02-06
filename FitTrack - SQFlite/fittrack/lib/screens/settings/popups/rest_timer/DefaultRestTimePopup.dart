// Flutter Packages
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupDefaultRestTime(
  BuildContext context,
  Function updateSettings,
  Settings settings,
) async {
  int defaultRestTime = settings.defaultRestTime;

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
                            'Timer increment value',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      // rest timer slider thing here
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              Settings newSettings = settings.clone();
                              newSettings.defaultRestTime = defaultRestTime;

                              dynamic result = await globals.sqlDatabase
                                  .updateSettings(newSettings);

                              if (result != null) {
                                updateSettings(newSettings);
                                tryPopContext(context);
                              } else {
                                showPopupError(
                                  context,
                                  'Failed to update timer',
                                  'Something went wrong updating the timer increment value. Please try again.',
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
