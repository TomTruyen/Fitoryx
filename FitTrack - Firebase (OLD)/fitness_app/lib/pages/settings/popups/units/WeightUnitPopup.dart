import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/material.dart';

Future<void> showPopupWeightUnit(
  User user,
  UserSettings settings,
  BuildContext context,
  List<WorkoutStreamProvider> workouts,
  List<WorkoutHistory> workoutHistory,
) async {
  String weightUnit = 'metric';

  if (settings != null) {
    weightUnit = settings.weightUnit;
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
                            'Weight Unit',
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
                              weightUnit = 'metric';
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
                                    groupValue: weightUnit,
                                    value: 'imperial',
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
                              weightUnit = 'imperial';
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
                              settings.weightUnit = weightUnit;

                              settings.weightHistory.forEach((weight) {
                                if (weight['weightUnit'] != weightUnit) {
                                  weight['weightUnit'] = weightUnit;
                                  weight['weight'] = recalculateWeights(
                                      double.parse(weight['weight'].toString()),
                                      weightUnit);
                                }
                              });

                              if (settings.weightGoal.weightUnit !=
                                  weightUnit) {
                                settings.weightGoal.goal = recalculateWeights(
                                  settings.weightGoal.goal,
                                  weightUnit,
                                );
                                settings.weightGoal.weightUnit = weightUnit;
                              }

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
