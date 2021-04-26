import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/pages/food/FoodCalculatePage.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/shared/FoodSharedWidgets.dart';
import 'package:flutter/material.dart';

Future<void> showPopupNutritionGoals(
  User user,
  UserSettings settings,
  BuildContext context,
) async {
  int kcal = 0;
  int carbs = 0;
  int protein = 0;
  int fat = 0;

  if (settings.nutritionGoals != null) {
    kcal = settings.nutritionGoals['kcal'];
    carbs = settings.nutritionGoals['carbs'];
    protein = settings.nutritionGoals['protein'];
    fat = settings.nutritionGoals['fat'];
  }

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
                                  'CALCULATE',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          FoodCalculatePage(),
                                    ),
                                  );
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
                                  Map<String, int> nutritionMap = {
                                    'kcal': kcal,
                                    'carbs': carbs,
                                    'protein': protein,
                                    'fat': fat,
                                  };

                                  settings.nutritionGoals = nutritionMap;

                                  dynamic result = await DatabaseService(
                                          uid: user != null ? user.uid : '')
                                      .updateSettings(settings);

                                  if (result != null) {
                                    popContextWhenPossible(context);
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
