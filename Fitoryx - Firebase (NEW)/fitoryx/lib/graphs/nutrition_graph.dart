import 'package:fitoryx/graphs/models/nutrition_tooltip.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/utils/datetime_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NutritionGraph extends StatelessWidget {
  final int total = 7;
  final List<Nutrition> nutritions;

  const NutritionGraph({Key? key, required this.nutritions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.blueAccent,
                fontSize: 10,
              ),
              reservedSize: 22,
              getTitles: (value) {
                DateTime now =
                    DateTime.now().today().subtract(Duration(days: total));

                var date = now.add(Duration(days: value.toInt()));

                return DateFormat('dd-MM').format(date);
              },
            ),
            topTitles: SideTitles(showTitles: false),
            leftTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.blue[50]!, width: 1),
            ),
          ),
          minX: 1,
          maxX: total.toDouble(),
          lineBarsData: _getLineBars(),
          showingTooltipIndicators: [],
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator:
                (LineChartBarData data, List<int> touchSpots) {
              return touchSpots.map((touchSpot) {
                return TouchedSpotIndicatorData(
                  FlLine(strokeWidth: 0, color: Colors.transparent),
                  FlDotData(
                    show: true,
                    getDotPainter: (
                      FlSpot spot,
                      double percent,
                      LineChartBarData bar,
                      int index,
                    ) {
                      return FlDotCirclePainter(
                        color: Colors.blueAccent[700],
                        radius: 5.0,
                        strokeWidth: 0,
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              fitInsideVertically: true,
              fitInsideHorizontally: true,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> spots) {
                var x = spots[0].x;

                DateTime now = DateTime.now().subtract(Duration(days: total));
                now = DateTime(now.year, now.month, now.day);

                var date = now.add(Duration(days: x.toInt()));

                int index = nutritions.indexWhere(
                  (nutrition) => nutrition.date == date,
                );

                var tooltip = NutritionTooltip();
                if (index > -1) {
                  tooltip = NutritionTooltip.fromNutrition(nutritions[index]);
                }

                return [
                  LineTooltipItem(
                    tooltip.toString(),
                    TextStyle(color: Colors.blue[50]),
                  )
                ];
              },
            ),
            // touchCallback: (LineTouchResponse touchResponse) {},
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _getLineBars() {
    List<FlSpot> spots = [];

    DateTime now = DateTime.now().subtract(Duration(days: total)).today();
    for (int i = 1; i < total + 1; i++) {
      var date = now.add(Duration(days: i));

      int index = nutritions.indexWhere(
        (nutrition) => nutrition.date.isAtSameMomentAs(date),
      );

      if (index > -1) {
        spots.add(
          FlSpot(i.toDouble(), nutritions[index].kcal.toDouble()),
        );
      } else {
        spots.add(FlSpot(i.toDouble(), 0));
      }
    }

    return [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        curveSmoothness: 0.25,
        preventCurveOverShooting: true,
        colors: [
          Colors.blueAccent[700]!,
          Colors.blueAccent[400]!,
          Colors.blueAccent[200]!,
        ],
        barWidth: 2.0,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: [const Color.fromRGBO(227, 242, 253, 1)],
        ),
      )
    ];
  }
}
