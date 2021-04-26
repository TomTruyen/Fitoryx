import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/model/workout/WorkoutExerciseSet.dart';

String getExerciseSet(
  int setIndex,
  WorkoutExerciseSet exerciseSet,
  String workoutWeightUnit,
  String settingsWeightUnit,
) {
  double exerciseWeight = exerciseSet.weight;

  if (workoutWeightUnit != settingsWeightUnit) {
    exerciseWeight = recalculateWeights(exerciseSet.weight, settingsWeightUnit);

    workoutWeightUnit = settingsWeightUnit;
  }

  return "$setIndex \t ${exerciseSet.reps} x $exerciseWeight $workoutWeightUnit";
}

double getExerciseTotalWeightLifted(
  List<WorkoutExerciseSet> sets,
  String workoutWeightUnit,
  String settingsWeightUnit,
) {
  double total = 0;

  for (int i = 0; i < sets.length; i++) {
    if (workoutWeightUnit != settingsWeightUnit) {
      total += recalculateWeights(
        (sets[i].reps * sets[i].weight),
        settingsWeightUnit,
      );
    } else {
      total += (sets[i].reps * sets[i].weight);
    }
  }

  return total;
}
