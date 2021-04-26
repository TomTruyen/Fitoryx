// PubDev Packages
import 'package:fittrack/model/Appdata.dart';
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/model/settings/Settings.dart';
import 'package:fittrack/model/workout/Workout.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

// My Packages
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';

// My Converters
import 'package:fittrack/services/Converters.dart';

class Database {
  final Uuid idGenerator = Uuid();

  String uid;
  Db db;

  Database({this.uid = ""});

  // Connection
  Future<bool> openConnection() async {
    try {
      db = await Db.create(
        "mongodb+srv://TomTruyen:iLlLVRhwvNTxAQ2B@fittrack.r0cg5.mongodb.net/FitTrack?retryWrites=true&w=majority",
      );

      await db.open();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> closeConnection() async {
    try {
      if (db != null) {
        await db.close();
        db = null;
      }
    } catch (e) {
      print("Failed to close connection");
    }
  }

  // Load all database things (little faster than seperate loads)
  Future<Map> loadDatabase() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      Map _user = await db.collection("users").findOne(
            where.eq("uid", uid).fields(
              ["settings", "workouts", "workoutHistory", "nutritionHistory"],
            ),
          );

      Settings _settings = convertToSettings(_user['settings']);
      List<Workout> _workouts = convertToWorkoutList(_user['workouts'] ?? null);
      List<WorkoutHistory> _workoutHistory = convertToWorkoutHistory(
        _user['workoutHistory'] ?? null,
      );
      List<Nutrition> _nutritionHistory = convertToNutritionHistory(
        _user['nutritionHistory'] ?? null,
      );

      Appdata _appdata = await getAppData();
      List<Exercise> _exercises = await getExercises();
      List<ExerciseCategory> _categories = await getCategories();
      List<ExerciseEquipment> _equipment = await getEquipment();

      return {
        'appdata': _appdata,
        'exercises': _exercises,
        'categories': _categories,
        'equipment': _equipment,
        'settings': _settings,
        'workouts': _workouts,
        'workoutHistory': _workoutHistory,
        'nutritionHistory': _nutritionHistory,
      };
    } catch (e) {
      print("ERROR: " + e.toString());
      return null;
    } finally {
      await closeConnection();
    }
  }

  // User
  Future<bool> createUser(String uid, String email, String name) async {
    try {
      await db.collection("users").update(
        {
          'uid': uid,
          'email': email,
        },
        {
          'uid': uid,
          'email': email,
          'name': name,
          'settings': Settings.defaultSettings(),
          'workouts': [],
          'workoutHistory': [],
          'nutritionHistory': [],
        },
        upsert: true,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete UserData
  Future<bool> deleteUserData(String email, String name) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      await db.collection("users").update(
        where.eq("uid", uid),
        {
          'uid': uid,
          'email': email,
          'name': name,
          'settings': Settings.defaultSettings(),
          'workouts': [],
          'workoutHistory': [],
          'nutritionHistory': [],
        },
      );

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // AppData
  Future<Appdata> getAppData() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      List<Map<String, dynamic>> appdata =
          await db.collection("appdata").find().toList();

      Map _appdata = appdata[0];

      return convertToAppData(_appdata);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Get Settings
  Future<Settings> getSettings() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      Map<String, dynamic> settings = await db.collection("users").findOne(
          where.eq('uid', uid).fields(['settings']).excludeFields(["_id"]));

      return convertToSettings(settings['settings']);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Update Settings
  Future<bool> updateSettings(Settings settings) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      await db.collection("users").update(
            where.eq("uid", uid),
            modify.set('settings', settings.toJSON()),
            upsert: true,
          );

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Get WorkoutHistory
  Future<List<WorkoutHistory>> getWorkoutHistory() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      Map<String, dynamic> workoutHistory = await db
          .collection("users")
          .findOne(where.eq('uid', uid).fields(['workoutHistory']));

      List _workoutHistory = workoutHistory['workoutHistory'];

      return convertToWorkoutHistory(_workoutHistory);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Delete WorkoutHistory
  Future<bool> deleteWorkoutHistory(
      List<WorkoutHistory> workoutHistory, String id) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      List<Map<String, dynamic>> _workoutHistory = [];

      workoutHistory.forEach((workout) {
        if (workout.id != id) {
          _workoutHistory.add(workout.toJSON());
        }
      });

      await db.collection("users").update(
          where.eq("uid", uid), modify.set("workoutHistory", _workoutHistory));

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Get workouts
  Future<List<Workout>> getWorkouts() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      Map<String, dynamic> workouts = await db
          .collection("users")
          .findOne(where.eq('uid', uid).fields(['workouts']));

      List _workouts = workouts['workouts'];

      return convertToWorkoutList(_workouts);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Add Workout
  Future<bool> addWorkout(
    WorkoutChangeNotifier workout,
    List<Workout> workouts,
  ) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      workout.id = idGenerator.v4();
      if (workout.name == "") {
        workout.name = "Workout";
      }

      List<Map<String, dynamic>> _workouts = [];

      workouts.forEach((_workout) {
        _workouts.add(_workout.toJSON());
      });

      _workouts.add(workout.toJSON());

      await db
          .collection("users")
          .update(where.eq("uid", uid), modify.set("workouts", _workouts));

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Edit Workout
  Future<bool> editWorkout(
    WorkoutChangeNotifier workout,
    List<Workout> workouts,
  ) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      if (workout.name == "") {
        workout.name = "Workout";
      }

      List<Map<String, dynamic>> _workouts = [];

      workouts.forEach((_workout) {
        if (_workout.id == workout.id) {
          _workouts.add(workout.toJSON());
        } else {
          _workouts.add(_workout.toJSON());
        }
      });

      await db
          .collection("users")
          .update(where.eq("uid", uid), modify.set("workouts", _workouts));

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Duplicate Workout
  Future<bool> duplicateWorkout(Workout workout, List<Workout> workouts) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      List<Map<String, dynamic>> _workouts = [];

      workouts.forEach((_workout) {
        _workouts.add(_workout.toJSON());
      });

      workout.id = idGenerator.v4();
      _workouts.add(workout.toJSON());

      await db
          .collection("users")
          .update(where.eq("uid", uid), modify.set("workouts", _workouts));

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Delete Workout
  Future<bool> deleteWorkout(Workout workout, List<Workout> workouts) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      List<Map<String, dynamic>> _workouts = [];

      workouts.forEach((_workout) {
        if (_workout.id != workout.id) {
          _workouts.add(_workout.toJSON());
        }
      });

      await db
          .collection("users")
          .update(where.eq("uid", uid), modify.set("workouts", _workouts));

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Reorder Workout
  Future<bool> reorderWorkout(
    List<Workout> workouts,
  ) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      List<Map<String, dynamic>> _workouts = [];

      workouts.forEach((_workout) {
        _workouts.add(_workout.toJSON());
      });

      await db
          .collection("users")
          .update(where.eq("uid", uid), modify.set("workouts", _workouts));

      return true;
    } catch (e) {
      print("REORDER FAIL " + e.toString());
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Finish Workout
  Future<bool> finishWorkout(
    WorkoutChangeNotifier workout,
    String timeToDisplay,
  ) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      Map<String, dynamic> _workout = workout.toJSON();
      _workout['workout_id'] = idGenerator.v4();
      _workout['workoutDuration'] = timeToDisplay;

      await db.collection("users").update(
            where.eq("uid", uid),
            modify.push('workoutHistory', _workout),
            upsert: true,
          );

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Get Exercises
  Future<List<Exercise>> getExercises() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      List exercises = await db
          .collection('exercises')
          .find(where.sortBy("name").sortBy("equipment"))
          .toList();

      Map<String, dynamic> userExercises = await db.collection('users').findOne(
            where
                .eq('uid', uid)
                .fields(["exercises"])
                .sortBy('name')
                .sortBy("equipment"),
          );

      List _userExercises = userExercises['exercises'];

      if (_userExercises.length > 0) {
        _userExercises.forEach((userExercise) {
          exercises.add(userExercise);
        });
      }

      return convertToExerciseList(exercises);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Add Exercise
  Future<bool> addExercise(
    String name,
    String category,
    String equipment,
    bool isCompound,
  ) async {
    try {
      if (uid == "") {
        return false;
      }

      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      Map<String, dynamic> _exercise = {
        "exercise_id": idGenerator.v4(),
        "name": name,
        "category": category,
        "equipment": equipment,
        "isCompound": isCompound,
        "isUserCreated": true,
      };

      await db.collection("users").update(
            where.eq("uid", uid),
            modify.push('exercises', _exercise),
            upsert: true,
          );

      return true;
    } catch (e) {
      print("ERROR; " + e.toString());
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Delete Exercise
  Future<bool> deleteExercise(
    List<dynamic> exercises,
    String exerciseID,
  ) async {
    try {
      if (uid == "") {
        return false;
      }

      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      List<Map<String, dynamic>> _exercises = [];

      exercises.forEach((exercise) {
        if (exercise is Exercise) {
          if (exercise.isUserCreated && exercise.id != exerciseID) {
            _exercises.add(exercise.toJSON());
          }
        }
      });

      await db
          .collection("users")
          .update(where.eq("uid", uid), modify.set('exercises', _exercises));

      return true;
    } catch (e) {
      print("ERROR; " + e.toString());
      return false;
    } finally {
      await closeConnection();
    }
  }

  // Get Categories
  Future<List<ExerciseCategory>> getCategories() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      List<Map<String, dynamic>> categories =
          await db.collection('categories').find(where.sortBy("name")).toList();

      return convertToCategoryList(categories);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Get Equipment
  Future<List<ExerciseEquipment>> getEquipment() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      List<Map<String, dynamic>> equipment =
          await db.collection('equipment').find(where.sortBy("name")).toList();

      return convertToEquipmentList(equipment);
    } catch (e) {
      return null;
    } finally {
      await closeConnection();
    }
  }

  // Get NutritionHistory {
  Future<List<Nutrition>> getNutritionHistory() async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return null;
      }

      Map nutritionHistory = await db
          .collection("users")
          .findOne(where.eq("uid", uid).fields(["nutritionHistory"]));

      List _nutritionHistory = nutritionHistory['nutritionHistory'];

      return convertToNutritionHistory(_nutritionHistory);
    } catch (e) {
      print("ERROR: " + e.toString());
      return null;
    } finally {
      await closeConnection();
    }
  }

  Future<bool> addNutrition(
    Nutrition nutrition,
    List<Nutrition> nutritionHistory,
  ) async {
    try {
      bool connectionOpened = await openConnection();
      if (!connectionOpened) {
        return false;
      }

      List<Map<String, dynamic>> _nutritionHistory = [];

      bool nutritionAdded = false;
      nutritionHistory.forEach((Nutrition _nutrition) {
        if (nutrition.date == _nutrition.date) {
          Nutrition _combinedNutrition = Nutrition(
            kcal: nutrition.kcal + _nutrition.kcal,
            carbs: nutrition.carbs + _nutrition.carbs,
            protein: nutrition.protein + _nutrition.protein,
            fat: nutrition.fat + _nutrition.fat,
            date: nutrition.date,
          );

          _nutritionHistory.add(_combinedNutrition.toJSON());
          nutritionAdded = true;
        } else {
          _nutritionHistory.add(_nutrition.toJSON());
        }
      });

      if (!nutritionAdded) {
        _nutritionHistory.add(nutrition.toJSON());
      }

      await db.collection("users").update(
            where.eq("uid", uid),
            modify.set("nutritionHistory", _nutritionHistory),
          );

      return true;
    } catch (e) {
      return false;
    } finally {
      await closeConnection();
    }
  }
}
