import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/widgets/macro_progress.dart';
import 'package:flutter/material.dart';

class NutritionMacroGraph extends StatelessWidget {
  final Nutrition nutrition;
  final Settings settings;

  const NutritionMacroGraph(
      {Key? key, required this.nutrition, required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MacroProgress(
            title: 'Carbs',
            value: nutrition.carbs,
            goal: settings.carbs,
          ),
          MacroProgress(
            title: 'Protein',
            value: nutrition.protein,
            goal: settings.protein,
          ),
          MacroProgress(
            title: 'Fat',
            value: nutrition.fat,
            goal: settings.fat,
          ),
        ],
      ),
    );
  }
}
