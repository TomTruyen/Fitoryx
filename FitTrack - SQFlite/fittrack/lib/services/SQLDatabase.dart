import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:sqflite/sqflite.dart';

class SQLDatabase {
  Database db;
  List<Exercise> userExercises;

  Future<void> setupDatabase() async {
    try {
      String dbPath = await getDatabasesPath();

      String path = dbPath + "fittrack.db";

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE exercises (id INTEGER PRIMARY KEY UNIQUE, name TEXT, category TEXT, equipment TEXT, isUserCreated INTEGER)',
        );
      });

      await getUserExercises();
    } catch (e) {
      print("Setup Database Error: $e");
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
*/
