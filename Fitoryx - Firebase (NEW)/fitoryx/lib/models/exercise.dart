import 'package:fitoryx/models/exercise_set.dart';

class Exercise {
  String? id;
  String name;
  String category;
  String equipment;
  bool userCreated = false;
  String notes = "";
  bool restEnabled = true;
  int restSeconds = 60;
  List<ExerciseSet> sets = [ExerciseSet()];
  String type;

  Exercise({
    this.id,
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.type = "Weight",
  });

  String getTitle() {
    String title = name;

    if (equipment != "" && equipment.toLowerCase() != "none") {
      title = "$title ($equipment)";
    }

    return title;
  }

  Exercise clone() => Exercise(
        id: id,
        name: name,
        category: category,
        equipment: equipment,
        type: type,
      );

  Map<String, dynamic> toExerciseJson() {
    return {
      "name": name,
      "category": category,
      "equipment": equipment,
      "type": type,
    };
  }

  static Exercise fromExerciseJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      equipment: json['equipment'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "equipment": equipment,
      "type": type,
      "notes": notes,
      "restEnabled": restEnabled,
      "restSeconds": restSeconds,
      "sets": sets.map((set) => set.toJson()).toList()
    };
  }

  static Exercise fromJson(Map<String, dynamic> json) {
    var exercise = Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      equipment: json['equipment'],
      type: json['type'],
    );

    exercise.notes = json['notes'];
    exercise.restEnabled = json['restEnabled'];
    exercise.restSeconds = json['restSeconds'];
    exercise.sets = json['sets']
        .map<ExerciseSet>(
          (set) => ExerciseSet.fromJson(set),
        )
        .toList();

    return exercise;
  }

  bool equals(Exercise exercise) {
    return exercise.id == id &&
        exercise.name == name &&
        exercise.category == category &&
        exercise.equipment == equipment &&
        exercise.type == type;
  }
}
