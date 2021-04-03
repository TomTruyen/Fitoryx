import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/settings/SettingsProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showPopupMissingFoodCalculateRequirements(
  BuildContext context,
  List<String> missingRequirements,
  Settings settings,
  Function updateSettings,
) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Container(
                width: 250.0,
                height: 325.0,
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
                              'Missing requirements',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Update your profile with the following requirements and try again.',
                                ),
                                for (int i = 0;
                                    i < missingRequirements.length;
                                    i++)
                                  Text(missingRequirements[i]),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  tryPopContext(context);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  tryPopContext(context);

                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          SettingsProfilePage(
                                        updateSettings: updateSettings,
                                        settings: settings,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
