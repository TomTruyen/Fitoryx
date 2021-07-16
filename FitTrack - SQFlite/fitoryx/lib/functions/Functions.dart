import 'dart:io';

// Function imports
import 'package:Fitoryx/functions/ConvertFunctions.dart' as ConvertFunctions;
import 'package:Fitoryx/functions/DateFunctions.dart' as DateFunctions;
import 'package:Fitoryx/functions/FileFunctions.dart' as FileFunctions;
import 'package:Fitoryx/functions/FilterFunctions.dart' as FilterFunctions;
import 'package:Fitoryx/functions/GraphFunctions.dart' as GraphFunctions;
import 'package:Fitoryx/functions/SortFunctions.dart' as SortFunctions;
import 'package:Fitoryx/functions/UtilFunctions.dart' as UtilFunctions;
import 'package:Fitoryx/models/exercises/Exercise.dart';
import 'package:Fitoryx/models/exercises/ExerciseFilter.dart';
import 'package:Fitoryx/models/food/Food.dart';
import 'package:Fitoryx/models/food/FoodPerHour.dart';
import 'package:Fitoryx/models/settings/GraphToShow.dart';
import 'package:Fitoryx/models/settings/Settings.dart';
import 'package:Fitoryx/models/settings/UserWeight.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

// Convert Functions
double convertToDecimalPlaces(double input, int amountOfDecimals, bool round) {
  return ConvertFunctions.convertToDecimalPlaces(
    input,
    amountOfDecimals,
    round,
  );
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
String getFormattedDateTimeFromMillisecondsSinceEpoch(int milliseconds) {
  return DateFunctions.getFormattedDateTimeFromMillisecondsSinceEpoch(
      milliseconds);
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

bool hasSameDay(List<dynamic> list, DateTime date) {
  return DateFunctions.hasSameDay(list, date);
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

// Filter Functions
Map<String, dynamic> getFilteredExercises(
  ExerciseFilter filter,
  List<Exercise> exercises,
  List<Exercise> userExercises,
  List<Exercise> workoutExercises,
  bool isReplaceActive,
  Exercise exerciseToReplace,
  Exercise workoutExerciseToReplace,
) {
  return FilterFunctions.getFilteredExercises(
    filter,
    exercises,
    userExercises,
    workoutExercises,
    isReplaceActive,
    exerciseToReplace,
    workoutExerciseToReplace,
  );
}

// Graph Functions
List<dynamic> getDataWithinTimespan(List<dynamic> data, int timespan) {
  return GraphFunctions.getDataWithinTimespan(data, timespan);
}

String getTitle(double value, List<String> _datesList) {
  return GraphFunctions.getTitle(value, _datesList);
}

String getTitleWithoutYear(double value, List<String> _datesList) {
  return GraphFunctions.getTitleWithoutYear(value, _datesList);
}

// Sort Functions
List<dynamic> sortByDate(List<dynamic> list, bool orderAscending) {
  return SortFunctions.sortByDate(list, orderAscending);
}

List<Food> sortFoodByDate(List<Food> _food, bool orderAscending) {
  return SortFunctions.sortFoodByDate(_food, orderAscending);
}

// Other Functions
void tryPopContext(BuildContext context) {
  UtilFunctions.tryPopContext(context);
}

void clearFocus(BuildContext context) {
  UtilFunctions.clearFocus(context);
}

double recalculateHeight(double height, String newUnit) {
  return UtilFunctions.recalculateHeight(height, newUnit);
}

double recalculateWeight(double weight, String newUnit) {
  return UtilFunctions.recalculateWeight(weight, newUnit);
}

bool requiresDateDivider(DateTime date, int currentMonth, int currentYear) {
  return UtilFunctions.requiresDateDivider(date, currentMonth, currentYear);
}

String getFoodGoalString(double value, double goal, String measurement) {
  return UtilFunctions.getFoodGoalString(value, goal, measurement);
}

double calculateKCAL(Settings settings, double level) {
  return UtilFunctions.calculateKCAL(settings, level);
}
