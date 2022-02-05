import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/workout_history.dart';

extension HistoryListExtension on List<WorkoutHistory> {
  int getTotalReps(Exercise exercise) {
    int reps = 0;

    forEach((history) {
      reps += history.workout.getExerciseMaxReps(exercise);
    });

    return reps;
  }

  double getTotalVolume(Exercise exercise) {
    double weight = 0;

    forEach((history) {
      weight += history.workout.getExerciseVolume(exercise);
    });

    return weight;
  }

  int getMaxReps(Exercise exercise) {
    int maxReps = 0;

    forEach((history) {
      int reps = history.workout.getExerciseMaxReps(exercise);

      if (maxReps < reps) {
        maxReps = reps;
      }
    });

    return maxReps;
  }

  double getMaxWeight(Exercise exercise) {
    double maxWeight = 0;

    forEach((history) {
      double weight = history.workout.getExerciseMaxWeight(exercise);

      if (maxWeight < weight) {
        maxWeight = weight;
      }
    });

    return maxWeight;
  }

  double getMaxVolume(Exercise exercise) {
    double maxVolume = 0;

    forEach((history) {
      double volume = history.workout.getExerciseVolume(exercise);

      if (maxVolume < volume) {
        maxVolume = volume;
      }
    });

    return maxVolume;
  }
}
