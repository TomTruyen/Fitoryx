import 'package:fittrack/models/exercises/ExerciseSet.dart';

class Exercise {
  int id;
  String name;
  String category;
  String equipment;
  int isUserCreated;
  int hasNotes;
  String notes;
  int restEnabled;
  int restSeconds;

  List<ExerciseSet> sets = [ExerciseSet()];

  Exercise({
    this.id,
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.isUserCreated = 0,
    this.hasNotes = 0,
    this.notes = "",
    this.restEnabled,
    this.restSeconds,
    this.sets,
  });

  bool compare(Exercise exercise) {
    return id == exercise.id &&
        name == exercise.name &&
        category == exercise.category &&
        equipment == exercise.equipment &&
        isUserCreated == exercise.isUserCreated;
  }

  Exercise clone() {
    Exercise _clone = new Exercise();

    _clone.id = id;
    _clone.name = name ?? "";
    _clone.category = category ?? "";
    _clone.equipment = equipment ?? "";
    _clone.isUserCreated = isUserCreated ?? 0;
    _clone.sets = [ExerciseSet()];

    return _clone;
  }

  bool isExerciseCompleted() {
    bool isCompleted = true;

    for (int i = 0; i < sets.length; i++) {
      bool setCompleted = sets[i].isCompleted ?? false;

      if (!setCompleted) {
        isCompleted = false;
        break;
      }
    }

    return isCompleted;
  }

  double getTotalWeightLifted() {
    double weight = 0;

    for (int i = 0; i < sets.length; i++) {
      weight += ((sets[i].reps ?? 0) * (sets[i].weight ?? 0));
    }

    return weight;
  }

  static Exercise fromJSON(
    Map<String, dynamic> exercise, {
    String workoutWeightUnit,
  }) {
    List<ExerciseSet> setList = [];
    if (exercise['sets'] != null) {
      setList = (exercise['sets'] as List)
              .map((_set) => ExerciseSet()
                  .fromJSON(_set, workoutWeightUnit: workoutWeightUnit))
              .toList() ??
          [];
    }

    return new Exercise(
      id: exercise['id'],
      name: exercise['name'] ?? "",
      category: exercise['category'] ?? "",
      equipment: exercise['equipment'] ?? "",
      isUserCreated: exercise['isUserCreated'] ?? 0,
      hasNotes: exercise['hasNotes'] ?? 0,
      notes: exercise['notes'] ?? "",
      restEnabled: exercise['restEnabled'],
      restSeconds: exercise['restSeconds'],
      sets: setList ?? [],
    );
  }

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> setJSON = [];

    if (sets.isNotEmpty) {
      sets.forEach((ExerciseSet _set) {
        setJSON.add(_set.toJSON());
      });
    }

    return {
      'id': id,
      'name': name ?? "",
      'category': category ?? "",
      'equipment': equipment ?? "",
      'isUserCreated': isUserCreated ?? 0,
      'hasNotes': hasNotes ?? 0,
      'notes': notes ?? "",
      'restEnabled': restEnabled,
      'restSeconds': restSeconds,
      'sets': setJSON ?? [],
    };
  }
}
