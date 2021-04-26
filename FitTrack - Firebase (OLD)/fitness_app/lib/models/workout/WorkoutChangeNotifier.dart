import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/models/workout/WorkoutExerciseSet.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/misc/Functions.dart';
import 'package:flutter/cupertino.dart';

class WorkoutChangeNotifier extends ChangeNotifier {
  String id;
  String name;
  String workoutNote;
  String weightUnit;
  List<WorkoutExercise> exercises = [];
  List<WorkoutExercise> backupExercises = [];

  WorkoutChangeNotifier({
    this.id = "",
    this.name = 'Workout',
    this.weightUnit = 'metric',
    this.workoutNote = "",
  });

  void updateName(value) {
    name = value;
  }

  void setExercise(WorkoutExercise exercise, int index) {
    if (index < exercises.length) {
      exercises[index] = exercise;

      notifyListeners();
    }
  }

  void addExercise(WorkoutExercise exercise) {
    exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(WorkoutExercise exercise) {
    exercises.remove(exercise);
    notifyListeners();
  }

  void setBackupAsExercises() {
    exercises = [...backupExercises];
    notifyListeners();
  }

  void addSet(int exerciseIndex) {
    exercises[exerciseIndex].sets.add(WorkoutExerciseSet());
    notifyListeners();
  }

  void deleteSet(int exerciseIndex, int setIndex) {
    if (exercises[exerciseIndex].sets.length > 1) {
      exercises[exerciseIndex].sets.removeAt(setIndex);
      notifyListeners();
    }
  }

  void updateSetReps(int exerciseIndex, int setIndex, String reps) {
    exercises[exerciseIndex].sets[setIndex].reps = int.parse(reps);
  }

  void updateSetWeight(int exerciseIndex, int setIndex, String weight) {
    exercises[exerciseIndex].sets[setIndex].weight = double.parse(weight);
  }

  void moveListItem(int oldIndex, int newIndex) {
    final WorkoutExercise workoutExercise = exercises.removeAt(oldIndex);

    exercises.insert(newIndex, workoutExercise);

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    List _getSetList(List<WorkoutExerciseSet> sets) {
      List<Map<String, dynamic>> setList = [];

      for (int i = 0; i < sets.length; i++) {
        setList.add({
          'weight': convertToDecimalPlaces(sets[i].weight, 2),
          'reps': sets[i].reps,
        });
      }

      return setList;
    }

    List _getExerciseList() {
      List<Map<String, dynamic>> exerciseList = [];

      for (int i = 0; i < exercises.length; i++) {
        exerciseList.add({
          'exerciseName': exercises[i].name,
          'exerciseCategory': exercises[i].category,
          'exerciseEquipment': exercises[i].equipment,
          'isCompound': exercises[i].isCompound,
          'sets': _getSetList(exercises[i].sets),
          'restEnabled': exercises[i].restEnabled,
          'restSeconds': exercises[i].restSeconds,
          'hasNotes':
              exercises[i].hasNotes && exercises[i].notes != "" ? true : false,
          'notes': exercises[i].notes,
        });
      }

      return exerciseList;
    }

    Map<String, dynamic> workoutMap = {
      'id': id,
      'workoutName': name,
      'workoutNote': workoutNote,
      'weightUnit': weightUnit,
      'time': DateTime.now(),
      'exercises': _getExerciseList()
    };

    return workoutMap;
  }

  void setExercisesNotCompleted() {
    for (int i = 0; i < exercises.length; i++) {
      for (int j = 0; j < exercises[i].sets.length; j++) {
        exercises[i].sets[j].setComplete = false;
      }
    }
  }

  bool finishedWorkout() {
    for (int i = 0; i < exercises.length; i++) {
      for (int j = 0; j < exercises[i].sets.length; j++) {
        if (!exercises[i].sets[j].setComplete) {
          return false;
        }
      }
    }

    return true;
  }

  void toggleRestEnabled(WorkoutExercise exercise, bool value) {
    exercise.restEnabled = value;
  }

  void toggleNotes(WorkoutExercise exercise) {
    exercise.hasNotes = !exercise.hasNotes;

    if (!exercise.hasNotes) {
      exercise.notes = "";
    }

    notifyListeners();
  }

  void workoutStreamProviderToChangeNotifier(WorkoutStreamProvider workout) {
    this.id = workout.id;
    this.name = workout.name;
    this.weightUnit = workout.weightUnit;
    this.exercises = workout.exercises
        .map(
          (WorkoutExercise workoutExercise) => WorkoutExercise(
            category: workoutExercise.category,
            name: workoutExercise.name,
            equipment: workoutExercise.equipment,
            sets: [...workoutExercise.sets],
            restEnabled: workoutExercise.restEnabled,
            restSeconds: workoutExercise.restSeconds,
            hasNotes: workoutExercise.hasNotes,
            notes: workoutExercise.notes,
          ),
        )
        .toList();

    this.backupExercises = workout.exercises
        .map(
          (WorkoutExercise workoutExercise) => WorkoutExercise(
            category: workoutExercise.category,
            name: workoutExercise.name,
            equipment: workoutExercise.equipment,
            sets: [...workoutExercise.sets],
            restEnabled: workoutExercise.restEnabled,
            restSeconds: workoutExercise.restSeconds,
            hasNotes: workoutExercise.hasNotes,
            notes: workoutExercise.notes,
          ),
        )
        .toList();
  }

  void resetAll() {
    this.name = 'Workout';
    this.exercises = [];
    this.backupExercises = [];
  }
}
