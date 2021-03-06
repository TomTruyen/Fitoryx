import 'dart:convert';

import 'package:fittrack/functions/Functions.dart';

class UserWeight {
  int id;
  double weight;
  String weightUnit;
  int timeInMillisSinceEpoch;

  UserWeight({
    this.id,
    this.weight = 0.0,
    this.weightUnit = "kg",
    this.timeInMillisSinceEpoch,
  }) {
    if (this.timeInMillisSinceEpoch == null) {
      this.timeInMillisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    }
  }

  UserWeight clone() {
    return new UserWeight(
      id: id,
      weight: weight,
      weightUnit: weightUnit,
      timeInMillisSinceEpoch: timeInMillisSinceEpoch,
    );
  }

  static fromJSON(Map<String, dynamic> json) {
    return new UserWeight(
      id: json['id'],
      weight: json['weight'] ?? 0.0,
      weightUnit: json['weightUnit'] ?? "kg",
      timeInMillisSinceEpoch: json['timeInMillisSinceEpoch'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'weight': weight,
      'weightUnit': weightUnit,
      'timeInMillisSinceEpoch': timeInMillisSinceEpoch,
    };
  }
}

List<UserWeight> getUserWeightListFromJson(Map<String, dynamic> settings) {
  List<UserWeight> _userWeightList = [];

  List<dynamic> _userWeightJsonList = [];
  if (settings['userWeight'] != null) {
    _userWeightJsonList = settings['userWeight'] ?? [];
  }

  for (int i = 0; i < _userWeightJsonList.length; i++) {
    UserWeight userWeight = UserWeight.fromJSON(_userWeightJsonList[i]);

    _userWeightList.add(userWeight);
  }

  if (_userWeightList.isEmpty) {
    _userWeightList.add(
      new UserWeight(weightUnit: settings['weightUnit'] ?? 'kg'),
    );
  }

  return _userWeightList;
}
