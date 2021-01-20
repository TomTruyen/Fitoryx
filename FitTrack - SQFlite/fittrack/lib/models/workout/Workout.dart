import 'dart:convert';

import 'package:fittrack/models/exercises/Exercise.dart';

class Workout {
  int id;
  String name;
  String workoutNote;
  String weightUnit;
  int timeInMillisSinceEpoch;
  List<Exercise> exercises = [];

  Workout({
    this.id,
    this.name = "",
    this.weightUnit = "kg",
    this.workoutNote = "",
    this.timeInMillisSinceEpoch,
    this.exercises,
  });

  Workout clone() {
    Workout _clone = new Workout();

    _clone.id = id;
    _clone.name = name ?? "";
    _clone.workoutNote = workoutNote ?? "";
    _clone.weightUnit = weightUnit ?? "kg";
    _clone.timeInMillisSinceEpoch =
        timeInMillisSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    _clone.exercises = List.of(exercises) ?? [];

    return _clone;
  }

  bool isWorkoutCompleted() {
    bool isCompleted = true;

    for (int i = 0; i < exercises.length; i++) {
      bool exerciseCompleted = exercises[i].isExerciseCompleted() ?? false;

      if (!exerciseCompleted) {
        isCompleted = false;
        break;
      }
    }

    return isCompleted;
  }

  String exercisesToJsonString() {
    List _exercises = [];

    if (exercises.isNotEmpty) {
      exercises.forEach((Exercise _exercise) {
        _exercises.add(_exercise.toJSON());
      });
    }

    return json.encode(_exercises);
  }

  List<Exercise> exercisesFromJsonString(String _exerciseString) {
    List<Exercise> _exercises = (jsonDecode(_exerciseString) as List)
        .map((_exercise) => Exercise().fromJSON(_exercise))
        .toList();

    return _exercises;
  }

  Workout fromJSON(Map<String, dynamic> workout) {
    List<Exercise> exerciseList = [];

    String exercisesJSON = workout['exercises'] ?? [];
    if (exercisesJSON.isNotEmpty) {
      exerciseList = exercisesFromJsonString(exercisesJSON);
    }

    return new Workout(
      id: workout['id'],
      name: workout['name'] ?? "",
      weightUnit: workout['weightUnit'] ?? "",
      workoutNote: workout['workoutNote'] ?? "",
      timeInMillisSinceEpoch: workout['timeInMillisSinceEpoch'] ??
          DateTime.now().millisecondsSinceEpoch,
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
      'timeInMillisSinceEpoch':
          timeInMillisSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      'exercises': exercisesJSON ?? [],
    };
  }
}
