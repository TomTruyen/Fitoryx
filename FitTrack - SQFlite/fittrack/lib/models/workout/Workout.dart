import 'dart:convert';

import 'package:fittrack/models/exercises/Exercise.dart';

class Workout {
  int id;
  String name;
  String weightUnit;
  int timeInMillisSinceEpoch;
  List<Exercise> exercises = [];

  Workout({
    this.id,
    this.name = "",
    this.weightUnit = "kg",
    this.timeInMillisSinceEpoch,
    this.exercises,
  });

  Workout clone() {
    Workout _clone = new Workout();

    _clone.id = id;
    _clone.name = name ?? "";
    _clone.weightUnit = weightUnit ?? "kg";
    _clone.timeInMillisSinceEpoch =
        timeInMillisSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    _clone.exercises = List.of(exercises) ?? [];

    return _clone;
  }

  void setUncompleted() {
    for (int i = 0; i < exercises.length; i++) {
      for (int j = 0; j < exercises[i].sets.length; j++) {
        exercises[i].sets[j].isCompleted = false;
      }
    }
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

  int getSetCount() {
    int sets = 0;

    for (int i = 0; i < exercises.length; i++) sets += exercises[i].sets.length;

    return sets;
  }

  int getRepCount() {
    int reps = 0;

    for (int i = 0; i < exercises.length; i++)
      for (int j = 0; j < exercises[i].sets.length; j++)
        reps += exercises[i].sets[j].reps ?? 0;

    return reps;
  }

  double getTotalWeightLifted() {
    double totalWeight = 0;

    for (int i = 0; i < exercises.length; i++)
      for (int j = 0; j < exercises[i].sets.length; j++)
        totalWeight += ((exercises[i].sets[j].reps ?? 0) *
            (exercises[i].sets[j].weight ?? 0));

    return totalWeight;
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
      'weightUnit': weightUnit ?? "",
      'timeInMillisSinceEpoch':
          timeInMillisSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      'exercises': exercisesJSON ?? [],
    };
  }
}
