import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:fittrack/models/food/FoodPerHour.dart';
import 'package:fittrack/models/settings/GraphToShow.dart';
import 'package:fittrack/models/settings/UserWeight.dart';

double convertToDecimalPlaces(double input, int amountOfDecimals) {
  int fac = pow(10, amountOfDecimals);

  return (input * fac).round() / fac;
}

dynamic tryConvertDoubleToInt(double value) {
  if (value == null || value % 1 != 0) {
    return value;
  }

  return value.toInt();
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
