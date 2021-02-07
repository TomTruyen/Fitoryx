class Food {
  int id;
  double kcal;
  double carbs;
  double protein;
  double fat;
  double kcalGoal;
  double carbsGoal;
  double proteinGoal;
  double fatGoal;
  String date;

  Food({
    this.id,
    this.kcal = 0.0,
    this.carbs = 0.0,
    this.protein = 0.0,
    this.fat = 0.0,
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
    this.date,
  });

  static Food fromJSON(Map<String, dynamic> food) {
    return new Food(
      id: food['id'],
      kcal: food['kcal'] ?? 0.0,
      carbs: food['carbs'] ?? 0.0,
      protein: food['protein'] ?? 0.0,
      fat: food['fat'] ?? 0.0,
      kcalGoal: food['kcalGoal'],
      carbsGoal: food['carbsGoal'],
      proteinGoal: food['proteinGoal'],
      fatGoal: food['fatGoal'],
      date: food['date'],
    );
  }
}
