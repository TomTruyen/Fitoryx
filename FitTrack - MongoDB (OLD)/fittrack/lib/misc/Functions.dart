import 'dart:math';

import 'package:flutter/material.dart';

bool isEmail(String str) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(str);
}

bool hasDigits(String str) {
  String p = r'[0-9]';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(str);
}

bool hasSpecialChar(String str) {
  String p = r'[!@#$%^&*/]';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(str);
}

void popContextWhenPossible(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

double convertToDecimalPlaces(double input, int decimals) {
  int fac = pow(10, decimals);

  return (input * fac).round() / fac;
}

double recalculateWeights(double oldWeight, String newUnit) {
  // 2.2046226218 lbs = 1 kg

  const double LBS_IN_KG = 2.2046226218;

  double _convertToImperial(double weight) {
    return convertToDecimalPlaces(weight * LBS_IN_KG, 1);
  }

  double _convertToMetric(double weight) {
    return convertToDecimalPlaces(weight / LBS_IN_KG, 1);
  }

  if (newUnit == 'kg') {
    return _convertToMetric(oldWeight);
  }

  return _convertToImperial(oldWeight);
}

dynamic recalculateHeights(double oldHeight, String newUnit) {
  // 2.54 centimeters = 1 inch
  // 30.48 centimeters = 1 foot

  oldHeight = double.parse(oldHeight.toString());

  const double CM_IN_FOOT = 30.48;

  int _convertToMetric(double height) {
    return convertToDecimalPlaces(height * CM_IN_FOOT, 1).toInt();
  }

  double _convertToImperial(double height) {
    return convertToDecimalPlaces(height / CM_IN_FOOT, 1);
  }

  if (newUnit == 'cm') {
    return _convertToMetric(oldHeight);
  }

  return _convertToImperial(oldHeight);
}

String convertDateTimeToStringDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
}
