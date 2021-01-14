import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:sqflite/sqflite.dart';

class SQLDatabase {
  Database db;
  List<Workout> workouts;
  List<Exercise> userExercises;

  Future<dynamic> setupDatabase() async {
    try {
      String dbPath = await getDatabasesPath();

      String path = dbPath + "fittrack.db";

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE exercises (id INTEGER PRIMARY KEY UNIQUE, name TEXT, category TEXT, equipment TEXT, isUserCreated INTEGER)',
        );
        await db.execute(
          'CREATE TABLE workouts (id INTEGER PRIMARY KEY UNIQUE, name TEXT, weightUnit TEXT, workoutNote TEXT, exercises TEXT)',
        );
      });

      await getUserExercises();
      await getWorkouts();

      return "";
    } catch (e) {
      print("Setup Database Error: $e");
      return null;
    }
  }

  Future<dynamic> addWorkout(Workout workout) async {
    try {
      String name = workout.name ?? "Workout";
      if (name == "") {
        name = "Workout";
      }

      String weightUnit = workout.weightUnit ?? "kg";
      String workoutNote = workout.workoutNote ?? "";
      String exercises = workout.exercisesToJsonString() ?? "";

      await db.rawInsert(
        'INSERT INTO workouts (name, weightUnit, workoutNote, exercises) VALUES (?, ?, ?, ?)',
        [
          name,
          weightUnit,
          workoutNote,
          exercises,
        ],
      );

      return "";
    } catch (e) {
      print("Add Workout Error: $e");
      return null;
    }
  }

  Future<dynamic> updateWorkout(Workout workout) async {
    try {
      int id = workout.id ?? null;
      if (id == null) {
        return null;
      }

      String name = workout.name ?? "Workout";

      if (name == "") {
        name = "Workout";
      }

      String weightUnit = workout.weightUnit ?? "kg";
      String workoutNote = workout.workoutNote ?? "";
      String exercises = workout.exercisesToJsonString() ?? "";

      await db.rawUpdate(
        "UPDATE workouts SET name = ?, weightUnit = ?, workoutNote = ?, exercises = ? WHERE id = ?",
        [
          name,
          weightUnit,
          workoutNote,
          exercises,
          id,
        ],
      );

      return "";
    } catch (e) {
      print("Update Workout Error $e");
      return null;
    }
  }

  Future<dynamic> deleteWorkout(int id) async {
    try {
      await db.rawDelete(
        'DELETE FROM workouts WHERE id = ?',
        [id],
      );

      return "";
    } catch (e) {
      print("Delete Workout Error $e");
      return null;
    }
  }

  Future<dynamic> duplicateWorkout(Workout workout) async {
    try {
      dynamic result = await addWorkout(workout);

      if (result == null) {
        return null;
      }

      return "";
    } catch (e) {
      print("Duplicate Workout Error $e");
      return null;
    }
  }

  Future<void> getWorkouts() async {
    try {
      List<Map<String, dynamic>> dbWorkouts =
          await db.rawQuery("SELECT * FROM workouts");

      if (dbWorkouts.isEmpty) {
        workouts = [];
      }

      List<Workout> _workouts = [];

      dbWorkouts.forEach((Map<String, dynamic> dbWorkout) {
        Workout _workout = new Workout().fromJSON(dbWorkout);

        _workouts.add(_workout);
      });

      workouts = _workouts;
    } catch (e) {
      print("Get Workouts Error: $e");
    }
  }

  Future<dynamic> addExercise(String exerciseName, String exerciseCategory,
      String exerciseEquipment) async {
    try {
      await db.rawInsert(
          'INSERT INTO exercises (name, category, equipment, isUserCreated) VALUES (?, ?, ?, ?)',
          [
            exerciseName,
            exerciseCategory,
            exerciseEquipment,
            1,
          ]);

      return "";
    } catch (e) {
      print("Add Exercise Error: $e");
      return null;
    }
  }

  Future<dynamic> deleteExercise(int id) async {
    try {
      await db.rawDelete('DELETE FROM exercises WHERE id = ?', [id]);

      return "";
    } catch (e) {
      print("Delete Exercise Error: $e");
      return null;
    }
  }

  Future<void> getUserExercises() async {
    try {
      List<Map<String, dynamic>> dbExercises =
          await db.rawQuery("SELECT * FROM exercises");

      if (dbExercises.isEmpty) {
        userExercises = [];
      }

      List<Exercise> exercises = [];
      dbExercises.forEach((Map<String, dynamic> dbExercise) {
        Exercise exercise = new Exercise().fromJSON(dbExercise);

        exercises.add(exercise);
      });

      userExercises = exercises;
    } catch (e) {
      print("Get UserExercise Error: $e");
    }
  }
}
/* Tables:
 - Exercise Table
    id INTEGER
    name TEXT
    category TEXT
    equipment TEXT
    isUserCreated INTEGER

  - Workouts Table
    id INTEGER
    name TEXT
    workoutNote TEXT
    weightUnit TEXT
    exercises TEXT
*/
