import 'package:fitoryx/models/nutrition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NutritionHistoryCard extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionHistoryCard({Key? key, required this.nutrition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat('dd MMMM y').format(nutrition.date),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: Theme.of(context).textTheme.bodyText2?.fontSize,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Calories: ${nutrition.kcal}",
              style: TextStyle(
                fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize! * 0.8,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Carbs: ${nutrition.carbs}g",
              style: TextStyle(
                fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize! * 0.8,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Protein: ${nutrition.protein}g",
              style: TextStyle(
                fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize! * 0.8,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Fat: ${nutrition.fat}g",
              style: TextStyle(
                fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize! * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
