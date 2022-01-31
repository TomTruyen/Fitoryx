enum ExerciseType { weight, time }

class ExerciseTypeHelper {
  static String toValue(ExerciseType type) {
    switch (type) {
      case ExerciseType.weight:
        return "Weight";
      case ExerciseType.time:
        return "Time";
    }
  }

  static ExerciseType fromValue(String value) {
    if (value == "Time") return ExerciseType.time;

    return ExerciseType.weight;
  }
}
