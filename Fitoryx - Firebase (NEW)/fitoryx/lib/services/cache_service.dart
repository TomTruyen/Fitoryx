import 'package:fitoryx/models/body_weight.dart';
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/fat_percentage.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';

class CacheService {
  // Singleton Setup
  static final CacheService _cacheService = CacheService._internal();

  factory CacheService() {
    return _cacheService;
  }

  CacheService._internal();

  List<WorkoutHistory>? _cachedHistory;
  List<Workout>? _cachedWorkouts;
  List<Exercise>? _cachedExercises;
  List<Nutrition>? _cachedNutrition;
  List<BodyWeight>? _cachedBodyweight;
  List<FatPercentage>? _cachedFatPercentage;

  void clear() {
    _cachedHistory = null;
    _cachedWorkouts = null;
    _cachedExercises = null;
    _cachedNutrition = null;
    _cachedBodyweight = null;
    _cachedFatPercentage = null;
  }

  bool hasHistory() {
    return _cachedHistory != null;
  }

  void setHistory(List<WorkoutHistory> history) {
    _cachedHistory = List.of(history);
  }

  List<WorkoutHistory> getHistory() {
    return List.of(_cachedHistory ?? []);
  }

  bool hasWorkouts() {
    return _cachedWorkouts != null;
  }

  void setWorkouts(List<Workout> workouts) {
    _cachedWorkouts = List.of(workouts);
  }

  List<Workout> getWorkouts() {
    return List.of(_cachedWorkouts ?? []);
  }

  bool hasExercises() {
    return _cachedExercises != null;
  }

  void setExercises(List<Exercise> exercises) {
    _cachedExercises = List.of(exercises);
  }

  List<Exercise> getExercises() {
    return List.of(_cachedExercises ?? []);
  }

  bool hasNutrition() {
    return _cachedNutrition != null;
  }

  void setNutrition(List<Nutrition> nutrition) {
    _cachedNutrition = List.of(nutrition);
  }

  List<Nutrition> getNutrition() {
    return List.of(_cachedNutrition ?? []);
  }

  bool hasBodyWeight() {
    return _cachedBodyweight != null;
  }

  void setBodyWeight(List<BodyWeight> bodyWeight) {
    _cachedBodyweight = List.of(bodyWeight);
  }

  List<BodyWeight> getBodyWeight() {
    return List.of(_cachedBodyweight ?? []);
  }

  bool hasFatPercentage() {
    return _cachedFatPercentage != null;
  }

  void setFatPercentage(List<FatPercentage> percentage) {
    _cachedFatPercentage = List.of(percentage);
  }

  List<FatPercentage> getFatPercentage() {
    return List.of(_cachedFatPercentage ?? []);
  }
}
