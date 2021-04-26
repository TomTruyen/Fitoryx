// Flutter Packages
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/services/Database.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/FoodSliderCard.dart';
import 'package:fittrack/shared/Snackbars.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class FoodAddPage extends StatefulWidget {
  final Function refreshNutrition;

  FoodAddPage({this.refreshNutrition});

  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  int kcal = 1250;
  int carbs = 125;
  int protein = 50;
  int fat = 50;

  void setValue(name, value) {
    switch (name) {
      case 'CALORIES':
        setState(() {
          kcal = value;
        });
        break;
      case 'CARBS':
        setState(() {
          carbs = value;
        });
        break;
      case 'PROTEIN':
        setState(() {
          protein = value;
        });
        break;
      case 'FAT':
        setState(() {
          fat = value;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              forceElevated: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Future.delayed(
                    Duration(milliseconds: 100),
                    () => {popContextWhenPossible(context)},
                  );
                },
              ),
              title: Text('Add food'),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height - 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // KCAL
                    FoodSliderCard(
                      name: 'CALORIES',
                      value: kcal,
                      setValue: setValue,
                      min: 0,
                      max: 2500,
                    ),

                    // CARBS
                    FoodSliderCard(
                      name: 'CARBS',
                      value: carbs,
                      setValue: setValue,
                      min: 0,
                      max: 250,
                    ),

                    // PROTEIN
                    FoodSliderCard(
                      name: 'PROTEIN',
                      value: protein,
                      setValue: setValue,
                      min: 0,
                      max: 100,
                    ),

                    // FAT
                    FoodSliderCard(
                      name: 'FAT',
                      value: fat,
                      setValue: setValue,
                      min: 0,
                      max: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(savingSnackbar);

          Nutrition nutrition = Nutrition(
            kcal: kcal,
            carbs: carbs,
            protein: protein,
            fat: fat,
            date: convertDateTimeToStringDate(DateTime.now()),
          );

          bool isSaved = await Database(uid: globals.uid)
              .addNutrition(nutrition, globals.nutritionHistory);

          if (isSaved) {
            await widget.refreshNutrition();

            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(saveSuccessSnackbar);

            Future.delayed(Duration(seconds: 1), () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              popContextWhenPossible(context);
            });
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(saveFailSnackbar);
          }
        },
      ),
    );
  }
}
