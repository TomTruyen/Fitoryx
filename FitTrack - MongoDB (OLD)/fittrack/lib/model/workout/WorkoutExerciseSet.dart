class WorkoutExerciseSet {
  int reps;
  double weight;
  bool setComplete = false;
  bool isEdited = false;

  WorkoutExerciseSet({this.reps = 0, this.weight = 0.0});

  Map<String, dynamic> toJSON() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }
}
