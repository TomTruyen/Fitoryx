import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/food/FoodPerHour.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FoodGraph extends StatelessWidget {
  final List<FoodPerHour> foodPerHourList;

  FoodGraph({this.foodPerHourList});

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
              getTextStyles: (value) => const TextStyle(
                color: Colors.blueAccent,
                fontSize: 10.0,
              ),
              reservedSize: 22.0,
              getTitles: (value) {
                switch (value.toInt()) {
                  case 3:
                    return "3 AM";
                  case 6:
                    return "6 AM";
                  case 9:
                    return "9 AM";
                  case 12:
                    return "12 PM";
                  case 15:
                    return "3 PM";
                  case 18:
                    return "6 PM";
                  case 21:
                    return "9 PM";
                }

                return "";
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.blue[50], width: 1),
            ),
          ),
          minX: 0,
          maxX: 23,
          lineBarsData: [
            _getDailyKcalDataList(foodPerHourList),
          ],
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
                    getDotPainter: (FlSpot spot, double percent,
                        LineChartBarData bar, int index) {
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
              getTooltipItems: (List<LineBarSpot> spots) {
                String hour = spots[0].x > 12
                    ? "${(spots[0].x - 12).toInt()} PM"
                    : "${(spots[0].x).toInt()} AM";

                dynamic kcal = tryConvertDoubleToInt(spots[0].y);

                return [
                  LineTooltipItem(
                      "$hour \n $kcal KCAL", TextStyle(color: Colors.blue[50]))
                ];
              },
              tooltipPadding: EdgeInsets.all(10.0),
              tooltipBgColor: Colors.blueGrey,
            ),
            touchCallback: (LineTouchResponse touchResponse) {},
          ),
        ),
      ),
    );
  }
}

LineChartBarData _getDailyKcalDataList(List<FoodPerHour> foodPerHourList) {
  List<FlSpot> spots = [];

  if (foodPerHourList.isEmpty) {
    for (int i = 0; i < 24; i++) {
      spots.add(FlSpot(i.toDouble(), 0));
    }
  } else {
    for (int i = 0; i < foodPerHourList.length; i++) {
      spots.add(FlSpot(i.toDouble(), foodPerHourList[i].kcal));
    }
  }

  return LineChartBarData(
    spots: spots,
    isCurved: true,
    curveSmoothness: 0.5,
    preventCurveOverShooting: true,
    colors: [
      Colors.blueAccent[700],
      Colors.blueAccent[400],
      Colors.blueAccent[200],
    ],
    barWidth: 2.0,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: true,
      colors: [Color.fromRGBO(227, 242, 253, 1)],
    ),
  );
}
