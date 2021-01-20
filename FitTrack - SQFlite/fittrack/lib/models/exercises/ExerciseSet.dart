class ExerciseSet {
  int reps;
  double weight;
  bool isCompleted = false;

  ExerciseSet({this.reps, this.weight, this.isCompleted = false});

  ExerciseSet fromJSON(Map<String, dynamic> _set) {
    return new ExerciseSet(
      reps: _set['reps'] ?? null,
      weight: _set['weight'] ?? null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }
}
