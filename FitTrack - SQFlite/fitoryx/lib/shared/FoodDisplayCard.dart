import 'package:flutter/material.dart';

class FoodDisplayCard extends StatelessWidget {
  final dynamic value;
  final dynamic goal;
  final String name;
  final bool isMacro;

  FoodDisplayCard({
    this.value,
    this.goal,
    this.name,
    this.isMacro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: isMacro ? 4.0 : 8.0,
        vertical: 4.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name.toLowerCase() == 'kcal' ? "$value" : "${value}g",
            style: TextStyle(
              fontSize: isMacro
                  ? Theme.of(context).textTheme.bodyText2.fontSize
                  : Theme.of(context).textTheme.bodyText2.fontSize * 1.5,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            goal != null && goal > 0
                ? isMacro
                    ? 'OF $goal \n ${name.toUpperCase()}'
                    : 'OF $goal ${name.toUpperCase()}'
                : '${name.toUpperCase()}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMacro ? 12.0 : null,
            ),
          ),
        ],
      ),
    );
  }
}
