import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExerciseSet {
  int reps;
  double weight;
  int time; //time in seconds
  bool isCompleted = false;

  ExerciseSet({this.reps, this.weight, this.time, this.isCompleted = false});

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
      time: _set['time'] ?? null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'reps': reps,
      'weight': weight,
      'time': time,
    };
  }

  String getTime() {
    if (time == null || time == 0) return '0:00';

    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
