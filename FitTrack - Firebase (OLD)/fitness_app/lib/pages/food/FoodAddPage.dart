import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/shared/FoodSharedWidgets.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodAddPage extends StatefulWidget {
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
    final User user = Provider.of<User>(context) ?? null;

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
                        max: 100),
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

          final loadingSnackbar = SnackBar(
            elevation: 8.0,
            backgroundColor: Colors.orange[400],
            content: Text(
              'Saving...',
              textAlign: TextAlign.center,
            ),
            duration: Duration(minutes: 1),
          );

          ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar);

          dynamic result =
              await DatabaseService(uid: user != null ? user.uid : '')
                  .addNutrition(kcal, carbs, protein, fat);

          await Future.delayed(
            Duration(milliseconds: 500),
            () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          );

          if (result != null) {
            final successSnackbar = SnackBar(
              duration: Duration(seconds: 1),
              elevation: 8.0,
              backgroundColor: Colors.green[400],
              content: GestureDetector(
                child: Text(
                  'Saved',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(successSnackbar);

            Future.delayed(
              Duration(milliseconds: 1500),
              () {
                popContextWhenPossible(context);
              },
            );
          } else {
            final failureSnackbar = SnackBar(
              duration: Duration(seconds: 1),
              elevation: 8.0,
              backgroundColor: Colors.red[400],
              content: GestureDetector(
                child: Text(
                  'Save Failed',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(failureSnackbar);
          }
        },
      ),
    );
  }
}
