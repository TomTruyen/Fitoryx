import 'dart:convert';

class UserWeight {
  double weight;
  String weightUnit;
  int timeInMilliseconds;

  UserWeight({
    this.weight = 0.0,
    this.weightUnit = "kg",
    this.timeInMilliseconds = 0,
  });

  UserWeight clone() {
    return new UserWeight(
      weight: weight,
      weightUnit: weightUnit,
      timeInMilliseconds: timeInMilliseconds,
    );
  }

  static fromJSON(Map<String, dynamic> json) {
    return new UserWeight(
      weight: json['weight'] ?? 0.0,
      weightUnit: json['weightUnit'] ?? "kg",
      timeInMilliseconds: json['timeInMilliseconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'weight': weight,
      'weightUnit': weightUnit,
      'timeInMilliseconds': timeInMilliseconds,
    };
  }
}

List<UserWeight> getUserWeightListFromJson(Map<String, dynamic> settings) {
  List<UserWeight> _userWeightList = [];

  List<dynamic> _userWeightJsonList = [];
  if (settings['userWeight'] != null) {
    _userWeightJsonList = jsonDecode(settings['userWeight']) ?? [];
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

  _userWeightList.sort(
    (a, b) => a.timeInMilliseconds.compareTo(b.timeInMilliseconds),
  );

  _userWeightList = _userWeightList.reversed.toList();

  return _userWeightList;
}
