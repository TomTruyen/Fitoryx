import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/exercises/ExerciseSet.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Workout',
    () {
      isWorkoutCompletedTests();
      getSetCountTests();
      getRepCountTests();
      getTotalVolumeTests();
    },
  );
}

void isWorkoutCompletedTests() {
  Workout notCompletedWorkout = new Workout(
    exercises: [
      Exercise(
        sets: [
          ExerciseSet(isCompleted: false),
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
        ],
      )
    ],
  );

  Workout completedWorkout = new Workout(
    exercises: [
      Exercise(
        sets: [
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
        ],
      ),
    ],
  );

  test(
    'isWorkoutCompleted should return bool',
    () {
      dynamic result = notCompletedWorkout.isWorkoutCompleted();

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was ${result.runtimeType}");
    },
  );

  test(
    'isWorkoutCompleted should return false if workout is not completed',
    () {
      dynamic result = notCompletedWorkout.isWorkoutCompleted();

      expect(result, false,
          reason: "Result was expected to be 'false' but is $result");
    },
  );

  test(
    'isWorkoutCompleted should return true if workout is completed',
    () {
      dynamic result = completedWorkout.isWorkoutCompleted();

      expect(result, true,
          reason: "Result was expected to be 'true' but is $result");
    },
  );
}

void getSetCountTests() {
  Workout workout = new Workout(
    exercises: [
      Exercise(
        sets: [
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
        ],
      ),
      Exercise(
        sets: [
          ExerciseSet(isCompleted: true),
        ],
      ),
    ],
  );

  test(
    'getSetCount should return int',
    () {
      dynamic result = workout.getSetCount();

      expect(result, isInstanceOf<int>(),
          reason:
              "Expected result to be of type 'int' but was ${result.runtimeType}");
    },
  );

  test(
    'getSetCount should return correct amount of sets',
    () {
      dynamic result = workout.getSetCount();

      expect(result, 4, reason: "Expected result to be 4 but was $result");
    },
  );
}

void getRepCountTests() {
  Workout workout = new Workout(
    exercises: [
      Exercise(
        sets: [
          ExerciseSet(reps: 50, isCompleted: true),
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
        ],
      ),
      Exercise(
        sets: [
          ExerciseSet(isCompleted: true),
        ],
      ),
    ],
  );

  test(
    'getRepCount should return int',
    () {
      dynamic result = workout.getRepCount();

      expect(result, isInstanceOf<int>(),
          reason:
              "Expected result to be of type 'int' but was ${result.runtimeType}");
    },
  );

  test(
    'getRepCount should return correct amount of reps',
    () {
      dynamic result = workout.getRepCount();

      expect(result, 50, reason: "Expected result to be 50 but was $result");
    },
  );
}

void getTotalVolumeTests() {
  Workout workout = new Workout(
    exercises: [
      Exercise(
        sets: [
          ExerciseSet(reps: 50, weight: 10, isCompleted: true),
          ExerciseSet(isCompleted: true),
          ExerciseSet(isCompleted: true),
        ],
      ),
      Exercise(
        sets: [
          ExerciseSet(isCompleted: true),
        ],
      ),
    ],
  );

  test(
    'getTotalVolume should return double',
    () {
      dynamic result = workout.getTotalVolume();

      expect(result, isInstanceOf<double>(),
          reason:
              "Expected result to be of type 'double' but was ${result.runtimeType}");
    },
  );

  test(
    'getTotalVolume should return total volume',
    () {
      dynamic result = workout.getTotalVolume();

      expect(result, 500, reason: "Expected result to be 50 but was $result");
    },
  );
}
