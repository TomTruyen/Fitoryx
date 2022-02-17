import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkoutHistory', () {
    late Workout workout;
    late WorkoutHistory workoutHistory;

    setUp(() {
      workout = Workout(id: "123", name: "Workout Name", unit: UnitType.metric);

      workoutHistory = WorkoutHistory(
        id: "123",
        workout: workout,
        duration: "01:00",
        note: "History Note",
        date: DateTime.now(),
      );
    });

    test('clone should return new WorkoutHistory with current values', () {
      var result = workoutHistory.clone(newUnit: UnitType.metric);

      expect(result.id, workoutHistory.id);
      expect(result.workout.id, workoutHistory.workout.id);
      expect(result.workout.name, workoutHistory.workout.name);
      expect(
        result.workout.exercises.length,
        workoutHistory.workout.exercises.length,
      );
      expect(result.duration, workoutHistory.duration);
      expect(result.note, workoutHistory.note);
      expect(result.date, workoutHistory.date);
    });

    test('fromJson should return WorkoutHistory from json Map', () {
      var date = DateTime.now();

      var json = {
        "id": "123",
        "workout": workout.toJson(),
        "duration": "00:30",
        "note": "Note",
        "date": Timestamp.fromDate(date),
      };

      var result = WorkoutHistory.fromJson(json);

      expect(result.id, "123");
      expect(result.workout.id, workout.id);
      expect(result.workout.name, workout.name);
      expect(
        result.workout.exercises.length,
        workout.exercises.length,
      );
      expect(result.duration, "00:30");
      expect(result.note, "Note");
      expect(result.date, date);
    });

    test('toJson should return json Map from WorkoutHistory', () {
      var expected = {
        "id": "123",
        "workout": workout.toJson(),
        "duration": "01:00",
        "note": "History Note",
        "date": workoutHistory.date,
      };

      var result = workoutHistory.toJson();

      expect(result, expected);
    });
  });
}
