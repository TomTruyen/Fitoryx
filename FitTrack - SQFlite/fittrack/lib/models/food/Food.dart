import 'dart:convert';

import 'package:fittrack/models/food/FoodPerHour.dart';

class Food {
  int id;
  List<FoodPerHour> foodPerHour;
  double kcalGoal;
  double carbsGoal;
  double proteinGoal;
  double fatGoal;
  String date;

  // Used for easier access in FoodHistoryPage
  double kcal;
  double carbs;
  double protein;
  double fat;

  Food({
    this.id,
    this.foodPerHour,
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
    this.date,
  });

  Food clone() {
    return new Food(
      id: id,
      foodPerHour: foodPerHour,
      kcalGoal: kcalGoal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
      date: date,
    );
  }

  static Food fromJSON(Map<String, dynamic> food) {
    List<FoodPerHour> _foodPerHour = [];

    List<dynamic> foodPerHourJsonList = [];
    if (food['foodPerHour'] != null) {
      foodPerHourJsonList = jsonDecode(food['foodPerHour']) ?? [];
    }

    for (int i = 0; i < 24; i++) {
      FoodPerHour foodPerHourToAdd;

      for (int j = 0; j < foodPerHourJsonList.length; j++) {
        if (foodPerHourJsonList[j]['hour'] == i) {
          foodPerHourToAdd = FoodPerHour.fromJSON(foodPerHourJsonList[j]);
        }
      }

      if (foodPerHourToAdd == null) {
        foodPerHourToAdd = new FoodPerHour(hour: i);
      }

      _foodPerHour.add(foodPerHourToAdd);
    }

    return new Food(
      id: food['id'],
      foodPerHour: _foodPerHour,
      kcalGoal: food['kcalGoal'],
      carbsGoal: food['carbsGoal'],
      proteinGoal: food['proteinGoal'],
      fatGoal: food['fatGoal'],
      date: food['date'],
    );
  }
}
