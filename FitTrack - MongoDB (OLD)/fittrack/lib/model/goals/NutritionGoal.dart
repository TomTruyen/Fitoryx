class NutritionGoal {
  int kcal;
  int carbs;
  int protein;
  int fat;
  bool isEnabled;

  NutritionGoal({
    this.kcal = 0,
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
    this.isEnabled = false,
  });

  Map<String, dynamic> toJSON() {
    return {
      'kcal': kcal,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'isEnabled': isEnabled,
    };
  }
}
