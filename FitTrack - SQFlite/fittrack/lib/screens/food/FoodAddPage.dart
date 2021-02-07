import 'package:fittrack/shared/FoodInputWidget.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodAddPage extends StatefulWidget {
  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  double kcal = 0;
  double carbs = 0;
  double protein = 0;
  double fat = 0;

  void updateValue(double newValue, String name) {
    switch (name.toLowerCase()) {
      case 'kcal':
        kcal = newValue;
        break;
      case 'carbs':
        carbs = newValue;
        break;
      case 'protein':
        protein = newValue;
        break;
      case 'fat':
        protein = newValue;
        break;
      default:
        break;
    }
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
              'Add Food',
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
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Save here
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                FoodInputWidget(updateValue: updateValue, name: 'kcal'),
                FoodInputWidget(updateValue: updateValue, name: 'carbs'),
                FoodInputWidget(updateValue: updateValue, name: 'protein'),
                FoodInputWidget(updateValue: updateValue, name: 'fat'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
