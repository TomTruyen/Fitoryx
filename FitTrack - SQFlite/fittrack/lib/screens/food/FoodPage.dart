import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/food/FoodAddPage.dart';
import 'package:fittrack/screens/food/FoodHistoryPage.dart';
import 'package:fittrack/shared/FoodDisplayCard.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<Food> foodHistoryList;

  Settings settings;
  Food food;

  @override
  void initState() {
    super.initState();

    settings = globals.sqlDatabase.settings;

    DateTime now = DateTime.now();

    String date = dateTimeToString(now);

    if (globals.sqlDatabase.food.isNotEmpty &&
        globals.sqlDatabase.food[0].date == date) {
      setState(() {
        food = globals.sqlDatabase.food[0];
      });
    } else {
      setState(() {
        food = new Food();
      });
    }

    List<Food> _foodHistoryList = List.of(globals.sqlDatabase.food) ?? [];

    if (_foodHistoryList.isNotEmpty && _foodHistoryList[0].date == date) {
      _foodHistoryList.removeAt(0);
    }

    setState(() {
      foodHistoryList = _foodHistoryList;
    });
  }

  void updateFood(Food newFood) {
    setState(() {
      food = newFood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: Text(
              'Nutrition',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.watch_later_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => FoodHistoryPage(
                        foodList: List.of(foodHistoryList) ?? [],
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => FoodAddPage(updateFood: updateFood),
                    ),
                  );
                },
              )
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: FoodDisplayCard(
                      value: food.kcal % 1 == 0 ? food.kcal.toInt() : food.kcal,
                      goal: settings.kcalGoal != null &&
                              settings.kcalGoal % 1 == 0
                          ? settings.kcalGoal.toInt()
                          : settings.kcalGoal,
                      name: 'kcal',
                    ),
                  ),
                  Expanded(
                    child: FoodDisplayCard(
                      value:
                          food.carbs % 1 == 0 ? food.carbs.toInt() : food.carbs,
                      goal: settings.carbsGoal != null &&
                              settings.carbsGoal % 1 == 0
                          ? settings.carbsGoal.toInt()
                          : settings.carbsGoal,
                      name: 'carbs',
                    ),
                  ),
                  Expanded(
                    child: FoodDisplayCard(
                      value: food.protein % 1 == 0
                          ? food.protein.toInt()
                          : food.protein,
                      goal: settings.proteinGoal != null &&
                              settings.proteinGoal % 1 == 0
                          ? settings.proteinGoal.toInt()
                          : settings.proteinGoal,
                      name: 'protein',
                    ),
                  ),
                  Expanded(
                    child: FoodDisplayCard(
                      value:
                          food.fat % 1 == 0 ? food.fat.toInt() : food.protein,
                      goal:
                          settings.fatGoal != null && settings.fatGoal % 1 == 0
                              ? settings.fatGoal.toInt()
                              : settings.fatGoal,
                      name: 'fat',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
