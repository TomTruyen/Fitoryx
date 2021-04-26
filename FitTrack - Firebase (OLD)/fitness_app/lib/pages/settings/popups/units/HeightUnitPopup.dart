import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/material.dart';

Future<void> showPopupHeightUnit(
  User user,
  UserSettings settings,
  BuildContext context,
) async {
  String heightUnit = 'metric';

  if (settings != null) {
    heightUnit = settings.heightUnit;
  }

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 250.0,
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50],
                border: Border.all(
                  width: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: SingleChildScrollView(
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
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Height Unit',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Radio(
                                    value: 'metric',
                                    groupValue: heightUnit,
                                    onChanged: (String value) {
                                      setState(() {
                                        heightUnit = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Metric (cm)',
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
                              heightUnit = 'metric';
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
                                    groupValue: heightUnit,
                                    value: 'imperial',
                                    onChanged: (String value) {
                                      setState(() {
                                        heightUnit = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Imperial (ft)',
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
                              heightUnit = 'imperial';
                            });
                          },
                        ),
                        Container(
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
                              settings.heightUnit = heightUnit;

                              settings.heightHistory.forEach((height) {
                                if (height['heightUnit'] != heightUnit) {
                                  height['heightUnit'] = heightUnit;
                                  height['height'] = recalculateHeights(
                                      double.parse(height['height'].toString()),
                                      heightUnit);
                                }
                              });

                              dynamic result = await DatabaseService(
                                      uid: user != null ? user.uid : '')
                                  .updateSettings(settings);

                              if (result != null) {
                                popContextWhenPossible(context);
                              }
                            },
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
