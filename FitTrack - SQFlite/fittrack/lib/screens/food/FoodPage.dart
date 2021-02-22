import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/food/FoodAddPage.dart';
import 'package:fittrack/screens/food/FoodHistoryPage.dart';
import 'package:fittrack/screens/food/graphs/FoodGraph.dart';
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

  double kcal = 0;
  double carbs = 0;
  double protein = 0;
  double fat = 0;

  @override
  void initState() {
    super.initState();

    settings = globals.sqlDatabase.settings;

    DateTime now = DateTime.now();

    String date = dateTimeToString(now);

    if (globals.sqlDatabase.food.isNotEmpty &&
        globals.sqlDatabase.food[0].date == date) {
      Food _food = globals.sqlDatabase.food[0];

      double _kcal = 0;
      double _carbs = 0;
      double _protein = 0;
      double _fat = 0;

      for (int i = 0; i < _food.foodPerHour.length; i++) {
        _kcal += _food.foodPerHour[i].kcal;
        _carbs += _food.foodPerHour[i].carbs;
        _protein += _food.foodPerHour[i].protein;
        _fat += _food.foodPerHour[i].fat;
      }

      setState(() {
        food = _food;
        kcal = _kcal;
        carbs = _carbs;
        protein = _protein;
        fat = _fat;
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
    double _kcal = 0;
    double _carbs = 0;
    double _protein = 0;
    double _fat = 0;

    for (int i = 0; i < newFood.foodPerHour.length; i++) {
      _kcal += newFood.foodPerHour[i].kcal;
      _carbs += newFood.foodPerHour[i].carbs;
      _protein += newFood.foodPerHour[i].protein;
      _fat += newFood.foodPerHour[i].fat;
    }

    setState(() {
      food = newFood;
      kcal = _kcal;
      carbs = _carbs;
      protein = _protein;
      fat = _fat;
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
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3.0,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Calories per hour',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: FoodGraph(
                                  foodPerHourList: food.foodPerHour ?? [],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FoodDisplayCard(
                      value: tryConvertDoubleToInt(kcal),
                      goal: tryConvertDoubleToInt(settings.kcalGoal),
                      name: 'kcal',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FoodDisplayCard(
                            value: tryConvertDoubleToInt(carbs),
                            goal: tryConvertDoubleToInt(settings.carbsGoal),
                            name: 'carbs',
                            isMacro: true,
                          ),
                        ),
                        Expanded(
                          child: FoodDisplayCard(
                            value: tryConvertDoubleToInt(protein),
                            goal: tryConvertDoubleToInt(settings.proteinGoal),
                            name: 'protein',
                            isMacro: true,
                          ),
                        ),
                        Expanded(
                          child: FoodDisplayCard(
                            value: tryConvertDoubleToInt(fat),
                            goal: tryConvertDoubleToInt(settings.fatGoal),
                            name: 'fat',
                            isMacro: true,
                          ),
                        ),
                      ],
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
