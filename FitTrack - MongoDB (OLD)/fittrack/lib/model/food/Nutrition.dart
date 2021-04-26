import 'package:fittrack/misc/Functions.dart';

class Nutrition {
  int kcal;
  int carbs;
  int protein;
  int fat;
  String date = convertDateTimeToStringDate(DateTime.now());

  Nutrition(
      {this.kcal = 0,
      this.carbs = 0,
      this.protein = 0,
      this.fat = 0,
      this.date});

  Map<String, dynamic> toJSON() {
    return {
      'kcal': kcal,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'date': date,
    };
  }
}
