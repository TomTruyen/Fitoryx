import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise', () {
    late Exercise exercise;

    setUp(() {
      exercise = Exercise();
      exercise.id = "123";
      exercise.name = "ExerciseName";
      exercise.category = "ExerciseCategory";
      exercise.equipment = "ExerciseEquipment";
      exercise.userCreated = false;
      exercise.notes = "ExerciseNotes";
      exercise.restEnabled = true;
      exercise.restSeconds = 60;
      exercise.sets = [
        ExerciseSet(reps: 10, weight: 10),
        ExerciseSet(reps: 10, weight: 12),
        ExerciseSet(reps: 10, weight: 14),
        ExerciseSet(reps: 10, weight: 16),
      ];
      exercise.type = ExerciseType.weight;
    });

    test('getTitle should return correct title format', () {
      expect(exercise.getTitle(), "ExerciseName (ExerciseEquipment)");

      exercise.equipment = "";
      expect(exercise.getTitle(), "ExerciseName");

      exercise.equipment = "None";
      expect(exercise.getTitle(), "ExerciseName");
    });

    test('getBestSet should return bestSet each type', () {
      var result = exercise.getBestSet();

      expect(result.reps, 10);
      expect(result.weight, 16);

      exercise.type = ExerciseType.time;
      exercise.sets = [
        ExerciseSet(time: 10),
        ExerciseSet(time: 90),
        ExerciseSet(time: 30),
      ];

      result = exercise.getBestSet();

      expect(result.time, 90);
    });

    test('getTotalWeight should return the total weight of all sets', () {
      expect(exercise.getTotalWeight(), 520);
    });

    test('getTotalTime should return the total time of all sets', () {
      exercise.type = ExerciseType.time;
      exercise.sets = [];

      expect(exercise.getTotalTime(), "0:00");

      exercise.sets = [
        ExerciseSet(time: 10),
        ExerciseSet(time: 60),
      ];
      expect(exercise.getTotalTime(), "01:10");

      exercise.sets = [
        ExerciseSet(time: 15),
        ExerciseSet(time: 600),
        ExerciseSet(time: 3600),
      ];
      expect(exercise.getTotalTime(), "01:10:15");
    });

    test(
        'clone should return new Exercise with same id, name, category, equipment & type',
        () {
      var result = exercise.clone();

      expect(result.id, exercise.id);
      expect(result.name, exercise.name);
      expect(result.category, exercise.category);
      expect(result.equipment, exercise.equipment);
      expect(result.type, exercise.type);
    });

    test('fullClone should return new Exercise with the values from exercise',
        () {
      var result = exercise.fullClone();

      expect(result.id, exercise.id);
      expect(result.name, exercise.name);
      expect(result.category, exercise.category);
      expect(result.equipment, exercise.equipment);
      expect(result.type, exercise.type);
      expect(result.notes, exercise.notes);
      expect(result.restEnabled, exercise.restEnabled);
      expect(result.restSeconds, exercise.restSeconds);
      expect(result.sets.length, exercise.sets.length);
    });

    test('toExerciseJson should return json Map for exercise', () {
      var json = {
        "id": exercise.id,
        "name": exercise.name,
        "category": exercise.category,
        "equipment": exercise.equipment,
        "type": "Weight",
        "userCreated": exercise.userCreated,
      };

      var result = exercise.toExerciseJson();

      expect(result, json);
    });

    test('fromExerciseJson should return Exercise from json', () {
      var json = {
        "id": "123",
        "name": "Name",
        "category": "Category",
        "equipment": "Equipment",
        "type": "Weight",
        "userCreated": true,
      };

      var result = Exercise.fromExerciseJson(json);

      expect(result.id, "123");
      expect(result.name, "Name");
      expect(result.category, "Category");
      expect(result.equipment, "Equipment");
      expect(result.type, ExerciseType.weight);
      expect(result.userCreated, true);
    });

    test('toJson should return json Map from exercise', () {
      exercise.type = ExerciseType.weight;
      exercise.sets = [ExerciseSet(reps: 10, weight: 15, time: 0)];

      var json = {
        "id": exercise.id,
        "name": exercise.name,
        "category": exercise.category,
        "equipment": exercise.equipment,
        "type": "Weight",
        "notes": exercise.notes,
        "restEnabled": exercise.restEnabled,
        "restSeconds": exercise.restSeconds,
        "sets": [
          {
            "reps": exercise.sets[0].reps,
            "weight": exercise.sets[0].weight,
            "time": exercise.sets[0].time,
          },
        ],
      };

      var result = exercise.toJson();

      expect(result, json);
    });

    test('fromJson should return exercise from json', () {
      var json = {
        "id": "123",
        "name": "Name",
        "category": "Category",
        "equipment": "Equipment",
        "type": "Weight",
        "notes": "Notes",
        "restEnabled": true,
        "restSeconds": 60,
        "sets": [
          {
            "reps": 10,
            "weight": 15,
            "time": 0,
          },
        ],
      };

      var result = Exercise.fromJson(json);

      expect(result.id, "123");
      expect(result.name, "Name");
      expect(result.category, "Category");
      expect(result.equipment, "Equipment");
      expect(result.type, ExerciseType.weight);
      expect(result.notes, "Notes");
      expect(result.restEnabled, true);
      expect(result.restSeconds, 60);
      expect(result.sets.length, 1);
      expect(result.sets[0].reps, 10);
      expect(result.sets[0].weight, 15);
      expect(result.sets[0].time, 0);
    });

    test('equals should compare values for equality', () {
      var clone = exercise.clone();
      var fullClone = exercise.fullClone();

      expect(exercise.equals(clone), true);
      expect(exercise.equals(fullClone), true);
    });
  });
}
