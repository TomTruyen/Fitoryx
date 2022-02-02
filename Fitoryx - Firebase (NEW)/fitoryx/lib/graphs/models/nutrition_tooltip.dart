import 'package:fitoryx/models/nutrition.dart';

class NutritionTooltip {
  int kcal;
  int carbs;
  int protein;
  int fat;

  NutritionTooltip(
      {this.kcal = 0, this.carbs = 0, this.protein = 0, this.fat = 0});

  static fromNutrition(Nutrition nutrition) {
    return NutritionTooltip(
      kcal: nutrition.kcal,
      carbs: nutrition.carbs,
      protein: nutrition.protein,
      fat: nutrition.fat,
    );
  }

  @override
  String toString() {
    return "Calories: $kcal\n Carbs: ${carbs}g\n Protein: ${protein}g\n Fat: ${fat}g";
  }
}
