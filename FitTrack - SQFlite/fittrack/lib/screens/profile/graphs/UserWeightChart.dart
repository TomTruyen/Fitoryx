import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserWeightChart extends StatelessWidget {
  final List<UserWeight> userWeights;
  final Settings settings;
  final int timespan; // timespan of weightgraph (in days)

  final List<String> datesList = [];

  UserWeightChart({this.userWeights, this.settings, this.timespan = 30});

  @override
  Widget build(BuildContext context) {
    return LineChart(
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
            getTitles: (double value) {
              return _getTitle(value, datesList);
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
        minY: 0,
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.blue[50], width: 1),
          ),
        ),
        lineBarsData: [
          _getUserWeightList(userWeights, datesList, timespan),
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
              double weight = spots[0].y;
              double timeInMillisecondsSinceEpoch = spots[0].x;

              String date = "/";

              date = _getTitle(timeInMillisecondsSinceEpoch, datesList);

              return [
                LineTooltipItem(
                  "Date: $date \n$weight ${settings.weightUnit}",
                  TextStyle(color: Colors.blue[50]),
                )
              ];
            },
            tooltipPadding: EdgeInsets.all(10.0),
            tooltipBgColor: Colors.blueGrey,
          ),
          touchCallback: (LineTouchResponse touchResponse) {},
        ),
      ),
    );
  }
}

String _getTitle(double value, List<String> _datesList) {
  int _value = value.toInt();

  return _datesList[_value];
}

LineChartBarData _getUserWeightList(
  List<UserWeight> userWeights,
  List<String> _datesList,
  int timespanInDays, //timespan in days from most recent datetime
) {
  userWeights = List.of(userWeights).reversed.toList();

  userWeights = getUserWeightsWithinTimespan(userWeights, timespanInDays);

  List<FlSpot> spots = [];

  for (int i = 0; i < userWeights.length; i++) {
    spots.add(
      FlSpot(
        i.toDouble(),
        userWeights[i].weight,
      ),
    );

    _datesList.add(
      dateTimeToStringWithoutYear(
        DateTime.fromMillisecondsSinceEpoch(
          userWeights[i].timeInMilliseconds,
        ),
      ),
    );
  }

  if (spots.isEmpty) {
    for (int i = 0; i < 2; i++) {
      spots.add(FlSpot(i.toDouble(), 0));
      _datesList.add("");
    }
  } else if (spots.length < 2) {
    spots.add(FlSpot(1, spots[0].y));
    _datesList.insert(
      0,
      dateTimeToStringWithoutYear(
        DateTime.fromMillisecondsSinceEpoch(
          userWeights[0].timeInMilliseconds,
        ).subtract(
          Duration(
            days: 1,
          ),
        ),
      ),
    );
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
