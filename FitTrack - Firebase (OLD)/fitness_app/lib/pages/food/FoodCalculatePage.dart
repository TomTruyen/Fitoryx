import 'package:fitness_app/misc/Functions.dart';
import 'package:flutter/material.dart';

class FoodCalculatePage extends StatefulWidget {
  @override
  _FoodCalculatePageState createState() => _FoodCalculatePageState();
}

class _FoodCalculatePageState extends State<FoodCalculatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              forceElevated: true,
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  popContextWhenPossible(context);
                },
              ),
              title: Text('Calculate Nutrition'),
            ),
            SliverFillRemaining(
              child: Column(
                children: <Widget>[
                  Text('USE CALCULATION METHOD OF FITFOOD APP'),
                  Text('ADD OPTION TO SAVE THIS AS GOAL'),
                  Text(
                      'ALLOW USER TO ADJUST VALUES (SO REUSE THE FoodSharedWidget)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
