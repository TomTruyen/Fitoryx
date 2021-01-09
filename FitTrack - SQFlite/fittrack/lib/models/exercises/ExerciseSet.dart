class ExerciseSet {
  double reps;
  double weight;

  ExerciseSet({this.reps, this.weight});

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
