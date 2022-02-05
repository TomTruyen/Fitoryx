import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NutritionCaloriesGraph extends StatelessWidget {
  final Nutrition nutrition;
  final Settings settings;

  const NutritionCaloriesGraph(
      {Key? key, required this.nutrition, required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    nutrition.kcal.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Calories',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sections: _getSections(),
                  borderData: FlBorderData(
                    show: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    if (settings.kcal == null) {
      return [
        PieChartSectionData(
          value: nutrition.kcal > 0 ? nutrition.kcal.toDouble() : 1,
          color: nutrition.kcal > 0 ? Colors.blue[700] : Colors.blue[200],
          radius: 10,
          showTitle: false,
        ),
      ];
    }

    return [
      PieChartSectionData(
        value: nutrition.kcal.toDouble(),
        color: Colors.blue[700],
        radius: 10,
        showTitle: false,
      ),
      PieChartSectionData(
        value: (settings.kcal! - nutrition.kcal).abs().toDouble(),
        color: Colors.blue[200],
        radius: 10,
        showTitle: false,
      ),
    ];
  }
}
