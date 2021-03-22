import 'package:fittrack/functions/Functions.dart';
import 'package:flutter/material.dart';

void tryPopContext(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

void clearFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

double recalculateHeight(double height, String newUnit) {
  const double FOOT_IN_CM = 30.48;

  switch (newUnit.toLowerCase()) {
    case 'cm':
      // required to fix ft not being correct:
      String _heightString = height.toString();
      if (_heightString.contains(".")) {
        int number = int.tryParse(_heightString.split(".")[0]);
        int decimals = int.tryParse(_heightString.split(".")[1]);
        if (decimals == null || number == null) return height;

        height = number + (decimals / 12);
      }
      return convertToDecimalPlaces(height * FOOT_IN_CM, 0, true);
    case 'ft':
      return convertToDecimalPlaces(height / FOOT_IN_CM, 2, true);
    default:
      return height;
  }
}

double recalculateWeight(double weight, String newUnit) {
  const double LBS_IN_KG = 2.2046226218;

  switch (newUnit.toLowerCase()) {
    case 'kg':
      return convertToDecimalPlaces(weight / LBS_IN_KG, 1, true);
    case 'lbs':
      return convertToDecimalPlaces(weight * LBS_IN_KG, 1, true);
    default:
      return weight;
  }
}

bool requiresDateDivider(DateTime date, int currentMonth, int currentYear) {
  return date.month != currentMonth || date.year != currentYear;
}

String getFoodGoalString(double value, double goal, String measurement) {
  String foodGoalString = "";

  foodGoalString = tryConvertDoubleToInt(value).toString();

  if (goal != null) {
    foodGoalString += " / ";
    foodGoalString += tryConvertDoubleToInt(goal).toString();
  }

  foodGoalString += measurement;

  return foodGoalString;
}
