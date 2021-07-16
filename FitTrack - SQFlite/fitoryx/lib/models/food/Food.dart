import 'dart:convert';

import 'package:Fitoryx/models/food/FoodPerHour.dart';

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

  // used for timespan graph
  int timeInMillisSinceEpoch;

  Food({
    this.id,
    this.foodPerHour,
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
    this.date,
    this.timeInMillisSinceEpoch,
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
      timeInMillisSinceEpoch: timeInMillisSinceEpoch,
    );
  }

  double getTotalKcal() {
    if (foodPerHour == null || foodPerHour.isEmpty) return 0;

    double kcal = 0;
    for (int i = 0; i < foodPerHour.length; i++)
      kcal += foodPerHour[i].kcal ?? 0;

    return kcal;
  }

  static int convertDateStringToTimeInMillis(String date) {
    if (date == null || date == "" || date.split('-').length < 3) {
      return null;
    }

    int year = int.parse(date.split('-')[2]);
    int month = int.parse(date.split('-')[1]);
    int day = int.parse(date.split('-')[0]);

    DateTime dateTime = DateTime(year, month, day);

    return dateTime.millisecondsSinceEpoch;
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
      timeInMillisSinceEpoch: convertDateStringToTimeInMillis(food['date']),
    );
  }
}
