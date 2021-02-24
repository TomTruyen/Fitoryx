import 'dart:convert';

import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/shared/Functions.dart';

class Settings {
  int id;

  // Personal Info
  List<UserWeight> userWeight;

  // Units
  String weightUnit;

  // Food Goals
  double kcalGoal;
  double carbsGoal;
  double proteinGoal;
  double fatGoal;

  // Rest Timer
  int defaultRestTime;
  int isRestTimerEnabled;
  int isVibrateUponFinishEnabled;

  // Profile Page
  int workoutsPerWeekGoal;

  Settings({
    this.id,
    this.userWeight,
    this.weightUnit = 'kg',
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
    this.defaultRestTime = 60,
    this.isRestTimerEnabled = 1,
    this.isVibrateUponFinishEnabled = 1,
    this.workoutsPerWeekGoal,
  });

  Settings clone() {
    return new Settings(
      id: id,
      userWeight: userWeight ?? [],
      weightUnit: weightUnit ?? 'kg',
      kcalGoal: kcalGoal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
      defaultRestTime: defaultRestTime ?? 60,
      isRestTimerEnabled: isRestTimerEnabled ?? 1,
      isVibrateUponFinishEnabled: isVibrateUponFinishEnabled ?? 1,
      workoutsPerWeekGoal: workoutsPerWeekGoal,
    );
  }

  static Settings fromJSON(Map<String, dynamic> settings) {
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

    return new Settings(
      id: settings['id'],
      userWeight: _userWeightList ?? [UserWeight()],
      weightUnit: settings['weightUnit'] ?? 'kg',
      kcalGoal: settings['kcalGoal'],
      carbsGoal: settings['carbsGoal'],
      proteinGoal: settings['proteinGoal'],
      fatGoal: settings['fatGoal'],
      defaultRestTime: settings['defaultRestTime'] ?? 60,
      isRestTimerEnabled: settings['isRestTimerEnabled'] ?? 1,
      isVibrateUponFinishEnabled: settings['isVibrateUponFinishEnabled'] ?? 1,
      workoutsPerWeekGoal: settings['workoutsPerWeekGoal'],
    );
  }

  void tryAddUserWeight(double _weight, String _weightUnit) {
    DateTime date = DateTime.now();

    DateTime lastWeightInputDate =
        DateTime.fromMillisecondsSinceEpoch(userWeight[0].timeInMilliseconds);

    if (isSameDay(date, lastWeightInputDate)) {
      userWeight[0] = new UserWeight(
        weight: _weight,
        weightUnit: _weightUnit,
        timeInMilliseconds: date.millisecondsSinceEpoch,
      );
    } else {
      userWeight.insert(
        0,
        new UserWeight(
          weight: _weight,
          weightUnit: _weightUnit,
          timeInMilliseconds: date.millisecondsSinceEpoch,
        ),
      );
    }
  }

  void updateUserWeights(String _weightUnit) {
    for (int i = 0; i < userWeight.length; i++) {
      if (userWeight[i].weightUnit != _weightUnit) {
        userWeight[i].weight = recalculateWeight(
          userWeight[i].weight,
          _weightUnit,
        );

        userWeight[i].weightUnit = _weightUnit;
      }
    }
  }
}
