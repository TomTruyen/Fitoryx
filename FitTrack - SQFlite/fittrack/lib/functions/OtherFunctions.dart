import 'package:fittrack/functions/Functions.dart';
import 'package:flutter/material.dart';

void tryPopContext(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

double recalculateWeight(double weight, String newUnit) {
  const double LBS_IN_KG = 2.2046226218;

  switch (newUnit.toLowerCase()) {
    case 'kg':
      return convertToDecimalPlaces(weight / LBS_IN_KG, 1);
      break;
    case 'lbs':
      return convertToDecimalPlaces(weight * LBS_IN_KG, 1);
      break;
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
