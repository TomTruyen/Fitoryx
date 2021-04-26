import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/models/AppData.dart';
import 'package:fitness_app/models/profile/WeightGoal.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/exercises/Exercise.dart';
import 'package:fitness_app/models/exercises/ExerciseCategory.dart';
import 'package:fitness_app/models/exercises/ExerciseEquipment.dart';
import 'package:fitness_app/models/exercises/UserExercise.dart';
import 'package:fitness_app/models/food/Nutrition.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/profile/WorkoutsPerWeekGoal.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/models/workout/WorkoutExerciseSet.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid = ""});

  // User collection
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  // Exercise Collection
  final CollectionReference exerciseCollection =
      Firestore.instance.collection('exercises');

  // Category Collection
  final CollectionReference categoryCollection =
      Firestore.instance.collection('categories');

  // Equipment Collection
  final CollectionReference equipmentCollection =
      Firestore.instance.collection('equipment');

  // Notification Collection
  final CollectionReference notificationCollection =
      Firestore.instance.collection('notifications');

  // Appdata Collection
  final CollectionReference appdataCollection =
      Firestore.instance.collection('appdata');

  // Set default value for user (on sign up)
  Future updateUserData(String fullName, String email) async {
    try {
      await userCollection.document(uid).setData({
        'fullName': fullName,
        'email': email,
        'time': DateTime.now(),
      });

      await userCollection
          .document(uid)
          .collection('settings')
          .document()
          .setData(UserSettings.defaultSettings());

      return true; //just so it doesn't return 'null'
    } catch (e) {
      print("ERROR UPDATE USER DATA: " + e.toString());
      return null;
    }
  }

// Reset user data
  Future resetUserData(User user) async {
    try {
      await userCollection
          .document(user.uid)
          .collection('workouts')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
        }
      });

      await userCollection
          .document(user.uid)
          .collection('workoutsHistory')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
        }
      });

      await userCollection
          .document(user.uid)
          .collection('exercises')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
        }
      });

      await userCollection
          .document(user.uid)
          .collection('settings')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.setData(UserSettings.defaultSettings());
        }
      });

      return true;
    } catch (e) {
      return null;
    }
  }

  // Add Exercise (UserExercise)
  Future addExercise(
      String name, String category, String equipment, bool isCompound) async {
    final Map<String, dynamic> exercise = {
      'name': name,
      'category': category,
      'equipment': equipment,
      'isCompound': isCompound,
    };

    try {
      await userCollection
          .document(uid)
          .collection('exercises')
          .document()
          .setData(exercise);

      return true;
    } catch (e) {
      return null;
    }
  }

  // Add Nutrition
  Future addNutrition(int kcal, int carbs, int protein, int fat) async {
    final DateTime now = DateTime.now();

    final Map<String, dynamic> nutrition = {
      'kcal': int.parse(kcal.toStringAsFixed(0)),
      'carbs': int.parse(carbs.toStringAsFixed(0)),
      'protein': int.parse(protein.toStringAsFixed(0)),
      'fat': int.parse(fat.toStringAsFixed(0)),
      'time': "${now.day}-${now.month}-${now.year}",
    };

    try {
      await userCollection
          .document(uid)
          .collection('nutrition')
          .document()
          .setData(nutrition);

      return true;
    } catch (e) {
      return null;
    }
  }

  // Get Nutrition
  Nutrition _nutritionFromSnapshot(QuerySnapshot snapshot) {
    int kcal = 0;
    int carbs = 0;
    int protein = 0;
    int fat = 0;

    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].data != null) {
        kcal +=
            (int.parse(snapshot.documents[i].data['kcal'].toStringAsFixed(0)) ??
                0);
        carbs += (int.parse(
                snapshot.documents[i].data['carbs'].toStringAsFixed(0)) ??
            0);
        protein += (int.parse(
                snapshot.documents[i].data['protein'].toStringAsFixed(0)) ??
            0);
        fat +=
            (int.parse(snapshot.documents[i].data['fat'].toStringAsFixed(0)) ??
                0);
      }
    }

    final DateTime now = DateTime.now();

    return Nutrition(
      kcal: kcal,
      carbs: carbs,
      protein: protein,
      fat: fat,
      date: "${now.day}-${now.month}-${now.year}",
    );
  }

  Stream<Nutrition> get nutrition {
    final DateTime now = DateTime.now();

    return userCollection
        .document(uid)
        .collection('nutrition')
        .where('time', isEqualTo: "${now.day}-${now.month}-${now.year}")
        .snapshots()
        .map(_nutritionFromSnapshot);
  }

  // Workouts

  // Add
  Future addWorkout(WorkoutChangeNotifier workout,
      List<WorkoutStreamProvider> workoutList) async {
    try {
      List<Map<String, dynamic>> _workouts = [];

      for (int i = 0; i < workoutList.length; i++) {
        _workouts.add(workoutList[i].toJson());
      }

      // Create UniqueID
      String now = DateTime.now().toString();
      var bytes = utf8.encode(now);
      var uniqueID = sha512.convert(bytes);

      workout.id = uniqueID.toString();

      _workouts.add(workout.toJson());

      await userCollection.document(uid).updateData({'workouts': _workouts});

      return true;
    } catch (e) {
      return null;
    }
  }

  // Edit
  Future editWorkout(
    WorkoutChangeNotifier workout,
    List<WorkoutStreamProvider> workoutList,
  ) async {
    //
    try {
      List<Map<String, dynamic>> _workouts = [];

      for (int i = 0; i < workoutList.length; i++) {
        if (workoutList[i].id == workout.id) {
          _workouts.add(workout.toJson());
        } else {
          _workouts.add(workoutList[i].toJson());
        }
      }

      await userCollection.document(uid).updateData({'workouts': _workouts});

      return true;
    } catch (e) {
      return null;
    }
  }

  // Duplicate
  Future duplicateWorkout(
    WorkoutStreamProvider workout,
    List<WorkoutStreamProvider> workoutList,
  ) async {
    try {
      List<Map<String, dynamic>> _workouts = [];

      for (int i = 0; i < workoutList.length; i++) {
        _workouts.add(workoutList[i].toJson());
      }

      String now = DateTime.now().toString();
      var bytes = utf8.encode(now);
      var uniqueID = sha512.convert(bytes);

      workout.id = uniqueID.toString();

      _workouts.add(workout.toJson());

      await userCollection.document(uid).updateData({'workouts': _workouts});

      return true;
    } catch (e) {
      return null;
    }
  }

  // Delete
  Future removeWorkout(
    WorkoutStreamProvider workout,
    List<WorkoutStreamProvider> workoutList,
  ) async {
    try {
      List<Map<String, dynamic>> _workouts = [];

      for (int i = 0; i < workoutList.length; i++) {
        if (workoutList[i].id != workout.id) {
          _workouts.add(workoutList[i].toJson());
        }
      }

      await userCollection.document(uid).updateData({'workouts': _workouts});

      return true;
    } catch (e) {
      return null;
    }
  }

  // Finish
  Future finishWorkout(
      WorkoutChangeNotifier workout, String timeToDisplay) async {
    Map<String, dynamic> workoutJSON = workout.toJson();

    workoutJSON.putIfAbsent('workoutDuration', () => timeToDisplay);
    try {
      await userCollection
          .document(uid)
          .collection('workoutsHistory')
          .document()
          .setData(workoutJSON);

      return true;
    } catch (e) {
      return null;
    }
  }

  // Reorder
  Future reorderWorkout(
    int oldIndex,
    int newIndex,
    List<WorkoutStreamProvider> workoutList,
  ) async {
    try {
      List<Map<String, dynamic>> _workouts = [];

      for (int i = 0; i < workoutList.length; i++) {
        _workouts.add(workoutList[i].toJson());
      }

      Map<String, dynamic> item = _workouts.removeAt(oldIndex);
      _workouts.insert(newIndex, item);

      await userCollection.document(uid).updateData({'workouts': _workouts});

      return true;
    } catch (e) {
      return null;
    }
  }

  // Get
  List<WorkoutStreamProvider> _workoutStreamProviderListFromSnapshot(
    DocumentSnapshot snapshot,
  ) {
    //
    WorkoutExerciseSet _buildWorkoutExerciseSet(dynamic _set) {
      return WorkoutExerciseSet(
        reps: _set['reps'] ?? 0,
        weight: _set['weight'] ?? 0.0,
      );
    }

    List<WorkoutExerciseSet> _buildWorkoutExerciseSetList(dynamic sets) {
      List<WorkoutExerciseSet> setList = [];

      for (int i = 0; i < sets.length; i++) {
        setList.add(_buildWorkoutExerciseSet(sets[i]));
      }

      return setList;
    }

    WorkoutExercise _buildWorkoutExercise(dynamic exercise) {
      return WorkoutExercise(
        name: exercise['exerciseName'] ?? '',
        category: exercise['exerciseCategory'] ?? '',
        equipment: exercise['exerciseEquipment'] ?? '',
        isCompound: exercise['isCompound'] ?? false,
        restEnabled: exercise['restEnabled'] ?? true,
        restSeconds: exercise['restSeconds'] ?? 60,
        hasNotes: exercise['hasNotes'] ?? false,
        notes: exercise['notes'] ?? '',
        sets: _buildWorkoutExerciseSetList(exercise['sets']),
      );
    }

    List<WorkoutExercise> _buildWorkoutExerciseList(List<dynamic> exercises) {
      List<WorkoutExercise> workoutExerciseList = [];

      for (int i = 0; i < exercises.length; i++) {
        workoutExerciseList.add(
          _buildWorkoutExercise(exercises[i]),
        );
      }

      return workoutExerciseList;
    }

    WorkoutStreamProvider _buildWorkout(dynamic workout) {
      return WorkoutStreamProvider(
        id: workout['id'] ?? '',
        name: workout['workoutName'] ?? '',
        workoutNote: workout['workoutNote'] ?? '',
        weightUnit: workout['weightUnit'] ?? 'metric',
        exercises: _buildWorkoutExerciseList(workout['exercises']),
      );
    }

    List<WorkoutStreamProvider> workoutList = [];

    if (snapshot.exists && snapshot.data != null) {
      if (snapshot.data['workouts'] != null) {
        List<dynamic> workouts = snapshot.data['workouts'];

        for (int i = 0; i < workouts.length; i++) {
          workoutList.add(_buildWorkout(workouts[i]));
        }
      }
    }

    return workoutList;
  }

  Stream<List<WorkoutStreamProvider>> get workouts {
    return userCollection
        .document(uid)
        .snapshots()
        .map(_workoutStreamProviderListFromSnapshot);
  }

  // Workout History

  // Get workoutHistory
  List<WorkoutHistory> _workoutHistoryListFromSnapshot(QuerySnapshot snapshot) {
    List<WorkoutExerciseSet> _buildWorkoutExerciseSetList(List dbSets) {
      List<WorkoutExerciseSet> sets = [];

      for (int i = 0; i < dbSets.length; i++) {
        sets.add(WorkoutExerciseSet(
          reps: dbSets[i]['reps'] is String
              ? int.parse(dbSets[i]['reps'] ?? 0)
              : dbSets[i]['reps'] ?? '',
          weight: dbSets[i]['weight'] is String
              ? double.parse(dbSets[i]['weight'] ?? 0.0)
              : dbSets[i]['weight'] ?? '',
        ));
      }

      return sets;
    }

    List<WorkoutExercise> _buildWorkoutExerciseList(List dbExercises) {
      List<WorkoutExercise> exercises = [];

      for (int i = 0; i < dbExercises.length; i++) {
        exercises.add(WorkoutExercise(
          name: dbExercises[i]['exerciseName'] ?? '',
          category: dbExercises[i]['exerciseCategory'] ?? '',
          isCompound: dbExercises[i]['isCompound'] ?? false,
          sets: _buildWorkoutExerciseSetList(dbExercises[i]['sets'] ?? []),
          restEnabled: dbExercises[i]['restEnabled'] ?? true,
          restSeconds: dbExercises[i]['restSeconds'] ?? 60,
          hasNotes: dbExercises[i]['hasNotes'] ?? false,
          notes: dbExercises[i]['notes'] ?? '',
        ));
      }

      return exercises;
    }

    List<WorkoutHistory> workouts = [];

    if (snapshot.documents != null) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i].data != null) {
          workouts.add(
            WorkoutHistory(
              id: snapshot.documents[i].documentID ?? '',
              name: snapshot.documents[i].data['workoutName'] ?? '',
              workoutNote: snapshot.documents[i].data['note'] ?? '',
              weightUnit: snapshot.documents[i].data['weightUnit'] ?? 'metric',
              workoutTime:
                  (snapshot.documents[i].data['time'] as Timestamp).toDate() ??
                      DateTime.now(),
              workoutDuration:
                  snapshot.documents[i].data['workoutDuration'] ?? '',
              exercises: _buildWorkoutExerciseList(
                  snapshot.documents[i].data['exercises'] ?? []),
            ),
          );
        }
      }
    }

    return workouts;
  }

  Stream<List<WorkoutHistory>> get workoutHistory {
    return userCollection
        .document(uid)
        .collection('workoutsHistory')
        .orderBy('time', descending: true)
        .snapshots()
        .map(_workoutHistoryListFromSnapshot);
  }

  // Delete workout history
  Future removeWorkoutHistory(String id) async {
    try {
      await userCollection
          .document(uid)
          .collection('workoutsHistory')
          .document(id)
          .delete();

      return true;
    } catch (e) {
      return null;
    }
  }

  // Get List of Exercises
  List<Exercise> _exerciseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Exercise(
        name: doc.data['name'] ?? '',
        category: doc.data['category'] ?? '',
        equipment: doc.data['equipment'] ?? '',
        isCompound: doc.data['isCompound'] ?? false,
      );
    }).toList();
  }

  Stream<List<Exercise>> get exercises {
    return exerciseCollection
        .orderBy('name')
        .snapshots()
        .map(_exerciseListFromSnapshot);
  }

  // Get List of UserExercises
  List<UserExercise> _userExerciseListFromSnapshot(QuerySnapshot snapshot) {
    List<UserExercise> userExercises = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].data != null) {
        userExercises.add(
          UserExercise(
            id: snapshot.documents[i].documentID,
            name: snapshot.documents[i].data['name'] ?? '',
            category: snapshot.documents[i].data['category'] ?? '',
            equipment: snapshot.documents[i].data['equipment'] ?? '',
            isCompound: snapshot.documents[i].data['isCompound'] ?? false,
          ),
        );
      }
    }

    return userExercises;
  }

  Stream<List<UserExercise>> get userExercises {
    return userCollection
        .document(uid)
        .collection('exercises')
        .snapshots()
        .map(_userExerciseListFromSnapshot);
  }

  // Delete UserExecise
  Future deleteUserExercise(String exerciseID) async {
    try {
      await userCollection
          .document(uid)
          .collection('exercises')
          .document(exerciseID)
          .delete();

      return true;
    } catch (e) {
      return null;
    }
  }

  // Get List of Categories
  List<ExerciseCategory> _exerciseCategoryListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ExerciseCategory(name: doc.data['category'] ?? '');
    }).toList();
  }

  Stream<List<ExerciseCategory>> get categories {
    return categoryCollection
        .snapshots()
        .map(_exerciseCategoryListFromSnapshot);
  }

  // Get List of Equipment
  List<ExerciseEquipment> _exerciseEquipmentListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ExerciseEquipment(name: doc.data['equipment'] ?? '');
    }).toList();
  }

  Stream<List<ExerciseEquipment>> get equipment {
    return equipmentCollection
        .snapshots()
        .map(_exerciseEquipmentListFromSnapshot);
  }

  // Update User Settings
  Future updateSettings(UserSettings settings) async {
    try {
      await userCollection
          .document(uid)
          .collection('settings')
          .document(settings.id)
          .setData(settings.toJSON());

      return true;
    } catch (e) {
      return null;
    }
  }

  // Get User Settings
  UserSettings _userSettingsFromSnapshot(QuerySnapshot snapshot) {
    WorkoutsPerWeekGoal _convertToWorkoutsPerWeekGoal(
      Map<String, dynamic> workoutsPerWeekGoal,
    ) {
      if (workoutsPerWeekGoal == null) {
        return WorkoutsPerWeekGoal();
      }

      return WorkoutsPerWeekGoal(
        isEnabled: workoutsPerWeekGoal['isEnabled'],
        goal: workoutsPerWeekGoal['goal'],
      );
    }

    WeightGoal _convertToWeightGoal(
      Map<String, dynamic> weightGoal,
      String weightUnit,
    ) {
      if (weightGoal == null) {
        return WeightGoal(
          weightUnit: weightUnit == null ? "metric" : weightUnit,
        );
      }

      return WeightGoal(
        isEnabled: weightGoal['isEnabled'],
        goal: weightGoal['goal'],
        weightUnit: weightGoal['weightUnit'],
      );
    }

    return UserSettings(
      id: snapshot.documents[0].documentID ?? '',
      progressiveOverload:
          snapshot.documents[0].data['progressiveOverload'] ?? false,
      vibrateUponFinish:
          snapshot.documents[0].data['vibrateUponFinish'] ?? true,
      developerMode: snapshot.documents[0].data['developerMode'] ?? false,
      timerIncrementValue:
          snapshot.documents[0].data['timerIncrementValue'] ?? 30,
      weightUnit: snapshot.documents[0].data['weightUnit'] ?? 'metric',
      heightUnit: snapshot.documents[0].data['heightUnit'] ?? 'metric',
      weightHistory: snapshot.documents[0].data['weightHistory'] ?? [],
      heightHistory: snapshot.documents[0].data['heightHistory'] ?? [],
      nutritionGoals: snapshot.documents[0].data['nutritionGoals'] ?? null,
      workoutsPerWeekGoal: _convertToWorkoutsPerWeekGoal(
            snapshot.documents[0].data['workoutsPerWeekGoal'],
          ) ??
          WorkoutsPerWeekGoal(),
      weightGoal: _convertToWeightGoal(
            snapshot.documents[0].data['weightGoal'],
            snapshot.documents[0].data['weightUnit'],
          ) ??
          WeightGoal(),
    );
  }

  Stream<UserSettings> get settings {
    return userCollection
        .document(uid)
        .collection('settings')
        .snapshots()
        .map(_userSettingsFromSnapshot);
  }

  // AppData
  AppData _appdataFromSnapshot(QuerySnapshot snapshot) {
    if (snapshot.documents.length > 0) {
      return AppData(version: snapshot.documents[0].data['version'] ?? '1.0.0');
    } else {
      return AppData();
    }
  }

  Stream<AppData> get appdata {
    return appdataCollection.snapshots().map(_appdataFromSnapshot);
  }
}
