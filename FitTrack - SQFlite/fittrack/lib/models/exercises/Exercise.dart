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
    this.restEnabled = 1,
    this.restSeconds = 60,
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

    return _clone;
  }

  Exercise fromJSON(Map<String, dynamic> exercise) {
    List<ExerciseSet> setList = [];

    List<Map<String, dynamic>> setJSON = exercise['sets'] ?? [];
    if (setJSON.isNotEmpty) {
      setJSON.forEach((Map<String, dynamic> _set) {
        setList.add(new ExerciseSet().fromJSON(_set));
      });
    }

    return new Exercise(
      id: exercise['id'] ?? "",
      name: exercise['name'] ?? "",
      category: exercise['category'] ?? "",
      equipment: exercise['equipment'] ?? "",
      isUserCreated: exercise['isUserCreated'] ?? 0,
      hasNotes: exercise['hasNotes'] ?? 0,
      notes: exercise['notes'] ?? "",
      restEnabled: exercise['restEnabled'] ?? 1,
      restSeconds: exercise['restSeconds'] ?? 60,
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
      'restEnabled': restEnabled ?? 1,
      'restSeconds': restSeconds ?? 60,
      'sets': setJSON ?? [],
    };
  }
}
