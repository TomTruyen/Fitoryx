class Food {
  int id;
  double kcal;
  double carbs;
  double protein;
  double fat;
  String date;

  Food({
    this.id,
    this.kcal = 0.0,
    this.carbs = 0.0,
    this.protein = 0.0,
    this.fat = 0.0,
    this.date,
  });

  static Food fromJSON(Map<String, dynamic> food) {
    return new Food(
      id: food['id'],
      kcal: food['kcal'] ?? 0.0,
      carbs: food['carbs'] ?? 0.0,
      protein: food['protein'] ?? 0.0,
      fat: food['fat'] ?? 0.0,
      date: food['date'],
    );
  }
}
