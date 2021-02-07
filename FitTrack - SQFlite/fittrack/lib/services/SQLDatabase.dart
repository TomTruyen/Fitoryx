import 'dart:convert';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SQLDatabase {
  final String SECRET_KEY =
      "d55cb8eba585b7ed03db0d4e2c8947c6"; // fittrack_secret_key_for_encryption (MD5 Hashed)
  final List<String> tables = [
    'exercises',
    'workouts',
    'workouts_history',
    'food',
    'settings'
  ];

  Database db;
  List<Workout> workouts;
  List<Workout> workoutsHistory;
  List<Exercise> userExercises;
  Settings settings;
  List<Food> food;

  Future<dynamic> setupDatabase() async {
    try {
      String dbPath = await getDatabasesPath();

      String path = dbPath + "fittrack.db";

      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE exercises (id INTEGER PRIMARY KEY UNIQUE, name TEXT, category TEXT, equipment TEXT, isUserCreated INTEGER)',
          );
          await db.execute(
            'CREATE TABLE workouts (id INTEGER PRIMARY KEY UNIQUE, name TEXT, weightUnit TEXT, timeInMillisSinceEpoch INTEGER, exercises TEXT)',
          );
          await db.execute(
            'CREATE TABLE workouts_history (id INTEGER PRIMARY KEY UNIQUE, name TEXT, weightUnit TEXT, timeInMillisSinceEpoch INTEGER, exercises TEXT, workoutNote TEXT, workoutDuration TEXT, workoutDurationInMilliseconds INTEGER)',
          );
          await db.execute(
            'CREATE TABLE food (id INTEGER PRIMARY KEY UNIQUE, kcal REAL, carbs REAL, protein REAL, fat REAL, date TEXT UNIQUE)',
          );
          await db.execute(
            'CREATE TABLE settings (id INTEGER PRIMARY KEY UNIQUE, weightUnit TEXT, kcalGoal INTEGER, carbsGoal INTEGER, proteinGoal INTEGER, fatGoal INTEGER, defaultRestTime INTEGER, isRestTimerEnabled INTEGER, isVibrateUponFinishEnabled INTEGER)',
          );
        },
      );

      await updateData();

      return "";
    } catch (e) {
      print("Setup Database Error: $e");
      return null;
    }
  }

  Future<void> updateData() async {
    await getSettings();
    await getUserExercises();
    await getFood();
    await getWorkouts();
    await getWorkoutsHistory();
  }

  Future<dynamic> resetDatabase() async {
    try {
      String dbPath = await getDatabasesPath();
      String path = dbPath + "fittrack.db";

      await deleteDatabase(path);

      dynamic result = await setupDatabase();

      if (result == null) {
        return null;
      }

      return "";
    } catch (e) {
      print("Reset Database Error $e");
      return null;
    }
  }

  Future<dynamic> exportDatabase() async {
    try {
      List data = [];

      for (var i = 0; i < tables.length; i++) {
        List<Map<String, dynamic>> listMaps = await db.query(tables[i]);

        data.add(listMaps);
      }

      List backups = [tables, data];

      String json = jsonEncode(backups);

      // encrypt data
      final key = encrypt.Key.fromUtf8(SECRET_KEY);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(json, iv: iv);

      return encrypted.base64; //string of encrypted data
    } catch (e) {
      print("Export Database Error :$e");
      return null;
    }
  }

  Future<dynamic> importDatabase(String data) async {
    try {
      dynamic result = await resetDatabase();
      if (result == null) {
        return null;
      }

      Batch batch = db.batch();

      final key = encrypt.Key.fromUtf8(SECRET_KEY);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      List json = jsonDecode(encrypter.decrypt64(data, iv: iv));

      for (var i = 0; i < json[0].length; i++) {
        for (var j = 0; j < json[1][i].length; j++) {
          batch.insert(json[0][i], json[1][i][j]);
        }
      }

      await batch.commit(continueOnError: false, noResult: true);

      await updateData();

      return "";
    } catch (e) {
      print("Import Database Error: $e");
      return null;
    }
  }

  Future<void> getUpdatedWeights() async {
    await getWorkouts();
    await getWorkoutsHistory();
  }

  Future<dynamic> updateSettings(Settings _settings) async {
    try {
      if (_settings.id == null) {
        // INSERT
        await db.rawInsert(
          'INSERT INTO settings (weightUnit, kcalGoal, carbsGoal, proteinGoal, fatGoal, defaultRestTime, isRestTimerEnabled, isVibrateUponFinishEnabled) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            _settings.weightUnit,
            _settings.kcalGoal,
            _settings.carbsGoal,
            _settings.proteinGoal,
            _settings.fatGoal,
            _settings.defaultRestTime,
            _settings.isRestTimerEnabled,
            _settings.isVibrateUponFinishEnabled,
          ],
        );
      } else {
        // UPDATE
        await db.rawUpdate(
          'UPDATE settings SET weightUnit = ?, kcalGoal = ?, carbsGoal = ?, proteinGoal = ?, fatGoal = ?, defaultRestTime = ?, isRestTimerEnabled = ?, isVibrateUponFinishEnabled = ? WHERE id = ?',
          [
            _settings.weightUnit,
            _settings.kcalGoal,
            _settings.carbsGoal,
            _settings.proteinGoal,
            _settings.fatGoal,
            _settings.defaultRestTime,
            _settings.isRestTimerEnabled,
            _settings.isVibrateUponFinishEnabled,
            _settings.id,
          ],
        );
      }

      return "";
    } catch (e) {
      print("Update Settings Error: $e");
      return null;
    }
  }

  Future<void> getSettings() async {
    try {
      List<Map<String, dynamic>> dbSettings = await db.rawQuery(
        "SELECT * FROM settings LIMIT 1",
      );

      if (dbSettings.isEmpty) {
        settings = new Settings();
      } else {
        settings = Settings.fromJSON(dbSettings[0]);
      }
    } catch (e) {
      print("Get Settings Error: $e");
    }
  }

  Future<dynamic> deleteWorkoutHistory(int id) async {
    try {
      await db.rawDelete(
        'DELETE FROM workouts_history WHERE id = ?',
        [id],
      );

      return "";
    } catch (e) {
      print("Delete Workout History Error $e");
      return null;
    }
  }

  Future<void> getWorkoutsHistory() async {
    try {
      List<Map<String, dynamic>> dbWorkoutsHistory = await db.rawQuery(
              "SELECT * FROM workouts_history ORDER BY timeInMillisSinceEpoch DESC") ??
          [];

      if (dbWorkoutsHistory.isEmpty) {
        workoutsHistory = [];
      } else {
        List<Workout> _workoutsHistory = [];

        dbWorkoutsHistory.forEach((Map<String, dynamic> dbWorkoutHistory) {
          Workout _workoutHistory = Workout.fromJSON(dbWorkoutHistory);

          _workoutsHistory.add(_workoutHistory);
        });

        workoutsHistory = _workoutsHistory;
      }
    } catch (e) {
      print("Get Workouts History Error: $e");
    }
  }

  Future<dynamic> addWorkout(Workout workout) async {
    try {
      String name = workout.name ?? "Workout";
      if (name == "") {
        name = "Workout";
      }

      String weightUnit = workout.weightUnit ?? "kg";
      if (workout.weightUnit != settings.weightUnit) {
        weightUnit = settings.weightUnit;
      }

      int timeInMillisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
      String exercises = workout.exercisesToJsonString() ?? "";

      await db.rawInsert(
        'INSERT INTO workouts (name, weightUnit, timeInMillisSinceEpoch, exercises) VALUES (?, ?, ?, ?)',
        [
          name,
          weightUnit,
          timeInMillisSinceEpoch,
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
      if (workout.weightUnit != settings.weightUnit) {
        weightUnit = settings.weightUnit;
      }

      int timeInMillisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
      String exercises = workout.exercisesToJsonString() ?? "";

      await db.rawUpdate(
        "UPDATE workouts SET name = ?, weightUnit = ?, timeInMillisSinceEpoch = ?, exercises = ? WHERE id = ?",
        [
          name,
          weightUnit,
          timeInMillisSinceEpoch,
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
      List<Map<String, dynamic>> dbWorkouts = await db.rawQuery(
              "SELECT * FROM workouts ORDER BY timeInMillisSinceEpoch DESC") ??
          [];

      if (dbWorkouts.isEmpty) {
        workouts = [];
      } else {
        List<Workout> _workouts = [];

        dbWorkouts.forEach((Map<String, dynamic> dbWorkout) {
          Workout _workout = Workout.fromJSON(dbWorkout);

          _workouts.add(_workout);
        });

        workouts = _workouts;
      }
    } catch (e) {
      print("Get Workouts Error: $e");
    }
  }

  Future<dynamic> saveWorkout(
    Workout workout,
    int workoutDurationInMilliSeconds,
    String workoutDuration,
    String workoutNote,
  ) async {
    try {
      String name = workout.name ?? "Workout";
      if (name == "") {
        name = "Workout";
      }

      String weightUnit = workout.weightUnit ?? "kg";
      if (workout.weightUnit != settings.weightUnit) {
        weightUnit = settings.weightUnit;
      }

      int timeInMillisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
      String exercises = workout.exercisesToJsonString() ?? "";

      await db.rawInsert(
        'INSERT INTO workouts_history (name, weightUnit, timeInMillisSinceEpoch, exercises, workoutNote, workoutDuration, workoutDurationInMilliseconds) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          name,
          weightUnit,
          timeInMillisSinceEpoch,
          exercises,
          workoutNote,
          workoutDuration,
          workoutDurationInMilliSeconds,
        ],
      );

      return "";
    } catch (e) {
      print("Save Workout Error: $e");
      return null;
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
          await db.rawQuery("SELECT * FROM exercises") ?? [];

      if (dbExercises.isEmpty) {
        userExercises = [];
      } else {
        List<Exercise> exercises = [];
        dbExercises.forEach((Map<String, dynamic> dbExercise) {
          Exercise exercise = Exercise.fromJSON(dbExercise);

          exercises.add(exercise);
        });

        userExercises = exercises;
      }
    } catch (e) {
      print("Get UserExercise Error: $e");
    }
  }

  Future<void> getFood() async {
    try {
      List<Map<String, dynamic>> dbFood =
          await db.rawQuery("SELECT * FROM food ORDER BY date DESC") ?? [];

      if (dbFood.isEmpty) {
        food = [];
      } else {
        List<Food> _food = [];
        dbFood.forEach((Map<String, dynamic> _dbFood) {
          Food f = Food.fromJSON(_dbFood);

          _food.add(f);
        });

        food = _food;
      }
    } catch (e) {
      print("Get Food Error: $e");
    }
  }

  Future<dynamic> addFood(
    double kcal,
    double carbs,
    double protein,
    double fat,
  ) async {
    try {
      DateTime now = DateTime.now();

      String date = dateTimeToString(now);

      if (food.isNotEmpty && food[0].date == date) {
        kcal += food[0].kcal;
        carbs += food[0].carbs;
        protein += food[0].protein;
        fat += food[0].fat;
        // Update
        await db.rawUpdate(
          'UPDATE food SET kcal = ?, carbs = ?, protein = ?, fat = ? WHERE date = ?',
          [
            kcal,
            carbs,
            protein,
            fat,
            date,
          ],
        );
      } else {
        // Insert
        await db.rawInsert(
          'INSERT INTO food (kcal, carbs, protein, fat, date) VALUES (?, ?, ?, ?, ?)',
          [
            kcal,
            carbs,
            protein,
            fat,
            date,
          ],
        );
      }

      return "";
    } catch (e) {
      print("Add Food Error: $e");
      return null;
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
    weightUnit TEXT
    timeInMillisSinceEpoch INTEGER == DATE IT WAS ADDED (for sorting)
    exercises TEXT

    - Workouts_History Table
    id INTEGER
    name TEXT
    weightUnit TEXT
    timeInMillisSinceEpoch INTEGER == DATE IT WAS ADDED (for sorting)
    exercises TEXT
    workoutNote TEXT
    workoutDuration TEXT
    workoutDurationInMilliseconds INTEGER  == TIME THE WORKOUT TOOK (in milliseconds)

    - Food Table
    id INTEGER
    kcal REAL
    carbs REAL
    protein REAL
    fat REAL
    REAL TEXT == DATE IT WAS ADDED

    - Settings Table
    id INTEGER
    weightUnit TEXT
    kcalGoal INTEGER
    carbsGoal INTEGER
    proteinGoal INTEGER
    fatGoal INTEGER
    defaultRestTime INTEGER
    isRestTimerEnabled INTEGER
    isVibrateUponFinishEnabled INTEGER
*/
