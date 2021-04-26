import 'package:fittrack/model/goals/NutritionGoal.dart';
import 'package:fittrack/model/goals/WeightGoal.dart';
import 'package:fittrack/model/goals/WorkoutPerWeekGoal.dart';

class Settings {
  int timerIncrementValue;
  String weightUnit;
  String heightUnit;
  bool isDeveloperModeEnabled;
  bool isRestTimerEnabled;
  bool isProgressiveOverloadEnabled;
  bool isVibrateUponFinishEnabled;
  List weightHistory = [];
  List heightHistory = [];

  NutritionGoal nutritionGoal = NutritionGoal();
  WorkoutPerWeekGoal workoutPerWeekGoal = WorkoutPerWeekGoal();
  WeightGoal weightGoal = WeightGoal();

  Settings({
    this.timerIncrementValue = 30,
    this.weightUnit = 'kg',
    this.heightUnit = 'cm',
    this.isDeveloperModeEnabled = false,
    this.isRestTimerEnabled = false,
    this.isProgressiveOverloadEnabled = false,
    this.isVibrateUponFinishEnabled = false,
    this.weightHistory,
    this.heightHistory,
    this.nutritionGoal,
    this.workoutPerWeekGoal,
    this.weightGoal,
  });

  static Map<String, dynamic> defaultSettings() {
    return {
      'timerIncrementValue': 30,
      'weightUnit': 'kg',
      'heightUnit': 'cm',
      'isDeveloperModeEnabled': false,
      'isRestTimerEnabled': true,
      'isProgressiveOverloadEnabled': false,
      'isVibrateUponFinishEnabled': true,
      'nutritionGoal': NutritionGoal().toJSON(),
      'workoutPerWeekGoal': WorkoutPerWeekGoal().toJSON(),
      'weightGoal': WeightGoal().toJSON(),
    };
  }

  Map<String, dynamic> toJSON() {
    return {
      'timerIncrementValue': timerIncrementValue,
      'weightUnit': weightUnit,
      'heightUnit': heightUnit,
      'isDeveloperModeEnabled': isDeveloperModeEnabled,
      'isRestTimerEnabled': isRestTimerEnabled,
      'isProgressiveOverloadEnabled': isProgressiveOverloadEnabled,
      'isVibrateUponFinishEnabled': isVibrateUponFinishEnabled,
      'weightHistory': weightHistory ?? [],
      'heightHistory': heightHistory ?? [],
      'nutritionGoal': nutritionGoal.toJSON(),
      'workoutPerWeekGoal': workoutPerWeekGoal.toJSON(),
      'weightGoal': weightGoal.toJSON(),
    };
  }
}
