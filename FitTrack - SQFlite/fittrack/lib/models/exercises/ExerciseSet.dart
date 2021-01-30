import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExerciseSet {
  int reps;
  double weight;
  bool isCompleted = false;

  ExerciseSet({this.reps, this.weight, this.isCompleted = false});

  ExerciseSet fromJSON(
    Map<String, dynamic> _set, {
    String workoutWeightUnit,
  }) {
    double _weight = _set['weight'] ?? null;

    if (workoutWeightUnit != null) {
      Settings settings = globals.sqlDatabase.settings;

      if (settings != null && settings.weightUnit != workoutWeightUnit) {
        _weight = recalculateWeight(_weight, settings.weightUnit);
      }
    }

    return new ExerciseSet(
      reps: _set['reps'] ?? null,
      weight: _weight,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }
}
