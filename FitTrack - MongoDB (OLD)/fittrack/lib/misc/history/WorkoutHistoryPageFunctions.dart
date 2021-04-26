// PubDev Pacakges
import 'package:intl/intl.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';

String getTotalWeightLifted(
  List<WorkoutExercise> exercises,
  String workoutWeightUnit,
  String settingsWeightUnit,
) {
  double totalWeight = 0.0;

  for (int i = 0; i < exercises.length; i++) {
    for (int j = 0; j < exercises[i].sets.length; j++) {
      totalWeight += (exercises[i].sets[j].reps * exercises[i].sets[j].weight);
    }
  }

  if (settingsWeightUnit != workoutWeightUnit) {
    totalWeight = recalculateWeights(totalWeight, settingsWeightUnit);
  }

  final weightFormat = new NumberFormat('# ##0.00', 'en_US');

  return weightFormat.format(totalWeight);
}
