import 'dart:math';

import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

class FoodHistoryPage extends StatefulWidget {
  final List<Food> foodList;

  FoodHistoryPage({this.foodList});

  @override
  _FoodHistoryPageState createState() => _FoodHistoryPageState();
}

class _FoodHistoryPageState extends State<FoodHistoryPage> {
  bool sortAscending = false;

  void sortFoodHistory(bool orderAscending) {
    widget.foodList.sort((Food a, Food b) {
      if (orderAscending) return a.date.compareTo(b.date);

      return -a.date.compareTo(b.date);
    });

    setState(() {
      sortAscending = orderAscending;
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
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.transparent,
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
                    sortFoodHistory(!sortAscending);
                  },
                ),
              ),
            ),
          if (widget.foodList.isNotEmpty)
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                Food _food = widget.foodList[index];

                int year = int.parse(_food.date.split('-')[2]);
                int month = int.parse(_food.date.split('-')[1]);
                int day = int.parse(_food.date.split('-')[0]);

                DateTime date = new DateTime(year, month, day);

                String _date = getFormattedDateFromDateTime(date);

                // KCAL
                String kcalString =
                    "${_food.kcal % 1 == 0 ? _food.kcal.toInt() : _food.kcal}";

                if (_food.kcalGoal != null) {
                  kcalString +=
                      " / ${_food.kcalGoal % 1 == 0 ? _food.kcalGoal.toInt() : _food.kcalGoal}";
                }

                kcalString += "kcal";

                // CARBS
                String carbsString =
                    "${_food.carbs % 1 == 0 ? _food.carbs.toInt() : _food.carbs}";

                if (_food.carbsGoal != null) {
                  carbsString +=
                      " / ${_food.carbsGoal % 1 == 0 ? _food.carbsGoal.toInt() : _food.carbsGoal}";
                }

                carbsString += "g";

                //PROTEIN
                String proteinString =
                    "${_food.protein % 1 == 0 ? _food.protein.toInt() : _food.protein}";

                if (_food.proteinGoal != null) {
                  proteinString +=
                      " / ${_food.proteinGoal % 1 == 0 ? _food.proteinGoal.toInt() : _food.proteinGoal}";
                }

                proteinString += "g";

                //FAT
                String fatString =
                    "${_food.fat % 1 == 0 ? _food.fat.toInt() : _food.fat}";

                if (_food.fatGoal != null) {
                  fatString +=
                      " / ${_food.fatGoal % 1 == 0 ? _food.fatGoal.toInt() : _food.fatGoal}";
                }

                fatString += "g";

                return Card(
                  key: UniqueKey(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _date,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize:
                                Theme.of(context).textTheme.bodyText2.fontSize *
                                    1.05,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text(
                              'Calories: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(kcalString),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Carbs: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(carbsString),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Protein: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(proteinString),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Fat: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(fatString),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: widget.foodList.length),
            ),
        ],
      ),
    );
  }
}
