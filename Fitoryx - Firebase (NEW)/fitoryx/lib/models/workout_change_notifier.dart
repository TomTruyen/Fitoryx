import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:flutter/material.dart';

class WorkoutChangeNotifier extends ChangeNotifier {
  String? id;
  String name;
  UnitType unit;
  List<Exercise> exercises = [];
  String duration;
  String note;

  // Replace Index ==> Used to know what exercise to replace
  int? replaceIndex;

  WorkoutChangeNotifier({
    this.id,
    this.name = "Workout",
    this.unit = UnitType.metric,
    this.duration = "00:00",
    this.note = "",
  });

  void setName(String name) {
    this.name = name;
  }

  void updateExercises(List<Exercise> exercises) {
    this.exercises = exercises;
    notifyListeners();
  }

  void moveExercise(int oldIndex, int newIndex) {
    Exercise exercise = exercises.removeAt(oldIndex);

    exercises.insert(newIndex, exercise);

    notifyListeners();
  }

  void replaceExercise(Exercise exercise) {
    exercises[replaceIndex!] = exercise;
    notifyListeners();
  }

  void removeExercise(int index) {
    exercises.removeAt(index);

    notifyListeners();
  }

  void addSet(int index) {
    exercises[index].sets.add(ExerciseSet());
    notifyListeners();
  }

  void removeSet(int exerciseIndex, int setIndex) {
    if (exercises[exerciseIndex].sets.length > 1) {
      exercises[exerciseIndex].sets.removeAt(setIndex);
      notifyListeners();
    }
  }

  void toggleSet(int exerciseIndex, int setIndex) {
    exercises[exerciseIndex].sets[setIndex].completed =
        !exercises[exerciseIndex].sets[setIndex].completed;

    notifyListeners();
  }

  bool isWorkoutCompleted() {
    for (var exercise in exercises) {
      for (var set in exercise.sets) {
        if (!set.completed) {
          return false;
        }
      }
    }

    return true;
  }

  void updateWeight(int exerciseIndex, int setIndex, String value) {
    if (value == "") value = "0";

    exercises[exerciseIndex].sets[setIndex].weight = double.parse(value);
  }

  void updateReps(int exerciseIndex, int setIndex, String value) {
    if (value == "") value = "0";

    exercises[exerciseIndex].sets[setIndex].reps = int.parse(value);
  }

  void updateTime(int exerciseIndex, int setIndex, int value) {
    exercises[exerciseIndex].sets[setIndex].time = value;
  }

  void reset() {
    id = null;
    name = "Workout";
    unit = UnitType.metric;
    exercises = [];
    duration = "00:00";
    note = "";

    notifyListeners();
  }

  void withWorkout(Workout workout) {
    id = workout.id;
    name = workout.name;
    unit = workout.unit;
    exercises = workout.exercises;

    // notifyListeners();
  }

  Workout toWorkout() {
    var workout = Workout(
      id: id,
      name: name,
      unit: unit,
    );

    workout.exercises = exercises;

    return workout;
  }

  WorkoutHistory toWorkoutHistory() {
    return WorkoutHistory(
      workout: toWorkout(),
      note: note,
      duration: duration,
      date: DateTime.now(),
    );
  }
}
