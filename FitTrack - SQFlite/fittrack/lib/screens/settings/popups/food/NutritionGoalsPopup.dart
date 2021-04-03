import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/settings/popups/food/ActivityLevelPopup.dart';
import 'package:fittrack/screens/settings/popups/food/MissingFoodCalculateRequirements.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/FoodInputWidget.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showPopupNutritionGoals(
  BuildContext context,
  Function updateSettings,
  Settings settings,
) async {
  bool calculating = false;
  bool foodCalculated = false;

  double kcalGoal = settings.kcalGoal ?? 0;
  double carbsGoal = settings.carbsGoal ?? 0;
  double proteinGoal = settings.proteinGoal ?? 0;
  double fatGoal = settings.fatGoal ?? 0;

  void updateValue(double newValue, String name) {
    switch (name.toLowerCase()) {
      case 'kcal':
        kcalGoal = newValue;
        break;
      case 'carbs':
        carbsGoal = newValue;
        break;
      case 'protein':
        proteinGoal = newValue;
        break;
      case 'fat':
        fatGoal = newValue;
        break;
      default:
        break;
    }
  }

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
                    child: calculating
                        ? Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              minHeight: 200.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey[500]),
                                  strokeWidth: 2.0,
                                ),
                                SizedBox(height: 10.0),
                                Text('Calculating...'),
                              ],
                            ),
                          )
                        : foodCalculated
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Calculated Goals',
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
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'kcal',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue: kcalGoal.toString(),
                                          ),
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'carbs',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue: carbsGoal.toString(),
                                          ),
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'protein',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue:
                                                proteinGoal.toString(),
                                          ),
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'fat',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue: fatGoal.toString(),
                                          ),
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
                                            'SET GOAL',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            Settings newSettings =
                                                settings.clone();
                                            newSettings.kcalGoal = kcalGoal;
                                            newSettings.carbsGoal = carbsGoal;
                                            newSettings.proteinGoal =
                                                proteinGoal;
                                            newSettings.fatGoal = fatGoal;

                                            dynamic result = await globals
                                                .sqlDatabase
                                                .updateSettings(newSettings);

                                            if (result != null) {
                                              updateSettings(newSettings);
                                              tryPopContext(context);
                                            } else {
                                              showPopupError(
                                                context,
                                                'Failed to update goals',
                                                'Something went wrong updating the nutrition goals. Please try again.',
                                              );
                                            }
                                            // set food goals
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Nutrition Goals',
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
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'kcal',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue: kcalGoal.toString(),
                                          ),
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'carbs',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue: carbsGoal.toString(),
                                          ),
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'protein',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue:
                                                proteinGoal.toString(),
                                          ),
                                          FoodInputWidget(
                                            updateValue: updateValue,
                                            name: 'fat',
                                            padding: EdgeInsets.all(4.0),
                                            initialValue: fatGoal.toString(),
                                          ),
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
                                            'Calculate',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            List<String> missingRequirements =
                                                settings
                                                    .getCalculateMissingRequirements();

                                            if (missingRequirements.isEmpty) {
                                              int activityLevel =
                                                  await showPopActivityLevel(
                                                context,
                                              );

                                              if (activityLevel == -1) {
                                                tryPopContext(context);
                                              } else {
                                                setState(() {
                                                  calculating = true;
                                                });

                                                Food requirement = settings
                                                    .calculateFoodRequirement(
                                                        activityLevel);

                                                Future.delayed(
                                                    Duration(seconds: 1),
                                                    () => {
                                                          setState(() {
                                                            calculating = false;
                                                            foodCalculated =
                                                                true;
                                                            kcalGoal =
                                                                requirement
                                                                    .kcal;
                                                            fatGoal =
                                                                requirement.fat;
                                                            proteinGoal =
                                                                requirement
                                                                    .protein;
                                                            carbsGoal =
                                                                requirement
                                                                    .carbs;
                                                          })
                                                        });
                                              }
                                            } else {
                                              tryPopContext(context);
                                              showPopupMissingFoodCalculateRequirements(
                                                context,
                                                missingRequirements,
                                                settings,
                                                updateSettings,
                                              );
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            Settings newSettings =
                                                settings.clone();
                                            newSettings.kcalGoal = kcalGoal;
                                            newSettings.carbsGoal = carbsGoal;
                                            newSettings.proteinGoal =
                                                proteinGoal;
                                            newSettings.fatGoal = fatGoal;

                                            dynamic result = await globals
                                                .sqlDatabase
                                                .updateSettings(newSettings);

                                            if (result != null) {
                                              updateSettings(newSettings);
                                              tryPopContext(context);
                                            } else {
                                              showPopupError(
                                                context,
                                                'Failed to update goals',
                                                'Something went wrong updating the nutrition goals. Please try again.',
                                              );
                                            }
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
