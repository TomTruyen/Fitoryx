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

  Map<String, dynamic> toExerciseJson({bool withId = false}) {
    var json = {
      "name": name,
      "category": category,
      "equipment": equipment,
      "type": type,
    };

    if (withId && id != null) {
      json["id"] = id!;
    }

    return json;
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

  bool equals(Exercise exercise) {
    return exercise.id == id &&
        exercise.name == name &&
        exercise.category == category &&
        exercise.equipment == equipment &&
        exercise.type == type;
  }
}
