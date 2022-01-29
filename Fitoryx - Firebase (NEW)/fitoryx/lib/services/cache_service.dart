import 'package:fitoryx/models/exercise.dart';
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

  bool hasHistory() {
    return _cachedHistory != null;
  }

  void setHistory(List<WorkoutHistory> history) {
    _cachedHistory = List.of(history);
  }

  List<WorkoutHistory> getHistory() {
    return _cachedHistory ?? [];
  }

  bool hasWorkouts() {
    return _cachedWorkouts != null;
  }

  void setWorkouts(List<Workout> workouts) {
    _cachedWorkouts = List.of(workouts);
  }

  List<Workout> getWorkouts() {
    return _cachedWorkouts ?? [];
  }

  bool hasExercises() {
    return _cachedExercises != null;
  }

  void setExercises(List<Exercise> exercises) {
    _cachedExercises = List.of(exercises);
  }

  List<Exercise> getExercises() {
    return _cachedExercises ?? [];
  }
}
