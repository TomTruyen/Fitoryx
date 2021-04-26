import 'package:fitness_app/models/profile/WeightGoal.dart';
import 'package:fitness_app/models/profile/WorkoutsPerWeekGoal.dart';

class UserSettings {
  String id;
  String weightUnit;
  String heightUnit;
  bool developerMode;
  bool progressiveOverload;
  bool vibrateUponFinish;
  int timerIncrementValue;
  Map<String, dynamic> nutritionGoals;
  WorkoutsPerWeekGoal workoutsPerWeekGoal;
  WeightGoal weightGoal;
  List weightHistory = [];
  List heightHistory = [];

  UserSettings({
    this.id = "",
    this.weightUnit = 'metric',
    this.heightUnit = 'metric',
    this.developerMode = false,
    this.progressiveOverload = false,
    this.vibrateUponFinish = true,
    this.timerIncrementValue = 30,
    this.nutritionGoals,
    this.workoutsPerWeekGoal,
    this.weightGoal,
    this.weightHistory,
    this.heightHistory,
  });

  static Map<String, dynamic> defaultSettings() {
    return {
      'weightUnit': 'metric',
      'heightUnit': 'metric',
      'developerMode': false,
      'progressiveOverload': false,
      'vibrateUponFinish': true,
      'timerIncrementValue': 30,
      'nutritionGoals': {},
      'workoutsPerWeekGoal': {
        'isEnabled': false,
        'goal': 1,
      },
      'weightGoal': {
        'isEnabled': false,
        'goal': 0,
        'weightUnit': 'metric',
      },
      'weightHistory': [],
      'heightHistory': [],
    };
  }

  Map<String, dynamic> toJSON() {
    return {
      'weightUnit': weightUnit,
      'heightUnit': heightUnit,
      'developerMode': developerMode,
      'progressiveOverload': progressiveOverload,
      'vibrateUponFinish': vibrateUponFinish,
      'timerIncrementValue': timerIncrementValue,
      'nutritionGoals': nutritionGoals != null ? nutritionGoals : {},
      'workoutsPerWeekGoal': {
        'isEnabled': workoutsPerWeekGoal.isEnabled,
        'goal': workoutsPerWeekGoal.goal,
      },
      'weightGoal': {
        'isEnabled': weightGoal.isEnabled,
        'goal': weightGoal.goal,
        'weightUnit': weightGoal.weightUnit,
      },
      'weightHistory': weightHistory,
      'heightHistory': heightHistory,
    };
  }
}
