import 'package:fittrack/models/exercises/Exercise.dart';

class Workout {
  String id;
  String name;
  String workoutNote;
  String weightUnit;
  List<Exercise> exercises = [];

  Workout({
    this.id = "",
    this.name = "",
    this.weightUnit = "kg",
    this.workoutNote = "",
    this.exercises,
  });

  Workout fromJSON(Map<String, dynamic> workout) {
    List<Exercise> exerciseList = [];

    List<Map<String, dynamic>> exercisesJSON = workout['exercises'] ?? [];
    if (exercisesJSON.isNotEmpty) {
      exercisesJSON.forEach((Map<String, dynamic> exercise) {
        exerciseList.add(new Exercise().fromJSON(exercise));
      });
    }

    return new Workout(
      id: workout['id'] ?? "",
      name: workout['name'] ?? "",
      weightUnit: workout['weightUnit'] ?? "",
      workoutNote: workout['workoutNote'] ?? "",
      exercises: exerciseList ?? [],
    );
  }

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> exercisesJSON = [];

    if (exercises.isNotEmpty) {
      exercises.forEach((Exercise exercise) {
        exercisesJSON.add(exercise.toJSON());
      });
    }

    return {
      'id': id,
      'name': name ?? "",
      'workoutNote': workoutNote ?? "",
      'weightUnit': weightUnit ?? "",
      'exercises': exercisesJSON ?? [],
    };
  }
}
