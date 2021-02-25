import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserWeightChart extends StatelessWidget {
  final List<UserWeight> userWeights;
  final Settings settings;

  UserWeightChart({this.userWeights, this.settings});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.blue[50], width: 1),
          ),
        ),
        lineBarsData: [
          _getUserWeightList(userWeights),
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
            // getTooltipItems: (List<LineBarSpot> spots) {
            //   String hour = spots[0].x > 12
            //       ? "${(spots[0].x - 12).toInt()} PM"
            //       : "${(spots[0].x).toInt()} AM";

            //   dynamic kcal = tryConvertDoubleToInt(spots[0].y);

            //   return [
            //     LineTooltipItem(
            //         "$hour \n $kcal KCAL", TextStyle(color: Colors.blue[50]))
            //   ];
            // },
            tooltipPadding: EdgeInsets.all(10.0),
            tooltipBgColor: Colors.blueGrey,
          ),
          touchCallback: (LineTouchResponse touchResponse) {},
        ),
      ),
    );
  }
}

LineChartBarData _getUserWeightList(List<UserWeight> userWeights) {
  userWeights = userWeights.reversed.toList();

  List<FlSpot> spots = [];

  if (userWeights.isEmpty) {
    // add FlSpots to fill graph at 0, maybe 1 flspot per month?
  } else {
    for (int i = 0; i < userWeights.length; i++) {
      spots.add(FlSpot(i.toDouble(), userWeights[i].weight));
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
