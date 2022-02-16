import 'package:fitoryx/models/exercise_set.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseSet', () {
    late ExerciseSet exerciseSet;

    setUp(() {
      exerciseSet = ExerciseSet(reps: 10, weight: 100, time: 10);
    });

    test('getTime should return 0:00 when time null or 0', () {
      exerciseSet.time = 0;
      expect(exerciseSet.getTime(), "0:00");

      exerciseSet.time = null;
      expect(exerciseSet.getTime(), "0:00");
    });

    test('getTime should return correct formatted time', () {
      exerciseSet.time = 60;
      expect(exerciseSet.getTime(), "1:00");

      exerciseSet.time = 65;
      expect(exerciseSet.getTime(), "1:05");

      exerciseSet.time = 70;
      expect(exerciseSet.getTime(), "1:10");
    });

    test('clone should return a new ExerciseFilter with same values', () {
      var newExerciseSet = exerciseSet.clone();

      expect(newExerciseSet.reps, exerciseSet.reps);
      expect(newExerciseSet.weight, exerciseSet.weight);
      expect(newExerciseSet.time, exerciseSet.time);
      expect(newExerciseSet.completed, exerciseSet.completed);
    });

    test('toJson should return json Map', () {
      exerciseSet.reps = 10;
      exerciseSet.weight = 50;
      exerciseSet.time = 100;

      var expected = {
        "reps": 10,
        "weight": 50,
        "time": 100,
      };

      expect(exerciseSet.toJson(), expected);
    });

    test('toJson should return 0 values as json Map when values null', () {
      exerciseSet.reps = null;
      exerciseSet.weight = null;
      exerciseSet.time = null;

      var expected = {
        "reps": 0,
        "weight": 0,
        "time": 0,
      };

      expect(exerciseSet.toJson(), expected);
    });

    test('fromJson should return ExerciseSet from json', () {
      var json = {
        "reps": 10,
        "weight": 50,
        "time": 100,
      };

      var result = ExerciseSet.fromJson(json);

      expect(result.reps, 10);
      expect(result.weight, 50);
      expect(result.time, 100);
    });
  });
}
