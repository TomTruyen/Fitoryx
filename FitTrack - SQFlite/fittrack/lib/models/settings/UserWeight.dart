class UserWeight {
  double weight;
  String weightUnit;
  int timeInMilliseconds;

  UserWeight(
      {this.weight = 0.0, this.weightUnit = "kg", this.timeInMilliseconds = 0});

  static fromJSON(Map<String, dynamic> json) {
    return new UserWeight(
      weight: json['weight'] ?? 0.0,
      weightUnit: json['weightUnit'] ?? "kg",
      timeInMilliseconds: json['timeInMilliseconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'weight': weight,
      'weightUnit': weightUnit,
      'timeInMilliseconds': timeInMilliseconds,
    };
  }
}
