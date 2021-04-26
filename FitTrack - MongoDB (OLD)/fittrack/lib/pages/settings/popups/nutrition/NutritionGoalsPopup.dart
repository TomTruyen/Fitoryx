// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/FoodSliderCard.dart';
import 'package:fittrack/model/goals/NutritionGoal.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupNutritionGoals(
  BuildContext context,
  Function refreshSettings,
  Function refreshNutrition,
  Function updateSettingsState,
) async {
  int kcal = globals.settings.nutritionGoal.kcal;
  int carbs = globals.settings.nutritionGoal.carbs;
  int protein = globals.settings.nutritionGoal.protein;
  int fat = globals.settings.nutritionGoal.fat;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void setValue(name, value) {
            switch (name) {
              case 'CALORIES':
                setState(() {
                  kcal = value;
                });
                break;
              case 'CARBS':
                setState(() {
                  carbs = value;
                });
                break;
              case 'PROTEIN':
                setState(() {
                  protein = value;
                });
                break;
              case 'FAT':
                setState(() {
                  fat = value;
                });
                break;
            }
          }

          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300.0,
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50],
                border: Border.all(
                  width: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(),
                  child: Material(
                    color: Colors.grey[50],
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Daily goal',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        FoodSliderCard(
                          name: 'CALORIES',
                          value: kcal,
                          setValue: setValue,
                          min: 0,
                          max: 5000,
                          isSetting: true,
                        ),
                        SizedBox(height: 10.0),
                        FoodSliderCard(
                          name: 'CARBS',
                          value: carbs,
                          setValue: setValue,
                          min: 0,
                          max: 500,
                          isSetting: true,
                        ),
                        SizedBox(height: 10.0),
                        FoodSliderCard(
                          name: 'PROTEIN',
                          value: protein,
                          setValue: setValue,
                          min: 0,
                          max: 250,
                          isSetting: true,
                        ),
                        SizedBox(height: 10.0),
                        FoodSliderCard(
                          name: 'FAT',
                          value: fat,
                          setValue: setValue,
                          min: 0,
                          max: 250,
                          isSetting: true,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  globals.settings.nutritionGoal =
                                      NutritionGoal(
                                    kcal: kcal,
                                    carbs: carbs,
                                    protein: protein,
                                    fat: fat,
                                  );

                                  updateSettingsState();
                                  popContextWhenPossible(context);
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
