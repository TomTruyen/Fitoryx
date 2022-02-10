import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/utils/utils.dart';

class Workout {
  String? id;
  String name;
  UnitType unit;
  List<Exercise> exercises = [];

  Workout({
    this.id,
    this.name = "Workout",
    this.unit = UnitType.metric,
  });

  void changeUnit(UnitType newUnit) {
    exercises = convertUnitType(List.of(exercises), newUnit);

    unit = newUnit;
  }

  Workout clone({bool fullClone = false}) {
    var workout = Workout(id: id, name: name, unit: unit);

    List<Exercise> exerciseList = [];
    for (var exercise in exercises) {
      exerciseList.add(fullClone ? exercise.fullClone() : exercise.clone());
    }
    workout.exercises = exerciseList;

    return workout;
  }

  double getTotalVolume() {
    double volume = 0;

    for (var exercise in exercises) {
      if (exercise.type == ExerciseType.weight) {
        for (var set in exercise.sets) {
          volume += (set.reps ?? 0) * (set.weight ?? 0);
        }
      }
    }

    return volume;
  }

  double getExerciseVolume(Exercise exercise) {
    double volume = 0;

    exercises.where((e) => e.equals(exercise)).forEach((e) {
      for (var set in e.sets) {
        volume += (set.reps ?? 0) * (set.weight ?? 0);
      }
    });

    return volume;
  }

  int getTotalReps(Exercise exercise) {
    int reps = 0;

    exercises.where((e) => e.equals(exercise)).forEach((e) {
      for (var set in e.sets) {
        reps += set.reps ?? 0;
      }
    });

    return reps;
  }

  int getExerciseMaxReps(Exercise exercise) {
    int maxReps = 0;

    exercises.where((e) => e.equals(exercise)).forEach((e) {
      for (var set in e.sets) {
        int reps = set.reps ?? 0;

        if (maxReps < reps) {
          maxReps = reps;
        }
      }
    });

    return maxReps;
  }

  double getExerciseMaxWeight(Exercise exercise) {
    double maxWeight = 0;

    exercises.where((e) => e.equals(exercise)).forEach((e) {
      for (var set in e.sets) {
        double weight = set.weight ?? 0;

        if (maxWeight < weight) {
          maxWeight = weight;
        }
      }
    });

    return maxWeight;
  }

  static Workout fromJson(Map<String, dynamic> json) {
    var workout = Workout(
      id: json["id"],
      name: json["name"],
      unit: UnitTypeHelper.fromValue(json["unit"]),
    );

    workout.exercises = json["exercises"]
        .map<Exercise>(
          (exercise) => Exercise.fromJson(exercise),
        )
        .toList();

    return workout;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "unit": UnitTypeHelper.toValue(unit),
      "exercises": exercises
          .map(
            (exercise) => exercise.toJson(),
          )
          .toList(),
    };
  }
}
