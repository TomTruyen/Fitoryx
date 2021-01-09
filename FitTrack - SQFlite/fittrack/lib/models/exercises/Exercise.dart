import 'package:fittrack/models/exercises/ExerciseSet.dart';

class Exercise {
  int id;
  String name;
  String category;
  String equipment;
  int isUserCreated;

  List<ExerciseSet> sets = [ExerciseSet()];
  int hasNotes = 0;
  String notes = "";

  int restEnabled = 1;
  int restSeconds = 60;

  Exercise({
    this.id,
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.isUserCreated = 0,
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
    return new Exercise(
      id: exercise['id'] ?? "",
      name: exercise['name'] ?? "",
      category: exercise['category'] ?? "",
      equipment: exercise['equipment'] ?? "",
      isUserCreated: exercise['isUserCreated'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name ?? "",
      'category': category ?? "",
      'equipment': equipment ?? "",
      'isUserCreated': isUserCreated ?? 0,
    };
  }
}
