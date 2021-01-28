class Food {
  int id;
  int kcal;
  int carbs;
  int protein;
  int fat;
  int timeInMillisSinceEpoch;

  Food({
    this.id,
    this.kcal = 0,
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
    this.timeInMillisSinceEpoch = 0,
  });

  static Food fromJSON(Map<String, dynamic> food) {
    return new Food(
      id: food['id'],
      kcal: food['kcal'] ?? 0,
      carbs: food['carbs'] ?? 0,
      protein: food['protein'] ?? 0,
      fat: food['fat'] ?? 0,
      timeInMillisSinceEpoch: food['timeInMillisSinceEpoch'] ?? 0,
    );
  }
}
