class FoodPerHour {
  double kcal;
  double carbs;
  double protein;
  double fat;
  int hour;

  FoodPerHour({
    this.kcal = 0,
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
    this.hour = 0,
  });

  static fromJSON(Map<String, dynamic> json) {
    return FoodPerHour(
      kcal: json['kcal'] ?? 0,
      carbs: json['carbs'] ?? 0,
      protein: json['protein'] ?? 0,
      fat: json['fat'] ?? 0,
      hour: json['hour'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'kcal': kcal,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'hour': hour,
    };
  }
}
