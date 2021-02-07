import 'package:flutter/material.dart';

class FoodDisplayCard extends StatelessWidget {
  final dynamic value;
  final dynamic goal;
  final String name;

  FoodDisplayCard({this.value, this.goal, this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name.toLowerCase() == 'kcal' ? "$value" : "${value}g",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyText2.fontSize * 1.5,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            goal != null && goal > 0
                ? 'OF $goal ${name.toUpperCase()}'
                : '${name.toUpperCase()}',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
