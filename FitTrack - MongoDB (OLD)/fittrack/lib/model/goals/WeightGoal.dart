class WeightGoal {
  double goal;
  bool isEnabled;
  String weightUnit;

  WeightGoal({this.goal = 0, this.isEnabled = false, this.weightUnit = 'kg'});

  Map<String, dynamic> toJSON() {
    return {
      'goal': goal,
      'isEnabled': isEnabled,
      'weightUnit': weightUnit,
    };
  }
}
