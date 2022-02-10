import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/history_list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final List<Exercise> exercises = [
    Exercise(
      name: "Exercise 1",
      category: "Category 1",
      equipment: "Equipment 1",
    ),
    Exercise(
      name: "Exercise 2",
      category: "Category 2",
      equipment: "Equipment 2",
    ),
    Exercise(
      name: "Exercise 3",
      category: "Category 3",
      equipment: "Equipment 3",
      type: ExerciseType.time,
    ),
  ];

  exercises[0].sets = [
    ExerciseSet(reps: 10, weight: 10),
    ExerciseSet(reps: 5, weight: 5)
  ];
  exercises[1].sets = [
    ExerciseSet(reps: 10, weight: 10),
    ExerciseSet(reps: 5, weight: 5)
  ];
  exercises[2].sets = [ExerciseSet(time: 10)];

  final Workout workout = Workout();
  workout.exercises = exercises;

  final List<WorkoutHistory> history = [
    WorkoutHistory(
      workout: workout,
      date: DateTime.now(),
    ),
    WorkoutHistory(
      workout: workout,
      date: DateTime.now(),
    ),
  ];

  const int totalReps = 30;
  const int maxReps = 10;
  const double totalVolume = 250;
  const double maxVolume = 125;
  const double maxWeight = 10;

  test('getTotalReps should return the total reps of exercise in workout', () {
    expect(history.getTotalReps(exercises[0]), totalReps);
  });

  test('getTotalVolume should return the total volume of exercise in workout',
      () {
    expect(history.getTotalVolume(exercises[0]), totalVolume);
  });

  test('getMaxReps should return max reps of exercise in workout', () {
    expect(history.getMaxReps(exercises[0]), maxReps);
  });

  test('getMaxWeight should return max reps of exercise in workout', () {
    expect(history.getMaxWeight(exercises[0]), maxWeight);
  });

  test('getMaxVolume should return max reps of exercise in workout', () {
    expect(history.getMaxVolume(exercises[0]), maxVolume);
  });
}
