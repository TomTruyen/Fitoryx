import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/utils/int_extension.dart';

class Exercise {
  String? id;
  String name;
  String category;
  String equipment;
  bool userCreated;
  String notes = "";
  bool restEnabled = true;
  int restSeconds = 60;
  List<ExerciseSet> sets = [ExerciseSet()];
  ExerciseType type;

  Exercise({
    this.id,
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.type = ExerciseType.weight,
    this.userCreated = false,
  });

  String getTitle() {
    String title = name;

    if (equipment != "" && equipment.toLowerCase() != "none") {
      title = "$title ($equipment)";
    }

    return title;
  }

  ExerciseSet getBestSet() {
    ExerciseSet bestSet = ExerciseSet(reps: 0, weight: 0, time: 0);

    for (var set in sets) {
      double bestSetWeight = bestSet.weight ?? 0;
      double setWeight = set.weight ?? 0;

      int bestSetReps = bestSet.reps ?? 0;
      int setReps = set.reps ?? 0;

      int bestSetTime = bestSet.time ?? 0;
      int setTime = set.time ?? 0;

      if (type == ExerciseType.weight) {
        if (bestSetWeight < setWeight) {
          bestSet = set;
        } else if (bestSetReps < setReps) {
          bestSet = set;
        }
      } else if (type == ExerciseType.time) {
        if (bestSetTime < setTime) {
          bestSet = set;
        }
      }
    }

    return bestSet;
  }

  double getTotalWeight() {
    double weight = 0;

    for (var set in sets) {
      weight += (set.reps ?? 0) * (set.weight ?? 0);
    }

    return weight;
  }

  String getTotalTime() {
    int time = 0;

    for (int i = 0; i < sets.length; i++) {
      time += sets[i].time ?? 0;
    }

    if (time == 0) return '0:00';

    int hours = (time ~/ 3600);
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;

    if (hours > 0) {
      return '${hours.withZeroPadding()}:${minutes.withZeroPadding()}:${seconds.withZeroPadding()}';
    }

    return '${minutes.withZeroPadding()}:${seconds.withZeroPadding()}';
  }

  Exercise clone() => Exercise(
        id: id,
        name: name,
        category: category,
        equipment: equipment,
        type: type,
      );

  Exercise fullClone() {
    var exercise = Exercise(
      id: id,
      name: name,
      category: category,
      equipment: equipment,
      type: type,
    );

    exercise.notes = notes;
    exercise.restEnabled = restEnabled;
    exercise.restSeconds = restSeconds;

    List<ExerciseSet> setList = [];
    for (var set in sets) {
      setList.add(set.clone());
    }
    exercise.sets = setList;

    return exercise;
  }

  Map<String, dynamic> toExerciseJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "equipment": equipment,
      "type": ExerciseTypeHelper.toValue(type),
      "userCreated": userCreated
    };
  }

  static Exercise fromExerciseJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      equipment: json['equipment'],
      type: ExerciseTypeHelper.fromValue(json['type']),
      userCreated: json['userCreated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "equipment": equipment,
      "type": ExerciseTypeHelper.toValue(type),
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
      type: ExerciseTypeHelper.fromValue(json['type']),
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
