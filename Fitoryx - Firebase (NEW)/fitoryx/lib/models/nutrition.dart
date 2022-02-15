class Nutrition {
  String? id;
  int kcal;
  int carbs;
  int protein;
  int fat;
  DateTime date = DateTime.now();

  Nutrition({
    this.id,
    this.kcal = 0,
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
  });

  bool isEmpty() {
    return kcal == 0 && carbs == 0 && protein == 0 && fat == 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "kcal": kcal,
      "carbs": carbs,
      "protein": protein,
      "fat": fat,
      "date": date,
    };
  }

  static Nutrition fromJson(Map<String, dynamic> json) {
    var nutrition = Nutrition(
      id: json['id'],
      kcal: json['kcal'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
    );

    nutrition.date = json['date']?.toDate();

    return nutrition;
  }
}
