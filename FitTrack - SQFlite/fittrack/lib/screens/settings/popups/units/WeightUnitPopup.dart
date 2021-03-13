import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/material.dart';

Future<void> showPopupWeightUnit(
  BuildContext context,
  Settings settings,
  Function updateSettings,
) async {
  String weightUnit = settings.weightUnit;

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
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Weight Unit',
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
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Radio(
                                            activeColor: Colors.blue[700],
                                            value: 'kg',
                                            groupValue: weightUnit,
                                            onChanged: (String value) {
                                              setState(() {
                                                weightUnit = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Metric (kg)',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      weightUnit = 'kg';
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Radio(
                                            activeColor: Colors.blue[700],
                                            groupValue: weightUnit,
                                            value: 'lbs',
                                            onChanged: (String value) {
                                              setState(() {
                                                weightUnit = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Imperial (lbs)',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      weightUnit = 'lbs';
                                    });
                                  },
                                ),
                              ],
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
                              onPressed: () async {
                                Settings newSettings = settings.clone();
                                newSettings.weightUnit = weightUnit;
                                newSettings.updateUserWeights(weightUnit);

                                dynamic updateResult = await globals.sqlDatabase
                                    .updateUserWeightUnit(
                                  newSettings.userWeight,
                                );

                                dynamic result = await globals.sqlDatabase
                                    .updateSettings(newSettings);

                                if (result != null && updateResult != null) {
                                  updateSettings(newSettings);
                                  await globals.sqlDatabase
                                      .fetchUpdatedWeights();
                                  tryPopContext(context);
                                } else {
                                  tryPopContext(context);

                                  showPopupError(
                                    context,
                                    'Failed to update',
                                    'Something went wrong updating your weight unit. Please try again.',
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
            ),
          );
        },
      );
    },
  );
}
