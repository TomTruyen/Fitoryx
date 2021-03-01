import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:fittrack/models/food/FoodPerHour.dart';
import 'package:fittrack/models/settings/GraphToShow.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void tryPopContext(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

double convertToDecimalPlaces(double input, int amountOfDecimals) {
  int fac = pow(10, amountOfDecimals);

  return (input * fac).round() / fac;
}

String getDateTimeFromMilliseconds(int milliseconds) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
  DateFormat dateFormat = new DateFormat('EEEE, d MMMM y, H:mm');

  return dateFormat.format(date);
}

String getFormattedDateFromDateTime(DateTime date) {
  DateFormat dateFormat = new DateFormat('EEEE, d MMMM y');

  return dateFormat.format(date);
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

String dateTimeToString(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();

  return "$day-$month-$year";
}

String dateTimeToStringWithoutYear(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');

  return "$day-$month";
}

Future<String> getDevicePath() async {
  final directory = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);

  return directory;
}

Future<File> getFile(String path, String fileName) async {
  return File('$path/$fileName');
}

Future<File> writeToFile(File file, String data) async {
  try {
    await file.create(recursive: true);
    File writtenFile = await file.writeAsString(data);

    return writtenFile;
  } catch (e) {
    print("Write To File Error: $e");
    return null;
  }
}

Future<dynamic> readFromFile(File file) async {
  try {
    String data = await file.readAsString();

    return data;
  } catch (e) {
    print("Read From File Error: $e");
    return null;
  }
}

String convertAndroidDeviceInfoToString(AndroidDeviceInfo build) {
  String info = "";

  info += 'Android Version: ${build.version.release}\n';
  info += 'SDK Version: ${build.version.sdkInt}\n';
  info += 'Security Patch: ${build.version.securityPatch}\n';
  info += 'Manufacturer: ${build.manufacturer}\n';
  info += 'Brand: ${build.brand}\n';
  info += 'Model: ${build.model}\n';

  return info;
}

String convertIosDeviceInfoToString(IosDeviceInfo data) {
  String info = "";

  info += 'name: ${data.name}\n';
  info += 'systemName: ${data.systemName}\n';
  info += 'systemVersion: ${data.systemVersion}\n';
  info += 'model: ${data.model}\n';
  info += 'utsname.sysname: ${data.utsname.sysname}\n';
  info += 'utsname.nodename: ${data.utsname.nodename}\n';
  info += 'utsname.release: ${data.utsname.release}\n';
  info += 'utsname.version: ${data.utsname.version}\n';
  info += 'utsname.machine: ${data.utsname.machine}\n';

  return info;
}

List<Map<String, dynamic>> convertFoodPerHourListToJsonList(
  List<FoodPerHour> foodPerHourList,
) {
  List<Map<String, dynamic>> list = [];

  for (int i = 0; i < foodPerHourList.length; i++) {
    list.add(foodPerHourList[i].toJSON());
  }

  return list;
}

List<Map<String, dynamic>> convertUserWeightListToJsonList(
  List<UserWeight> userWeightList,
) {
  List<Map<String, dynamic>> list = [];

  for (int i = 0; i < userWeightList.length; i++) {
    list.add(userWeightList[i].toJSON());
  }

  return list;
}

List<Map<String, dynamic>> convertGraphToShowListToJsonList(
  List<GraphToShow> graphToShowList,
) {
  List<Map<String, dynamic>> list = [];

  for (int i = 0; i < graphToShowList.length; i++) {
    list.add(graphToShowList[i].toJSON());
  }

  return list;
}

bool requiresDateDivider(DateTime date, int currentMonth, int currentYear) {
  return date.month != currentMonth || date.year != currentYear;
}

// Food Pages
dynamic tryConvertDoubleToInt(double value) {
  if (value == null || value % 1 != 0) {
    return value;
  }

  return value.toInt();
}

String getFoodGoalString(double value, double goal, String measurement) {
  String foodGoalString = "";

  // Check if no decimals, so we can remove it
  foodGoalString = tryConvertDoubleToInt(value).toString();

  // Check if there is a goal set and add it to string if it is set
  if (goal != null) {
    // Check if no decimals, so we can remove it
    foodGoalString += " / ";
    foodGoalString += tryConvertDoubleToInt(goal).toString();
  }

  // Add measurement
  foodGoalString += measurement;

  return foodGoalString;
}

DateTime convertDateTimeToDate(DateTime dateTime) {
  DateTime date = new DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    0,
    0,
    0,
    0,
    0,
  );

  return date;
}

bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  if (dateTime1.day == dateTime2.day &&
      dateTime1.month == dateTime2.month &&
      dateTime1.year == dateTime2.year) {
    return true;
  }

  return false;
}

bool hasSameDayUserWeights(List<UserWeight> userWeights, DateTime date) {
  if (userWeights == null || userWeights.isEmpty) {
    return false;
  }

  for (int i = 0; i < userWeights.length; i++) {
    DateTime userWeightDate =
        DateTime.fromMillisecondsSinceEpoch(userWeights[i].timeInMilliseconds);

    if (isSameDay(userWeightDate, date)) {
      return true;
    }
  }

  return false;
}

bool hasSameDayWorkoutHistory(List<Workout> workoutHistory, DateTime date) {
  if (workoutHistory == null || workoutHistory.isEmpty) {
    return false;
  }

  for (int i = 0; i < workoutHistory.length; i++) {
    DateTime workoutHistoryDate = DateTime.fromMillisecondsSinceEpoch(
        workoutHistory[i].timeInMillisSinceEpoch);

    if (isSameDay(workoutHistoryDate, date)) {
      return true;
    }
  }

  return false;
}

List<UserWeight> getUserWeightsWithinTimespan(
  List<UserWeight> userWeights,
  int timespan,
) {
  List<UserWeight> userWeightsWithinTimespan = [];

  DateTime now = DateTime.now();

  DateTime mostRecentDateTime = DateTime.fromMillisecondsSinceEpoch(
    userWeights[userWeights.length - 1].timeInMilliseconds,
  );

  if (!hasSameDayUserWeights(userWeights, mostRecentDateTime)) {
    UserWeight mostRecentClone = userWeights[userWeights.length - 1].clone();
    mostRecentClone.timeInMilliseconds = now.millisecondsSinceEpoch;
    userWeights.add(mostRecentClone);

    mostRecentDateTime = now;
  }

  DateTime latestDateTimeAllowed = mostRecentDateTime.subtract(
    Duration(days: timespan),
  );

  for (int i = 0; i < userWeights.length; i++) {
    if (timespan == -1) {
      userWeightsWithinTimespan.add(userWeights[i]);
    } else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        userWeights[i].timeInMilliseconds,
      );
      if (date.isAfter(latestDateTimeAllowed) ||
          isSameDay(date, latestDateTimeAllowed)) {
        userWeightsWithinTimespan.add(userWeights[i]);
      }
    }
  }

  if (userWeightsWithinTimespan.isNotEmpty &&
      (userWeightsWithinTimespan.length < 2 ||
          !hasSameDayUserWeights(
            userWeightsWithinTimespan,
            latestDateTimeAllowed,
          ))) {
    UserWeight _clone = userWeightsWithinTimespan[0].clone();
    _clone.timeInMilliseconds =
        now.subtract(Duration(days: timespan)).millisecondsSinceEpoch;

    userWeightsWithinTimespan.insert(0, _clone);
  }

  return userWeightsWithinTimespan;
}

List<Workout> getWorkoutHistoryWithinTimespan(
  List<Workout> workoutHistory,
  int timespan,
) {
  List<Workout> workoutHistoryWithinTimespan = [];

  DateTime now = DateTime.now();

  DateTime mostRecentDateTime = DateTime.fromMillisecondsSinceEpoch(
    workoutHistory[workoutHistory.length - 1].timeInMillisSinceEpoch,
  );

  if (!hasSameDayWorkoutHistory(workoutHistory, mostRecentDateTime)) {
    Workout mostRecentClone = workoutHistory[workoutHistory.length - 1].clone();
    mostRecentClone.timeInMillisSinceEpoch = now.millisecondsSinceEpoch;
    workoutHistory.add(mostRecentClone);

    mostRecentDateTime = now;
  }

  DateTime latestDateTimeAllowed = mostRecentDateTime.subtract(
    Duration(days: timespan),
  );

  for (int i = 0; i < workoutHistory.length; i++) {
    if (timespan == -1) {
      workoutHistoryWithinTimespan.add(workoutHistory[i]);
    } else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        workoutHistory[i].timeInMillisSinceEpoch,
      );

      if (date.isAfter(latestDateTimeAllowed) ||
          isSameDay(date, latestDateTimeAllowed)) {
        workoutHistoryWithinTimespan.add(workoutHistory[i]);
      }
    }
  }

  if (workoutHistoryWithinTimespan.isNotEmpty &&
      (workoutHistoryWithinTimespan.length < 2 ||
          !hasSameDayWorkoutHistory(
              workoutHistoryWithinTimespan, latestDateTimeAllowed))) {
    Workout _clone = workoutHistoryWithinTimespan[0].clone();
    _clone.timeInMillisSinceEpoch =
        now.subtract(Duration(days: timespan)).millisecondsSinceEpoch;

    workoutHistoryWithinTimespan.insert(0, _clone);
  }

  return workoutHistoryWithinTimespan;
}

List<UserWeight> sortUserWeightsByDate(
  List<UserWeight> userWeights,
  bool isAscending,
) {
  List<UserWeight> sortedUserWeights = List.of(userWeights);

  sortedUserWeights.sort((UserWeight a, UserWeight b) {
    if (!isAscending)
      return a.timeInMilliseconds.compareTo(b.timeInMilliseconds);

    return -a.timeInMilliseconds.compareTo(b.timeInMilliseconds);
  });

  return sortedUserWeights;
}

List<Workout> sortWorkoutHistoryByDate(
  List<Workout> workoutHistory,
  bool isAscending,
) {
  List<Workout> sortedWorkoutHistory = List.of(workoutHistory);

  sortedWorkoutHistory.sort((Workout a, Workout b) {
    if (!isAscending)
      return a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);

    return -a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);
  });

  return sortedWorkoutHistory;
}

String getTitle(double value, List<String> _datesList) {
  int _value = value.toInt();

  if (value < 0) value = 0;
  if (_value > _datesList.length - 1) _value = _datesList.length - 1;

  return _datesList[_value];
}

String getTitleWithoutYear(double value, List<String> _datesList) {
  int _value = value.toInt();

  if (value < 0) value = 0;
  if (_value > _datesList.length - 1) _value = _datesList.length - 1;

  String _date = _datesList[_value];
  List<String> _splittedDate = _date.split('-');
  _splittedDate.removeLast();

  return _splittedDate.join('-');
}
