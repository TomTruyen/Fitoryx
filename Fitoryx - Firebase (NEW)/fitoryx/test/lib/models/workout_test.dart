import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Workout', () {
    late Workout workout;

    setUp(() {
      workout = Workout();
      workout.id = "123";
      workout.name = "Workout";
      workout.unit = UnitType.metric;

      Exercise exercise = Exercise(type: ExerciseType.weight);
      exercise.sets = [
        ExerciseSet(weight: 10, reps: 10),
        ExerciseSet(weight: 20, reps: 20),
      ];
      workout.exercises = [exercise, Exercise()];
    });

    test('changeUnit should change the unit of the workout', () {
      workout.changeUnit(UnitType.imperial);

      expect(workout.unit, UnitType.imperial);
    });

    test('clone should return new Workout with same values', () {
      var result = workout.clone();

      expect(result.id, workout.id);
      expect(result.name, workout.name);
      expect(result.unit, workout.unit);
      expect(result.exercises.length, workout.exercises.length);
    });

    test('getTotalVolume should return total volume of all exercises', () {
      expect(workout.getTotalVolume(), 500);
    });

    test(
        'getExerciseVolume should return the total volume for specific exercise',
        () {
      expect(workout.getExerciseVolume(workout.exercises[0]), 500);
    });

    test('getTotalReps should return the total reps for specific exercise', () {
      expect(workout.getTotalReps(workout.exercises[0]), 30);
    });

    test(
        'getExerciseMaxReps should return the max reps for a set for an exercise',
        () {
      expect(workout.getExerciseMaxReps(workout.exercises[0]), 20);
    });

    test(
        'getExerciseMaxWeight should return the max weight for a set for an exercise',
        () {
      expect(workout.getExerciseMaxWeight(workout.exercises[0]), 20);
    });

    test('fromJson should return Workout from json Map', () {
      var exerciseJson = workout.exercises[0].toJson();

      workout.id = "123";
      workout.name = "WorkoutName";
      workout.unit = UnitType.metric;
      workout.exercises = [workout.exercises[0]];

      var json = {
        "id": "123",
        "name": "WorkoutName",
        "unit": "kg",
        "exercises": [exerciseJson],
      };

      var result = Workout.fromJson(json);

      expect(result.id, "123");
      expect(result.name, "WorkoutName");
      expect(result.unit, UnitType.metric);
      expect(result.exercises.length, 1);
    });

    test('toJson should return json Map from Workout', () {
      var exerciseJson = workout.exercises[0].toJson();

      workout.id = "123";
      workout.name = "WorkoutName";
      workout.unit = UnitType.metric;
      workout.exercises = [workout.exercises[0]];

      var json = {
        "id": "123",
        "name": "WorkoutName",
        "unit": "kg",
        "exercises": [exerciseJson],
      };

      var result = workout.toJson();

      expect(result, json);
    });
  });
}
