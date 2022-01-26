import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutChangeNotifier extends ChangeNotifier {
  String? id;
  String name;
  String unit;
  List<Exercise> exercises = [];
  int duration;
  String note;

  // Replace Index ==> Used to know what exercise to replace
  int? replaceIndex;

  WorkoutChangeNotifier({
    this.id,
    this.name = "Workout",
    this.unit = "kg",
    this.duration = 0,
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

    notifyListeners();
  }

  void reset() {
    id = null;
    name = "Workout";
    unit = "kg";
    exercises = [];
    duration = 0;
    note = "";

    notifyListeners();
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
}
