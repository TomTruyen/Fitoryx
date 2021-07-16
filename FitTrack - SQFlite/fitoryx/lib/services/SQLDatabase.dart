import 'dart:convert';
import 'dart:io';

import 'package:Fitoryx/functions/FileFunctions.dart';
import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/exercises/Exercise.dart';
import 'package:Fitoryx/models/food/Food.dart';
import 'package:Fitoryx/models/food/FoodPerHour.dart';
import 'package:Fitoryx/models/settings/BodyFat.dart';
import 'package:Fitoryx/models/settings/Settings.dart';
import 'package:Fitoryx/models/settings/UserWeight.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

const SECRET_KEY =
    "d55cb8eba585b7ed03db0d4e2c8947c6"; // Fitoryx_secret_key_for_encryption (MD5 Hashed)

class SQLDatabase {
  final List<String> tables = [
    'exercises',
    'workouts',
    'workouts_history',
    'food',
    'settings',
    'userWeight',
    'bodyFat',
  ];

  Database db;
  List<Workout> workouts;
  List<Workout> workoutsHistory;
  List<Exercise> userExercises;
  Settings settings;
  List<Food> food;

  Future<String> getPersistentDBPath() async {
    try {
      if (await Permission.storage.request().isGranted) {
        String externalDirectoryPath =
            await ExtStorage.getExternalStorageDirectory();
        String directoryPath = "$externalDirectoryPath/Fitoryx_persistent";
        await (new Directory(directoryPath).create());
        return "$directoryPath/Fitoryx.db";
      }

      return null;
    } catch (e) {
      print("Error getting PersistentPath: $e");
      return null;
    }
  }

  Future<dynamic> setupDatabase() async {
    try {
      String path = await getPersistentDBPath();

      if (path == null) {
        String dbPath = await getDatabasesPath();

        path = dbPath + "Fitoryx.db";
      }

      db = await openDatabase(
        path,
        version: 2,
        onCreate: (Database db, int version) async {
          await Future.wait(
            [
              db.execute(
                'CREATE TABLE exercises (id INTEGER PRIMARY KEY UNIQUE, name TEXT, category TEXT, equipment TEXT, type TEXT, isUserCreated INTEGER)',
              ),
              db.execute(
                'CREATE TABLE workouts (id INTEGER PRIMARY KEY UNIQUE, name TEXT, weightUnit TEXT, timeInMillisSinceEpoch INTEGER, exercises TEXT)',
              ),
              db.execute(
                'CREATE TABLE workouts_history (id INTEGER PRIMARY KEY UNIQUE, name TEXT, weightUnit TEXT, timeInMillisSinceEpoch INTEGER, exercises TEXT, workoutNote TEXT, workoutDuration TEXT, workoutDurationInMilliseconds INTEGER)',
              ),
              db.execute(
                'CREATE TABLE food (id INTEGER PRIMARY KEY UNIQUE, foodPerHour TEXT, kcalGoal REAL, carbsGoal REAL, proteinGoal REAL, fatGoal REAL, date TEXT UNIQUE)',
              ),
              db.execute(
                'CREATE TABLE settings (id INTEGER PRIMARY KEY UNIQUE, weightUnit TEXT, heightUnit TEXT, height REAL, gender TEXT, dateOfBirth INTEGER, kcalGoal REAL, carbsGoal REAL, proteinGoal REAL, fatGoal REAL, defaultRestTime INTEGER, isRestTimerEnabled INTEGER, isVibrateUponFinishEnabled INTEGER, graphsToShow TEXT, workoutsPerWeekGoal INTEGER, isAutoExportEnabled INTEGER)',
              ),
              db.execute(
                'CREATE TABLE userWeight (id INTEGER PRIMARY KEY UNIQUE, weight REAL, weightUnit TEXT, timeInMillisSinceEpoch INTEGER)',
              ),
              db.execute(
                'CREATE TABLE bodyFat (id INTEGER PRIMARY KEY UNIQUE, percentage REAL, timeInMillisSinceEpoch INTEGER)',
              ),
            ],
          );
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (oldVersion < 1 && newVersion >= 1) {
            await Future.wait(
              [
                db.execute(
                  'ALTER TABLE settings ADD COLUMN heightUnit TEXT',
                ),
                db.execute(
                  'ALTER TABLE settings ADD COLUMN height REAL',
                ),
                db.execute(
                  'ALTER TABLE settings ADD COLUMN gender TEXT',
                ),
                db.execute(
                  'ALTER TABLE settings ADD COLUMN dateOfBirth INTEGER',
                ),
              ],
            );
          }
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
    await Future.wait(
      [
        fetchSettings(),
        fetchUserExercises(),
        fetchFood(),
        fetchWorkouts(),
        fetchWorkoutsHistory(),
      ],
    );
  }

  Future<void> autoExportData() async {
    if (settings.isAutoExportEnabled == 1) {
      await tryAutoExportData();
    }
  }

  Future<dynamic> resetDatabase() async {
    try {
      String path = await getPersistentDBPath();

      if (path == null) {
        String dbPath = await getDatabasesPath();

        path = dbPath + "Fitoryx.db";
      }

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

  Future<void> fetchUpdatedWeights() async {
    Future.wait(
      [
        fetchWorkouts(),
        fetchWorkoutsHistory(),
      ],
    );
  }

  Future<dynamic> updateBodyFat(BodyFat bodyFat, bool isInsert) async {
    try {
      if (isInsert || bodyFat.id == null) {
        await db.rawInsert(
          'INSERT INTO bodyFat (percentage, timeInMillisSinceEpoch) VALUES (?, ?)',
          [
            bodyFat.percentage,
            bodyFat.timeInMillisSinceEpoch,
          ],
        );
      } else {
        await db.rawUpdate(
          'UPDATE bodyFat SET percentage = ?, timeInMillisSinceEpoch = ? WHERE id = ?',
          [
            bodyFat.percentage,
            bodyFat.timeInMillisSinceEpoch,
            bodyFat.id,
          ],
        );
      }

      await autoExportData();

      return "";
    } catch (e) {
      print("Update bodyFat Error: $e");
      return null;
    }
  }

  Future<dynamic> updateUserWeight(UserWeight userWeight, bool isInsert) async {
    try {
      if (isInsert || userWeight.id == null) {
        await db.rawInsert(
          'INSERT INTO userWeight (weight, weightUnit, timeInMillisSinceEpoch) VALUES (?, ?, ?)',
          [
            userWeight.weight,
            userWeight.weightUnit,
            userWeight.timeInMillisSinceEpoch,
          ],
        );
      } else {
        await db.rawUpdate(
          'UPDATE userWeight SET weight = ?, weightUnit = ?, timeInMillisSinceEpoch = ? WHERE id = ?',
          [
            userWeight.weight,
            userWeight.weightUnit,
            userWeight.timeInMillisSinceEpoch,
            userWeight.id,
          ],
        );
      }

      await autoExportData();

      return "";
    } catch (e) {
      print("Update UserWeight Error: $e");
      return null;
    }
  }

  Future<dynamic> updateUserWeightUnit(List<UserWeight> _userWeights) async {
    try {
      Batch batch = db.batch();
      for (int i = 0; i < _userWeights.length; i++) {
        UserWeight _userWeight = _userWeights[i];

        if (_userWeight.id != null) {
          batch.rawUpdate(
            'UPDATE userWeight SET weight = ?, weightUnit = ? WHERE id = ?',
            [
              _userWeight.weight,
              _userWeight.weightUnit,
              _userWeight.id,
            ],
          );
        }
      }

      await batch.commit(continueOnError: false, noResult: true);

      return "";
    } catch (e) {
      print("Update UserWeight WeightUnit Error: $e");
      return null;
    }
  }

  Future<dynamic> updateSettings(Settings _settings) async {
    try {
      if (_settings.id == null) {
        // INSERT
        await db.rawInsert(
          'INSERT INTO settings (weightUnit, heightUnit, height, gender, dateOfBirth, kcalGoal, carbsGoal, proteinGoal, fatGoal, defaultRestTime, isRestTimerEnabled, isVibrateUponFinishEnabled, graphsToShow, workoutsPerWeekGoal, isAutoExportEnabled) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            _settings.weightUnit,
            _settings.heightUnit,
            _settings.height,
            _settings.gender,
            _settings.dateOfBirth?.millisecondsSinceEpoch,
            _settings.kcalGoal,
            _settings.carbsGoal,
            _settings.proteinGoal,
            _settings.fatGoal,
            _settings.defaultRestTime,
            _settings.isRestTimerEnabled,
            _settings.isVibrateUponFinishEnabled,
            jsonEncode(
              convertGraphToShowListToJsonList(_settings.graphsToShow),
            ),
            _settings.workoutsPerWeekGoal,
            _settings.isAutoExportEnabled,
          ],
        );
      } else {
        // UPDATE
        await db.rawUpdate(
          'UPDATE settings SET weightUnit = ?, heightUnit = ?, height = ?, gender = ?, dateOfBirth = ?, kcalGoal = ?, carbsGoal = ?, proteinGoal = ?, fatGoal = ?, defaultRestTime = ?, isRestTimerEnabled = ?, isVibrateUponFinishEnabled = ?, graphsToShow = ?, workoutsPerWeekGoal = ?, isAutoExportEnabled = ? WHERE id = ?',
          [
            _settings.weightUnit,
            _settings.heightUnit,
            _settings.height,
            _settings.gender,
            _settings.dateOfBirth?.millisecondsSinceEpoch,
            _settings.kcalGoal,
            _settings.carbsGoal,
            _settings.proteinGoal,
            _settings.fatGoal,
            _settings.defaultRestTime,
            _settings.isRestTimerEnabled,
            _settings.isVibrateUponFinishEnabled,
            jsonEncode(
              convertGraphToShowListToJsonList(_settings.graphsToShow),
            ),
            _settings.workoutsPerWeekGoal,
            _settings.isAutoExportEnabled,
            _settings.id,
          ],
        );
      }

      await autoExportData();

      return "";
    } catch (e) {
      print("Update Settings Error: $e");
      return null;
    }
  }

  Future<void> fetchSettings() async {
    try {
      List<Map<String, dynamic>> dbSettings = await db.rawQuery(
        "SELECT * FROM settings LIMIT 1",
      );

      List<Map<String, dynamic>> dbUserWeight = await db.rawQuery(
        "SELECT * FROM userWeight ORDER BY timeInMillisSinceEpoch DESC",
      );

      List<Map<String, dynamic>> dbBodyFat = await db.rawQuery(
        "SELECT * FROM bodyFat ORDER BY timeInMillisSinceEpoch DESC",
      );

      if (dbSettings.isEmpty) {
        settings = new Settings();

        if (dbUserWeight.isNotEmpty) {
          settings.userWeight = getUserWeightListFromJson(
            {
              "userWeight": dbUserWeight,
            },
          );
        }

        if (dbBodyFat.isNotEmpty) {
          settings.bodyFat = getBodyFatListFromJson(
            {
              "bodyFat": dbBodyFat,
            },
          );
        }
      } else {
        Map<String, dynamic> dbSetting = jsonDecode(jsonEncode(dbSettings[0]));
        dbSetting.putIfAbsent('userWeight', () => dbUserWeight);
        dbSetting.putIfAbsent('bodyFat', () => dbBodyFat);

        settings = Settings.fromJSON(dbSetting);
      }
    } catch (e) {
      print("Fetch Settings Error: $e");
    }
  }

  Future<dynamic> deleteWorkoutHistory(int id) async {
    try {
      await db.rawDelete(
        'DELETE FROM workouts_history WHERE id = ?',
        [id],
      );

      await autoExportData();

      return "";
    } catch (e) {
      print("Delete Workout History Error $e");
      return null;
    }
  }

  Future<void> fetchWorkoutsHistory() async {
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
      print("Fetch Workouts History Error: $e");
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

      await autoExportData();

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

      await autoExportData();

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

      await autoExportData();

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

      await autoExportData();

      return "";
    } catch (e) {
      print("Duplicate Workout Error $e");
      return null;
    }
  }

  Future<void> fetchWorkouts() async {
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
      print("Fetch Workouts Error: $e");
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

      await autoExportData();

      return "";
    } catch (e) {
      print("Save Workout Error: $e");
      return null;
    }
  }

  Future<dynamic> addExercise(
    String exerciseName,
    String exerciseCategory,
    String exerciseEquipment,
    String exerciseType,
  ) async {
    try {
      await db.rawInsert(
        'INSERT INTO exercises (name, category, equipment, type, isUserCreated) VALUES (?, ?, ?, ?, ?)',
        [
          exerciseName,
          exerciseCategory,
          exerciseEquipment,
          exerciseType,
          1,
        ],
      );

      await autoExportData();

      return "";
    } catch (e) {
      print("Add Exercise Error: $e");
      return null;
    }
  }

  Future<dynamic> deleteExercise(int id) async {
    try {
      await db.rawDelete('DELETE FROM exercises WHERE id = ?', [id]);

      await autoExportData();

      return "";
    } catch (e) {
      print("Delete Exercise Error: $e");
      return null;
    }
  }

  Future<void> fetchUserExercises() async {
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
      print("Fetch UserExercise Error: $e");
    }
  }

  Future<void> fetchFood() async {
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
      print("Fetch Food Error: $e");
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

      String date = convertDateTimeToString(now);

      List<FoodPerHour> foodPerHourList = [];

      if (food.isNotEmpty && food[0].date == date) {
        foodPerHourList = List.of(food[0].foodPerHour) ?? [];

        int foundHourIndex = -1;
        for (int i = 0; i < foodPerHourList.length; i++) {
          if (foodPerHourList[i].hour == now.hour) {
            foundHourIndex = i;
            break;
          }
        }

        if (foundHourIndex > -1) {
          foodPerHourList[foundHourIndex].kcal += kcal;
          foodPerHourList[foundHourIndex].carbs += carbs;
          foodPerHourList[foundHourIndex].protein += protein;
          foodPerHourList[foundHourIndex].fat += fat;
        } else {
          foodPerHourList.add(
            new FoodPerHour(
              kcal: kcal,
              carbs: carbs,
              protein: protein,
              fat: fat,
              hour: now.hour,
            ),
          );
        }
        // Update
        await db.rawUpdate(
          'UPDATE food SET foodPerHour = ?, kcalGoal = ?, carbsGoal = ?, proteinGoal = ?, fatGoal = ? WHERE date = ?',
          [
            jsonEncode(convertFoodPerHourListToJsonList(foodPerHourList)),
            settings.kcalGoal,
            settings.carbsGoal,
            settings.proteinGoal,
            settings.fatGoal,
            date,
          ],
        );
      } else {
        // Insert
        foodPerHourList.add(new FoodPerHour(
          kcal: kcal,
          carbs: carbs,
          protein: protein,
          fat: fat,
          hour: now.hour,
        ));

        await db.rawInsert(
          'INSERT INTO food (foodPerHour, kcalGoal, carbsGoal, proteinGoal, fatGoal, date) VALUES (?, ?, ?, ?, ?, ?)',
          [
            jsonEncode(convertFoodPerHourListToJsonList(foodPerHourList)),
            settings.kcalGoal,
            settings.carbsGoal,
            settings.proteinGoal,
            settings.fatGoal,
            date,
          ],
        );
      }

      await autoExportData();

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
    foodValues TEXT
    kcalGoal REAL
    carbsGoal REAL
    proteinGoal REAL
    fatGoal REAL
    REAL TEXT == DATE IT WAS ADDED

    - Settings Table
    id INTEGER
    userWeight TEXT (json)
    weightUnit TEXT
    kcalGoal REAL
    carbsGoal REAL
    proteinGoal REAL
    fatGoal REAL
    defaultRestTime INTEGER
    isRestTimerEnabled INTEGER
    isVibrateUponFinishEnabled INTEGER
    graphsToShow TEXT
*/
