import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:fittrack/models/food/FoodPerHour.dart';
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
    List<FoodPerHour> foodPerHourList) {
  List<Map<String, dynamic>> list = [];

  for (int i = 0; i < foodPerHourList.length; i++) {
    list.add(foodPerHourList[i].toJSON());
  }

  return list;
}

bool requiresDateDivider(DateTime date, int currentMonth, int currentYear) {
  return date.month != currentMonth || date.year != currentYear;
}
