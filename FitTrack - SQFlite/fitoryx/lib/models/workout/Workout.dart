import 'dart:convert';

import 'package:Fitoryx/models/exercises/Exercise.dart';

class Workout {
  int id;
  String name;
  String weightUnit;
  int timeInMillisSinceEpoch;
  List<Exercise> exercises = [];

  int workoutDurationInMilliseconds;
  String duration;
  String note;

  Workout({
    this.id,
    this.name = "",
    this.weightUnit = "kg",
    this.timeInMillisSinceEpoch,
    this.exercises,
    this.duration = "00:00",
    this.workoutDurationInMilliseconds = 0,
    this.note = "",
  }) {
    if (this.exercises == null) this.exercises = [];
  }

  Workout clone() {
    Workout _clone = new Workout();

    _clone.id = id;
    _clone.name = name ?? "";
    _clone.weightUnit = weightUnit ?? "kg";
    _clone.timeInMillisSinceEpoch =
        timeInMillisSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    _clone.exercises = exercises != null ? List.of(exercises) : [] ?? [];
    _clone.duration = duration ?? "00:00";
    _clone.workoutDurationInMilliseconds = workoutDurationInMilliseconds ?? 0;
    _clone.note = note ?? "";

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

  double getTotalVolume() {
    double totalVolume = 0;

    if (exercises == null || exercises.isEmpty) return 0;

    for (int i = 0; i < exercises.length; i++)
      for (int j = 0; j < exercises[i].sets.length; j++)
        totalVolume += ((exercises[i].sets[j].reps ?? 0) *
            (exercises[i].sets[j].weight ?? 0));

    return totalVolume;
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

  static List<Exercise> exercisesFromJsonString(
    String _exerciseString,
    String _workoutWeightUnit,
  ) {
    List<Exercise> _exercises = (jsonDecode(_exerciseString) as List)
        .map((_exercise) => Exercise.fromJSON(
              _exercise,
              workoutWeightUnit: _workoutWeightUnit,
            ))
        .toList();

    return _exercises;
  }

  static Workout fromJSON(Map<String, dynamic> workout) {
    List<Exercise> exerciseList = [];

    String exercisesJSON = workout['exercises'] ?? [];
    if (exercisesJSON.isNotEmpty) {
      exerciseList =
          exercisesFromJsonString(exercisesJSON, workout['weightUnit'] ?? "kg");
    }

    return new Workout(
      id: workout['id'],
      name: workout['name'] ?? "",
      weightUnit: workout['weightUnit'] ?? "kg",
      timeInMillisSinceEpoch: workout['timeInMillisSinceEpoch'] ??
          DateTime.now().millisecondsSinceEpoch,
      exercises: exerciseList ?? [],
      duration: workout['workoutDuration'] ?? "00:00",
      workoutDurationInMilliseconds:
          workout['workoutDurationInMilliseconds'] ?? 0,
      note: workout['workoutNote'] ?? "",
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
      'workoutDuration': duration ?? "00:00",
      'workoutDurationInMilliseconds': workoutDurationInMilliseconds ?? 0,
      'workoutNote': note ?? "",
    };
  }
}
