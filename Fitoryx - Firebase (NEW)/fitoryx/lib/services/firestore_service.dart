import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/services/cache_service.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  // Singleton Setup
  static final FirestoreService _firstoreService = FirestoreService._internal();

  factory FirestoreService() {
    return _firstoreService;
  }

  FirestoreService._internal();

  // Properties
  final Uuid _uuid = const Uuid();
  final AuthService _authService = AuthService();
  final CacheService _cacheService = CacheService();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final String exerciseField = "exercises";
  final String workoutField = "workouts";
  final String historyField = "history";
  final String nutritionField = "nutrition";

  // "Ugly" version,
  // Advantage: 1 read per app launch :)

  String _generateUuid() {
    return _uuid.v4();
  }

  Future<bool> fetchAll() async {
    var doc = await _usersCollection.doc(_authService.getUser()?.uid).get();

    if (doc.exists) {
      _cacheService.setExercises(_toExercises(doc));
      _cacheService.setWorkouts(_toWorkouts(doc));
      _cacheService.setHistory(_toHistory(doc));
      _cacheService.setNutrition(_toNutrition(doc));
    }

    return true;
  }

  // Exercises
  List<Exercise> _toExercises(DocumentSnapshot<Object?> doc) {
    try {
      List<dynamic> data = doc.get(exerciseField);

      List<Exercise> exercises = [];

      for (var exercise in data) {
        exercises.add(Exercise.fromExerciseJson(exercise));
      }

      return exercises;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> _fromExercises(List<Exercise> exercises) {
    List<Map<String, dynamic>> data = [];

    for (var exercise in exercises) {
      data.add(exercise.toExerciseJson());
    }

    return data;
  }

  Future<List<Exercise>> getExercises() async {
    if (!_cacheService.hasExercises()) {
      await fetchAll();
    }

    return _cacheService.getExercises();
  }

  Future<Exercise> saveExercise(Exercise exercise) async {
    exercise.id = _generateUuid();
    exercise.userCreated = true;

    List<Exercise> exercises = _cacheService.getExercises();
    exercises.add(exercise);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {exerciseField: _fromExercises(exercises)},
      SetOptions(merge: true),
    );

    _cacheService.setExercises(exercises);

    return exercise;
  }

  Future<void> deleteExercise(String? id) async {
    List<Exercise> exercises = _cacheService.getExercises();
    exercises.removeWhere((exercise) => exercise.id == id);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {exerciseField: _fromExercises(exercises)},
      SetOptions(merge: true),
    );

    _cacheService.setExercises(exercises);
  }

  // Workouts
  List<Workout> _toWorkouts(DocumentSnapshot<Object?> doc) {
    try {
      List<dynamic> data = doc.get(workoutField);

      List<Workout> workouts = [];

      for (var workout in data) {
        workouts.add(Workout.fromJson(workout));
      }

      return workouts;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> _fromWorkouts(List<Workout> workouts) {
    List<Map<String, dynamic>> data = [];

    for (var workout in workouts) {
      data.add(workout.toJson());
    }

    return data;
  }

  Future<List<Workout>> getWorkouts() async {
    if (!_cacheService.hasWorkouts()) {
      await fetchAll();
    }

    return _cacheService.getWorkouts();
  }

  Future<Workout> saveWorkout(Workout workout, {bool duplicate = false}) async {
    List<Workout> workouts = _cacheService.getWorkouts();

    if (workout.id == null || duplicate) {
      workout.id = _generateUuid();
      workouts.add(workout);
    } else {
      int index = workouts.indexWhere((w) => w.id == workout.id);
      workouts[index] = workout;
    }

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {workoutField: _fromWorkouts(workouts)},
      SetOptions(merge: true),
    );

    _cacheService.setWorkouts(workouts);

    return workout;
  }

  Future<void> deleteWorkout(String? id) async {
    List<Workout> workouts = _cacheService.getWorkouts();
    workouts.removeWhere((workout) => workout.id == id);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {workoutField: _fromWorkouts(workouts)},
      SetOptions(merge: true),
    );

    _cacheService.setWorkouts(workouts);
  }

  // History
  List<WorkoutHistory> _toHistory(DocumentSnapshot<Object?> doc) {
    try {
      List<dynamic> data = doc.get(historyField);

      List<WorkoutHistory> history = [];

      for (var workout in data) {
        history.add(WorkoutHistory.fromJson(workout));
      }

      return history;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> _fromHistory(List<WorkoutHistory> history) {
    List<Map<String, dynamic>> data = [];

    for (var workout in history) {
      data.add(workout.toJson());
    }

    return data;
  }

  Future<List<WorkoutHistory>> getHistory() async {
    if (!_cacheService.hasHistory()) {
      await fetchAll();
    }

    return _cacheService.getHistory();
  }

  Future<List<WorkoutHistory>> getHistoryByDay(DateTime date) async {
    if (!_cacheService.hasHistory()) {
      await fetchAll();
    }

    DateTime start = DateTime(date.year, date.month, date.day);
    DateTime end = DateTime(date.year, date.month, date.day + 1);

    return _cacheService
        .getHistory()
        .where((history) =>
            history.date.isAfter(start) && history.date.isBefore(end))
        .toList();
  }

  Future<WorkoutHistory> saveHistory(WorkoutHistory history) async {
    List<WorkoutHistory> historyList = _cacheService.getHistory();

    history.id = _generateUuid();
    historyList.add(history);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {historyField: _fromHistory(historyList)},
      SetOptions(merge: true),
    );

    _cacheService.setHistory(historyList);

    return history;
  }

  Future<void> deleteHistory(String? id) async {
    List<WorkoutHistory> history = _cacheService.getHistory();
    history.removeWhere((workout) => workout.id == id);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {historyField: _fromHistory(history)},
      SetOptions(merge: true),
    );

    _cacheService.setHistory(history);
  }

  // Nutrition
  List<Nutrition> _toNutrition(DocumentSnapshot<Object?> doc) {
    try {
      List<dynamic> data = doc.get(nutritionField);

      List<Nutrition> nutritionList = [];

      for (var nutrition in data) {
        nutritionList.add(Nutrition.fromJson(nutrition));
      }

      return nutritionList;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> _fromNutrition(List<Nutrition> nutritionList) {
    List<Map<String, dynamic>> data = [];

    for (var nutrition in nutritionList) {
      data.add(nutrition.toJson());
    }

    return data;
  }

  Future<List<Nutrition>> getNutrition() async {
    if (!_cacheService.hasNutrition()) {
      await fetchAll();
    }

    return _cacheService.getNutrition();
  }

  Future<Nutrition> getNutritionByDay(DateTime date) async {
    date = DateTime(date.year, date.month, date.day);

    var nutrition = _cacheService
        .getNutrition()
        .where((nutrition) => nutrition.date.isAtSameMomentAs(date))
        .toList();

    if (nutrition.isEmpty) return Nutrition();

    return nutrition.first;
  }

  Future<Nutrition> saveNutrition(Nutrition nutrition) async {
    nutrition.id ??= _generateUuid();

    nutrition.date = DateTime(
      nutrition.date.year,
      nutrition.date.month,
      nutrition.date.day,
    );

    List<Nutrition> nutritionList = _cacheService.getNutrition();

    int index = nutritionList.indexWhere(
      (n) => n.date.isAtSameMomentAs(nutrition.date),
    );

    if (index > -1) {
      nutrition.kcal += nutritionList[index].kcal;
      nutrition.carbs += nutritionList[index].carbs;
      nutrition.protein += nutritionList[index].protein;
      nutrition.fat += nutritionList[index].fat;
      nutritionList[index] = nutrition;
    } else {
      nutritionList.add(nutrition);
    }

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {nutritionField: _fromNutrition(nutritionList)},
      SetOptions(merge: true),
    );

    _cacheService.setNutrition(nutritionList);

    return nutrition;
  }

  Future<void> deleteNutrition(String? id) async {
    List<Nutrition> nutritionList = _cacheService.getNutrition();
    nutritionList.removeWhere((nutrition) => nutrition.id == id);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {nutritionField: _fromNutrition(nutritionList)},
      SetOptions(merge: true),
    );

    _cacheService.setNutrition(nutritionList);
  }

  // Clean, split up into collections ==> Issue: a lot of reads.
  // My Goal: Stay within free quota for as long as possible
  // Solution: Move all data (exercises, workouts, history etc...) into 1 single collection
  // Reason: Firebase counts per document read/write. With collections we get a lot of documents. Without it, we only have 1 document and that document we even cache to make it so it only gets fetched once

  // final String exerciseCollection = "exercises";
  // final String workoutCollection = "workouts";
  // final String historyCollection = "history";
  // final String nutritionCollection = "nutrition";

  // // Exercises
  // Future<String> createExercise(Exercise exercise) async {
  //   DocumentReference<Map<String, dynamic>> docReference =
  //       await _usersCollection
  //           .doc(_authService.getUser()?.uid)
  //           .collection(exerciseCollection)
  //           .add(exercise.toExerciseJson());

  //   return docReference.id;
  // }

  // Future<void> deleteExercise(String? id) async {
  //   await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(exerciseCollection)
  //       .doc(id)
  //       .delete();
  // }

  // Future<List<Exercise>> getExercises() async {
  //   if (_cacheService.hasExercises()) {
  //     return _cacheService.getExercises();
  //   }

  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(exerciseCollection)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     return [];
  //   }

  //   List<Exercise> exercises = [];

  //   for (var exercise in querySnapshot.docs) {
  //     Exercise e = Exercise.fromExerciseJson(exercise.data());
  //     e.id = exercise.id;
  //     e.userCreated = true;
  //     exercises.add(e);
  //   }

  //   _cacheService.setExercises(exercises);

  //   return exercises;
  // }

  // // Workouts
  // Future<String> createWorkout(Workout workout) async {
  //   DocumentReference<Map<String, dynamic>> docReference =
  //       await _usersCollection
  //           .doc(_authService.getUser()?.uid)
  //           .collection(workoutCollection)
  //           .add(workout.toJson());

  //   return docReference.id;
  // }

  // Future<void> updateWorkout(Workout workout) async {
  //   await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(workoutCollection)
  //       .doc(workout.id)
  //       .update(workout.toJson());
  // }

  // Future<void> deleteWorkout(String? id) async {
  //   await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(workoutCollection)
  //       .doc(id)
  //       .delete();
  // }

  // Future<List<Workout>> getWorkouts() async {
  //   if (_cacheService.hasWorkouts()) {
  //     return _cacheService.getWorkouts();
  //   }

  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(workoutCollection)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     return [];
  //   }

  //   List<Workout> workouts = [];

  //   for (var workout in querySnapshot.docs) {
  //     Workout w = Workout.fromJson(workout.data());
  //     w.id = workout.id;

  //     workouts.add(w);
  //   }

  //   _cacheService.setWorkouts(workouts);

  //   return workouts;
  // }

  // // History
  // Future<String> createWorkoutHistory(WorkoutHistory history) async {
  //   DocumentReference<Map<String, dynamic>> docReference =
  //       await _usersCollection
  //           .doc(_authService.getUser()?.uid)
  //           .collection(historyCollection)
  //           .add(history.toJson());

  //   return docReference.id;
  // }

  // Future<void> deleteHistory(String? id) async {
  //   await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(historyCollection)
  //       .doc(id)
  //       .delete();
  // }

  // Future<List<WorkoutHistory>> getWorkoutHistory() async {
  //   if (_cacheService.hasHistory()) {
  //     return _cacheService.getHistory();
  //   }

  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(historyCollection)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     return [];
  //   }

  //   List<WorkoutHistory> workoutHistory = [];

  //   for (var history in querySnapshot.docs) {
  //     WorkoutHistory w = WorkoutHistory.fromJson(history.data());
  //     w.id = history.id;

  //     workoutHistory.add(w);
  //   }

  //   _cacheService.setHistory(workoutHistory);

  //   return workoutHistory;
  // }

  // Future<List<WorkoutHistory>> getWorkoutHistoryByDay(DateTime date) async {
  //   DateTime startDate = DateTime(date.year, date.month, date.day);
  //   DateTime endDate = DateTime(date.year, date.month, date.day + 1);

  //   if (_cacheService.hasHistory()) {
  //     return _cacheService
  //         .getHistory()
  //         .where((history) =>
  //             history.date.isAfter(startDate) && history.date.isBefore(endDate))
  //         .toList();
  //   }

  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(historyCollection)
  //       .where('date', isGreaterThanOrEqualTo: startDate)
  //       .where('date', isLessThan: endDate)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     return [];
  //   }

  //   List<WorkoutHistory> workoutHistory = [];

  //   for (var history in querySnapshot.docs) {
  //     WorkoutHistory w = WorkoutHistory.fromJson(history.data());
  //     w.id = history.id;

  //     workoutHistory.add(w);
  //   }

  //   return workoutHistory;
  // }

  // // Nutrition
  // Future<List<Nutrition>> getNutrition() async {
  //   if (_cacheService.hasNutrition()) {
  //     return _cacheService.getNutrition();
  //   }

  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
  //       .doc(_authService.getUser()?.uid)
  //       .collection(nutritionCollection)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     return [];
  //   }

  //   List<Nutrition> nutritionList = [];

  //   for (var nutrition in querySnapshot.docs) {
  //     Nutrition n = Nutrition.fromJson(nutrition.data());
  //     n.id = nutrition.id;

  //     nutritionList.add(n);
  //   }

  //   return nutritionList;
  // }
}
