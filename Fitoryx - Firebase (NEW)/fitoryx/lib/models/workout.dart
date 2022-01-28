import 'package:fitoryx/models/exercise.dart';

class Workout {
  String? id;
  String name;
  String unit;
  List<Exercise> exercises = [];

  Workout({
    this.id,
    this.name = "Workout",
    this.unit = "kg",
  });

  Workout clone() {
    var workout = Workout(id: id, name: name, unit: unit);
    workout.exercises = exercises;

    return workout;
  }

  double getTotalVolume() {
    double volume = 0;

    for (var exercise in exercises) {
      if (exercise.type == 'Weight') {
        for (var set in exercise.sets) {
          volume += (set.reps ?? 0) * (set.weight ?? 0);
        }
      }
    }

    return volume;
  }

  static Workout fromJson(Map<String, dynamic> json) {
    var workout = Workout(
      id: json["id"],
      name: json["name"],
      unit: json["unit"],
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
      "name": name,
      "unit": unit,
      "exercises": exercises
          .map(
            (exercise) => exercise.toJson(),
          )
          .toList(),
    };
  }
}
