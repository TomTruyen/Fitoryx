import 'dart:io';

import 'package:flutter/material.dart';

import 'package:device_info/device_info.dart';

import 'package:fittrack/models/food/FoodPerHour.dart';
import 'package:fittrack/models/settings/GraphToShow.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';

// Function imports
import 'package:fittrack/functions/ConvertFunctions.dart' as ConvertFunctions;
import 'package:fittrack/functions/DateFunctions.dart' as DateFunctions;
import 'package:fittrack/functions/FileFunctions.dart' as FileFunctions;
import 'package:fittrack/functions/GraphFunctions.dart' as GraphFunctions;
import 'package:fittrack/functions/SortFunctions.dart' as SortFunctions;
import 'package:fittrack/functions/OtherFunctions.dart' as OtherFunctions;

// Convert Functions
double convertToDecimalPlaces(double input, int amountOfDecimals) {
  return ConvertFunctions.convertToDecimalPlaces(input, amountOfDecimals);
}

dynamic tryConvertDoubleToInt(double value) {
  return ConvertFunctions.tryConvertDoubleToInt(value);
}

List<Map<String, dynamic>> convertFoodPerHourListToJsonList(
  List<FoodPerHour> foodPerHourList,
) {
  return ConvertFunctions.convertFoodPerHourListToJsonList(foodPerHourList);
}

List<Map<String, dynamic>> convertUserWeightListToJsonList(
  List<UserWeight> userWeightList,
) {
  return ConvertFunctions.convertUserWeightListToJsonList(userWeightList);
}

List<Map<String, dynamic>> convertGraphToShowListToJsonList(
  List<GraphToShow> graphToShowList,
) {
  return ConvertFunctions.convertGraphToShowListToJsonList(graphToShowList);
}

String convertAndroidDeviceInfoToString(AndroidDeviceInfo build) {
  return ConvertFunctions.convertAndroidDeviceInfoToString(build);
}

String convertIosDeviceInfoToString(IosDeviceInfo data) {
  return ConvertFunctions.convertIosDeviceInfoToString(data);
}

// Date Functions
String getFormattedDateTimeFromMilliseconds(int milliseconds) {
  return DateFunctions.getFormattedDateTimeFromMilliseconds(milliseconds);
}

String getFormattedDateFromDateTime(DateTime date) {
  return DateFunctions.getFormattedDateFromDateTime(date);
}

String convertDateTimeToString(DateTime date) {
  return DateFunctions.convertDateTimeToString(date);
}

String convertDateTimeToStringWithoutYear(DateTime date) {
  return DateFunctions.convertDateTimeToStringWithoutYear(date);
}

DateTime convertDateTimeToDate(DateTime dateTime) {
  return DateFunctions.convertDateTimeToDate(dateTime);
}

bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  return DateFunctions.isSameDay(dateTime1, dateTime2);
}

bool hasSameDayUserWeights(List<UserWeight> userWeights, DateTime date) {
  return DateFunctions.hasSameDayUserWeights(userWeights, date);
}

bool hasSameDayWorkoutHistory(List<Workout> workoutHistory, DateTime date) {
  return DateFunctions.hasSameDayWorkoutHistory(workoutHistory, date);
}

// File Functions
Future<String> getDevicePath() async {
  return await FileFunctions.getDevicePath();
}

Future<File> getFile(String path, String fileName) async {
  return await FileFunctions.getFile(path, fileName);
}

Future<File> writeToFile(File file, String data) async {
  return await FileFunctions.writeToFile(file, data);
}

Future<dynamic> readFromFile(File file) async {
  return await FileFunctions.readFromFile(file);
}

// Graph Functions
List<UserWeight> getUserWeightsWithinTimespan(
  List<UserWeight> userWeights,
  int timespan,
) {
  return GraphFunctions.getUserWeightsWithinTimespan(userWeights, timespan);
}

List<Workout> getWorkoutHistoryWithinTimespan(
  List<Workout> workoutHistory,
  int timespan,
) {
  return GraphFunctions.getWorkoutHistoryWithinTimespan(
      workoutHistory, timespan);
}

String getTitle(double value, List<String> _datesList) {
  return GraphFunctions.getTitle(value, _datesList);
}

String getTitleWithoutYear(double value, List<String> _datesList) {
  return GraphFunctions.getTitleWithoutYear(value, _datesList);
}

// Sort Functions
List<UserWeight> sortUserWeightsByDate(
  List<UserWeight> userWeights,
  bool isAscending,
) {
  return SortFunctions.sortUserWeightsByDate(userWeights, isAscending);
}

List<Workout> sortWorkoutHistoryByDate(
  List<Workout> workoutHistory,
  bool isAscending,
) {
  return SortFunctions.sortWorkoutHistoryByDate(workoutHistory, isAscending);
}

// Other Functions
void tryPopContext(BuildContext context) {
  OtherFunctions.tryPopContext(context);
}

double recalculateWeight(double weight, String newUnit) {
  return OtherFunctions.recalculateWeight(weight, newUnit);
}

bool requiresDateDivider(DateTime date, int currentMonth, int currentYear) {
  return OtherFunctions.requiresDateDivider(date, currentMonth, currentYear);
}

String getFoodGoalString(double value, double goal, String measurement) {
  return OtherFunctions.getFoodGoalString(value, goal, measurement);
}
