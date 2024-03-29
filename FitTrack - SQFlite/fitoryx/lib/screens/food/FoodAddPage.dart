import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/shared/ErrorPopup.dart';
import 'package:Fitoryx/shared/FoodInputWidget.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodAddPage extends StatefulWidget {
  final Function updateFood;

  FoodAddPage({this.updateFood});

  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  double kcal = 0.0;
  double carbs = 0.0;
  double protein = 0.0;
  double fat = 0.0;

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
        fat = newValue;
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
              'Add Nutrition',
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
                onPressed: () async {
                  dynamic result = await globals.sqlDatabase
                      .addFood(kcal, carbs, protein, fat);

                  if (result != null) {
                    await globals.sqlDatabase.fetchFood();

                    widget.updateFood(globals.sqlDatabase.food[0]);

                    tryPopContext(context);
                  } else {
                    showPopupError(
                      context,
                      'Failed to save food',
                      'Something went wrong saving your food input. Please try again.',
                    );
                  }
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
