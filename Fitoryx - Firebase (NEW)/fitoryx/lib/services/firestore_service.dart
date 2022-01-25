import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/exercise.dart';
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

  Future<String> createExercise(Exercise exercise) async {
    DocumentReference<Map<String, dynamic>> docReference =
        await _usersCollection
            .doc(_authService.getUser()?.uid)
            .collection('exercises')
            .add(exercise.toExerciseJson());

    return docReference.id;
  }

  Future<List<Exercise>> getExercises() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _usersCollection
        .doc(_authService.getUser()?.uid)
        .collection('exercises')
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Exercise> exercises = [];

    for (var exercise in querySnapshot.docs) {
      Exercise e = Exercise.fromExerciseJson(exercise.data());
      e.id = exercise.id;
      exercises.add(e);
    }

    return exercises;
  }
}
