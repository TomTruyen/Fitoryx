import 'dart:math';

import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/food/Food.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodHistoryPage extends StatefulWidget {
  final List<Food> foodList;

  FoodHistoryPage({this.foodList});

  @override
  _FoodHistoryPageState createState() => _FoodHistoryPageState();
}

class _FoodHistoryPageState extends State<FoodHistoryPage> {
  List<Food> food = [];

  int currentMonth;
  int currentYear;

  @override
  void initState() {
    super.initState();

    if (widget.foodList.isNotEmpty) {
      List<Food> _calculatedFoodList = [];

      widget.foodList.forEach((Food _food) {
        double kcal = 0;
        double carbs = 0;
        double protein = 0;
        double fat = 0;

        for (int i = 0; i < _food.foodPerHour.length; i++) {
          kcal += _food.foodPerHour[i].kcal;
          carbs += _food.foodPerHour[i].carbs;
          protein += _food.foodPerHour[i].protein;
          fat += _food.foodPerHour[i].fat;
        }

        Food newFood = _food.clone();
        newFood.kcal = kcal;
        newFood.carbs = carbs;
        newFood.protein = protein;
        newFood.fat = fat;

        _calculatedFoodList.add(newFood);
      });

      setState(() {
        food = _calculatedFoodList;
      });
    }
  }

  bool sortAscending = false;

  void sortFoodHistory(List<Food> _food, bool orderAscending) {
    List<Food> sortedFood = sortFoodByDate(_food, orderAscending);

    setState(() {
      sortAscending = orderAscending;
      _food = sortedFood;
      currentMonth = null;
      currentYear = null;
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
              'Nutrition History',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
          ),
          if (widget.foodList.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No Nutrition History.'),
              ),
            ),
          if (widget.foodList.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    primary: Theme.of(context).textTheme.bodyText2.color,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform(
                        alignment: Alignment.center,
                        transform: sortAscending
                            ? Matrix4.rotationX(pi)
                            : Matrix4.rotationX(0),
                        child: Icon(
                          Icons.sort,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text('Sort by date'),
                    ],
                  ),
                  onPressed: () {
                    sortFoodHistory(food, !sortAscending);
                  },
                ),
              ),
            ),
          if (food.isNotEmpty)
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                Food _food = food[index];

                int year = int.parse(_food.date.split('-')[2]);
                int month = int.parse(_food.date.split('-')[1]);
                int day = int.parse(_food.date.split('-')[0]);

                DateTime date = new DateTime(year, month, day);

                String _date = getFormattedDateFromDateTime(date);

                String kcalString =
                    getFoodGoalString(_food.kcal, _food.kcalGoal, 'kcal');
                String carbsString =
                    getFoodGoalString(_food.carbs, _food.carbsGoal, 'g');
                String proteinString =
                    getFoodGoalString(_food.protein, _food.proteinGoal, 'g');
                String fatString =
                    getFoodGoalString(_food.fat, _food.fatGoal, 'g');

                String dateDivider = "";
                if ((currentMonth == null && currentYear == null) ||
                    requiresDateDivider(date, currentMonth, currentYear)) {
                  currentMonth = date.month;
                  currentYear = date.year;

                  DateFormat format = new DateFormat("MMMM yyyy");
                  dateDivider = format.format(date);
                }

                return Column(
                  children: <Widget>[
                    if (dateDivider != "")
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dateDivider,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize:
                                Theme.of(context).textTheme.bodyText2.fontSize *
                                    0.8,
                          ),
                        ),
                      ),
                    Card(
                      key: UniqueKey(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _date,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .fontSize,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Calories: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                                Text(
                                  kcalString,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Carbs: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                                Text(
                                  carbsString,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Protein: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                                Text(
                                  proteinString,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Fat: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                                Text(
                                  fatString,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }, childCount: food.length),
            ),
        ],
      ),
    );
  }
}
