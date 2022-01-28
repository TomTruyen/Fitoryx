import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/services/auth_service.dart';

class FirestoreService {
  // Singleton Setup
  static final FirestoreService _firstoreService = FirestoreService._internal();

  factory FirestoreService() {
    return _firstoreService;
  }

  FirestoreService._internal();

  // Properties
  final AuthService _authService = AuthService();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final String exerciseCollection = "exercises";
  final String workoutCollection = "workouts";
  final String historyCollection = "history";

  // Exercises
  Future<String> createExercise(Exercise exercise) async {
    DocumentReference<Map<String, dynamic>> docReference =
        await _usersCollection
            .doc(_authService.getUser()?.uid)
            .collection(exerciseCollection)
            .add(exercise.toExerciseJson());

    return docReference.id;
  }

  Future<void> deleteExercise(String? id) async {
    await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection(exerciseCollection)
        .doc(id)
        .delete();
  }

  Future<List<Exercise>> getExercises() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection(exerciseCollection)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Exercise> exercises = [];

    for (var exercise in querySnapshot.docs) {
      Exercise e = Exercise.fromExerciseJson(exercise.data());
      e.id = exercise.id;
      e.userCreated = true;
      exercises.add(e);
    }

    return exercises;
  }

  // Workouts
  Future<String> createWorkout(Workout workout) async {
    DocumentReference<Map<String, dynamic>> docReference =
        await _usersCollection
            .doc(_authService.getUser()?.uid)
            .collection(workoutCollection)
            .add(workout.toJson());

    return docReference.id;
  }

  Future<void> updateWorkout(Workout workout) async {
    await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection(workoutCollection)
        .doc(workout.id)
        .update(workout.toJson());
  }

  Future<void> deleteWorkout(String? id) async {
    await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection(workoutCollection)
        .doc(id)
        .delete();
  }

  Future<List<Workout>> getWorkouts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection(workoutCollection)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Workout> workouts = [];

    for (var workout in querySnapshot.docs) {
      Workout w = Workout.fromJson(workout.data());
      w.id = workout.id;

      workouts.add(w);
    }

    return workouts;
  }

  // History
  Future<String> createWorkoutHistory(WorkoutHistory history) async {
    DocumentReference<Map<String, dynamic>> docReference =
        await _usersCollection
            .doc(_authService.getUser()?.uid)
            .collection(historyCollection)
            .add(history.toJson());

    return docReference.id;
  }

  Future<List<WorkoutHistory>> getWorkoutHistory() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection(historyCollection)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<WorkoutHistory> workoutHistory = [];

    for (var history in querySnapshot.docs) {
      WorkoutHistory w = WorkoutHistory.fromJson(history.data());
      w.id = history.id;

      workoutHistory.add(w);
    }

    return workoutHistory;
  }
}