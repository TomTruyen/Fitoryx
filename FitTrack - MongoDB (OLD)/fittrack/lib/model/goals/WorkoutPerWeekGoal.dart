class WorkoutPerWeekGoal {
  int goal;
  bool isEnabled;

  WorkoutPerWeekGoal({this.goal = 1, this.isEnabled = false});

  Map<String, dynamic> toJSON() {
    return {
      'goal': goal,
      'isEnabled': isEnabled,
    };
  }
}
