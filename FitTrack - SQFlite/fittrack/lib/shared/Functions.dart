import 'dart:io';
import 'dart:math';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';

void tryPopContext(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

double convertToDecimalPlaces(double input, int amountOfDecimals) {
  int fac = pow(10, amountOfDecimals);

  return (input * fac).round() / fac;
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
