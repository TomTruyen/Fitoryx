import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/body_weight.dart';
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/fat_percentage.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/subscription.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/services/cache_service.dart';
import 'package:fitoryx/utils/datetime_extension.dart';
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
  final String bodyWeightField = "bodyWeight";
  final String fatPercentageField = "fatPercentage";

  final String subscriptionField = "subscription";

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
      _cacheService.setBodyWeight(_toBodyWeight(doc));
      _cacheService.setFatPercentage(_toFatPercentage(doc));
      _cacheService.setSubscription(_toSubscription(doc));
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

    DateTime start = date.today();
    DateTime end = date.today().add(const Duration(days: 1));

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

  // Bodyweight
  List<BodyWeight> _toBodyWeight(DocumentSnapshot<Object?> doc) {
    try {
      List<dynamic> data = doc.get(bodyWeightField);

      List<BodyWeight> bodyweight = [];

      for (var weight in data) {
        bodyweight.add(BodyWeight.fromJson(weight));
      }

      return bodyweight;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> _fromBodyWeight(List<BodyWeight> bodyweight) {
    List<Map<String, dynamic>> data = [];

    for (var weight in bodyweight) {
      data.add(weight.toJson());
    }

    return data;
  }

  Future<List<BodyWeight>> getBodyWeight() async {
    if (!_cacheService.hasBodyWeight()) {
      await fetchAll();
    }

    var bodyWeight = _cacheService.getBodyWeight();

    bodyWeight.sort((a, b) => a.date.compareTo(b.date));

    return bodyWeight.reversed.toList();
  }

  Future<BodyWeight> saveBodyWeight(BodyWeight bodyWeight) async {
    List<BodyWeight> bodyWeightList = _cacheService.getBodyWeight();

    bodyWeight.id = _generateUuid();
    bodyWeightList.add(bodyWeight);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {bodyWeightField: _fromBodyWeight(bodyWeightList)},
      SetOptions(merge: true),
    );

    _cacheService.setBodyWeight(bodyWeightList);

    return bodyWeight;
  }

  // FatPercentage
  List<FatPercentage> _toFatPercentage(DocumentSnapshot<Object?> doc) {
    try {
      List<dynamic> data = doc.get(fatPercentageField);

      List<FatPercentage> percentage = [];

      for (var fat in data) {
        percentage.add(FatPercentage.fromJson(fat));
      }

      return percentage;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> _fromFatPercentage(
      List<FatPercentage> percentage) {
    List<Map<String, dynamic>> data = [];

    for (var fat in percentage) {
      data.add(fat.toJson());
    }

    return data;
  }

  Future<List<FatPercentage>> getFatPercentage() async {
    if (!_cacheService.hasFatPercentage()) {
      await fetchAll();
    }

    var percentage = _cacheService.getFatPercentage();

    percentage.sort((a, b) => a.date.compareTo(b.date));

    return percentage.reversed.toList();
  }

  Future<FatPercentage> saveFatPercentage(FatPercentage percentage) async {
    List<FatPercentage> percentageList = _cacheService.getFatPercentage();

    percentage.id = _generateUuid();
    percentageList.add(percentage);

    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {fatPercentageField: _fromFatPercentage(percentageList)},
      SetOptions(merge: true),
    );

    _cacheService.setFatPercentage(percentageList);

    return percentage;
  }

  // Subscription
  Subscription _toSubscription(DocumentSnapshot<Object?> doc) {
    try {
      dynamic data = doc.get(exerciseField);

      Subscription subscription = FreeSubscription();
      if (data['type'] == 'pro') {
        subscription = ProSubscription();
      }

      subscription.expiration = data['expiration']?.toDate();

      return subscription;
    } catch (e) {
      return FreeSubscription();
    }
  }

  Future<Subscription> getSubscription() async {
    if (!_cacheService.hasSubscription()) {
      await fetchAll();
    }

    return _cacheService.getSubscription();
  }

  Future<void> saveSubscription(Subscription subscription) async {
    await _usersCollection.doc(_authService.getUser()?.uid).set(
      {subscriptionField: subscription.toJson()},
      SetOptions(merge: true),
    );

    _cacheService.setSubscription(subscription);
  }
}
