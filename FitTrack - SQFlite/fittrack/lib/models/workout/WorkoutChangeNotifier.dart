import 'package:fittrack/models/exercises/ExerciseSet.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/models/exercises/Exercise.dart';

class WorkoutChangeNotifier extends ChangeNotifier {
  String id;
  String name;
  String workoutNote;
  String weightUnit;
  List<Exercise> exercises = [];

  // Used when calling a 'replace exercise'
  Exercise exerciseToReplace;
  int exerciseToReplaceIndex;

  WorkoutChangeNotifier({
    this.id = "",
    this.name = "",
    this.workoutNote = "",
    this.weightUnit = "kg",
    this.exercises = const [],
  });

  void reset() {
    id = "";
    name = "";
    workoutNote = "";
    weightUnit = "kg";
    exercises = [];
  }

  void updateName(String _name) {
    name = _name;
  }

  void updateWorkoutNote(String _workoutNote) {
    workoutNote = _workoutNote;
  }

  void updateExercises(List<Exercise> _exercises) {
    exercises = _exercises;

    notifyListeners();
  }

  void replaceExercise(Exercise _exercise) {
    exercises[exerciseToReplaceIndex] = _exercise.clone();

    notifyListeners();
  }

  void removeExercise(int exerciseIndex) {
    exercises.removeAt(exerciseIndex);

    notifyListeners();
  }

  void toggleNotes(int exerciseIndex) {
    if (exercises[exerciseIndex].hasNotes == 0) {
      exercises[exerciseIndex].notes = "";
    }

    exercises[exerciseIndex].hasNotes =
        exercises[exerciseIndex].hasNotes == 0 ? 1 : 0;

    notifyListeners();
  }

  void updateExerciseSetWeight(exerciseIndex, setIndex, String value) {
    exercises[exerciseIndex].sets[setIndex].weight = double.parse(value);
  }

  void updateExerciseSetReps(int exerciseIndex, int setIndex, String value) {
    exercises[exerciseIndex].sets[setIndex].reps = double.parse(value);
  }

  void deleteExerciseSet(int exerciseIndex, int setIndex) {
    if (exercises[exerciseIndex].sets.length > 1) {
      print("removing set $setIndex");
      print("weight of set: ${exercises[exerciseIndex].sets[setIndex].weight}");

      exercises[exerciseIndex].sets.removeAt(setIndex);

      notifyListeners();
    }
  }

  void addExerciseSet(int exerciseIndex) {
    exercises[exerciseIndex].sets.add(ExerciseSet());

    notifyListeners();
  }

  WorkoutChangeNotifier fromJSON(Map<String, dynamic> workout) {
    List<Exercise> exerciseList = [];

    List<Map<String, dynamic>> exercisesJSON = workout['exercises'] ?? [];
    if (exercisesJSON.isNotEmpty) {
      exercisesJSON.forEach((Map<String, dynamic> exercise) {
        exerciseList.add(new Exercise().fromJSON(exercise));
      });
    }

    return new WorkoutChangeNotifier(
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

// Add a way to convert exercises to a String, and convert it back to ExerciseObjects
// Maybe toJSON the exercise and then --> make the returned Map a String
