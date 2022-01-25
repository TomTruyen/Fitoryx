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
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.type = "Weight",
  });

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
      name: json['name'],
      category: json['category'],
      equipment: json['equipment'],
      type: json['type'],
    );
  }
}
