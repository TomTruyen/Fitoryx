import 'package:fitoryx/models/graph_goal.dart';
import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/models/unit_type.dart';

class Settings {
  // Units
  UnitType weightUnit;

  // Nutrition Goals
  int? kcal;
  int? carbs;
  int? protein;
  int? fat;

  // Rest Timer
  int rest;
  bool restEnabled;
  bool vibrateEnabled;

  // Graphs
  GraphGoal goals = GraphGoal();
  List<GraphType> graphs = [];

  Settings({
    this.weightUnit = UnitType.metric,
    this.kcal,
    this.carbs,
    this.protein,
    this.fat,
    this.rest = 60,
    this.restEnabled = true,
    this.vibrateEnabled = true,
  });
}
