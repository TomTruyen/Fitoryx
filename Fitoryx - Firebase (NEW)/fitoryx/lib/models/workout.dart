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

  static Workout fromJson(Map<String, dynamic> json) {
    var workout = Workout(
      id: json["id"],
      name: json["name"],
      unit: json["unit"],
    );

    workout.exercises = json["exercises"].map(
      (exercise) => Exercise.fromExerciseJson(json),
    );

    return workout;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "unit": unit,
      "exercises": exercises
          .map(
            (exercise) => exercise.toExerciseJson(withId: true),
          )
          .toList(),
    };
  }
}
