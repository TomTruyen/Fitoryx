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
            interval: _getInterval(userWeights, timespan),
            getTitles: (double value) {
              return _getTitleWithoutYear(value, datesList);
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
          _getUserWeightList(
            List.of(userWeights),
            datesList,
            settings,
            timespan,
          ),
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

double _getInterval(List<UserWeight> userWeights, int timespan) {
  final double maxInterval = 6.0;

  if (timespan > -1) {
    List<UserWeight> _userWeight = getUserWeightsWithinTimespan(
      userWeights,
      timespan,
    );

    if (_userWeight.length < maxInterval) return _userWeight.length.toDouble();
  } else {
    if (userWeights.length < maxInterval) return userWeights.length.toDouble();
  }

  return (userWeights.length / maxInterval).round().toDouble();
}

String _getTitle(double value, List<String> _datesList) {
  int _value = value.toInt();

  if (value < 0) value = 0;
  if (_value > _datesList.length - 1) _value = _datesList.length - 1;

  return _datesList[_value];
}

// gets title without year, also gets titles for values that "don't exist";
String _getTitleWithoutYear(double value, List<String> _datesList) {
  int _value = value.toInt();

  if (value < 0) value = 0;
  if (_value > _datesList.length - 1) _value = _datesList.length - 1;

  String _date = _datesList[_value];
  List<String> _splittedDate = _date.split('-');
  _splittedDate.removeLast();

  return _splittedDate.join('-');
}

LineChartBarData _getUserWeightList(
  List<UserWeight> userWeights,
  List<String> _datesList,
  Settings settings,
  int timespanInDays, //timespan in days from most recent datetime
) {
  if (userWeights.isEmpty) {
    DateTime now = DateTime.now();

    userWeights = [
      UserWeight(
          weightUnit: settings.weightUnit,
          timeInMilliseconds: now.millisecondsSinceEpoch),
      UserWeight(
        weightUnit: settings.weightUnit,
        timeInMilliseconds: now
            .subtract(
              Duration(days: timespanInDays),
            )
            .millisecondsSinceEpoch,
      ),
    ];
  } else if (userWeights.length < 2) {
    double weight = userWeights[0].weight;
    String weightUnit = userWeights[0].weightUnit;
    int timeInMilliseconds = DateTime.now()
        .subtract(Duration(days: timespanInDays))
        .millisecondsSinceEpoch;

    userWeights.add(
      UserWeight(
        weight: weight,
        weightUnit: weightUnit,
        timeInMilliseconds: timeInMilliseconds,
      ),
    );
  }

  userWeights = sortUserWeightsByDate(userWeights, false);

  if (timespanInDays > -1) {
    // -1 == ALL so no timespan
    userWeights = getUserWeightsWithinTimespan(userWeights, timespanInDays);
  }

  List<FlSpot> spots = [];

  for (int i = 0; i < userWeights.length; i++) {
    spots.add(
      FlSpot(
        i.toDouble(),
        userWeights[i].weight,
      ),
    );

    String _date = dateTimeToString(
      DateTime.fromMillisecondsSinceEpoch(
        userWeights[i].timeInMilliseconds,
      ),
    );

    _datesList.add(_date);
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
