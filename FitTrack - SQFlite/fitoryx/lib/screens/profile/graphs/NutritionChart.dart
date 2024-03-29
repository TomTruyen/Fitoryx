import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/food/Food.dart';
import 'package:Fitoryx/models/settings/Settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NutritionChart extends StatelessWidget {
  final List<Food> food;
  final Settings settings;
  final int timespan; // timespan of weightgraph (in days)

  final List<String> datesList = [];

  NutritionChart({this.food, this.settings, this.timespan = 30});

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
            interval: getInterval(food, timespan),
            getTitles: (double value) {
              return getTitleWithoutYear(value, datesList);
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
          _getFoodList(
            List.of(food),
            datesList,
            settings,
            timespan,
          ),
        ],
        showingTooltipIndicators: [],
        lineTouchData: LineTouchData(
          touchSpotThreshold: 16.0,
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
              dynamic kcal = spots[0].y;

              double timeInMillisecondsSinceEpoch = spots[0].x;

              String date = "/";

              date = getTitle(timeInMillisecondsSinceEpoch, datesList);

              return [
                LineTooltipItem(
                  "Date: $date \n${tryConvertDoubleToInt(kcal)} kcal",
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

double getInterval(List<Food> food, int timespan) {
  final double maxInterval = 6.0;

  if (timespan > -1) {
    List<Food> _food = getDataWithinTimespan(
      food,
      timespan,
    ).cast<Food>();

    if (_food.length < maxInterval) return _food.length.toDouble();
  } else {
    if (food.length < maxInterval) return food.length.toDouble();
  }

  double interval = (food.length / maxInterval).round().toDouble();
  if (interval <= 0) {
    interval = food.length.toDouble();
  }

  return interval;
}

LineChartBarData _getFoodList(
  List<Food> food,
  List<String> _datesList,
  Settings settings,
  int timespanInDays, //timespan in days from most recent datetime
) {
  food = getDataWithinTimespan(food, timespanInDays).cast<Food>();

  List<FlSpot> spots = [];

  for (int i = 0; i < food.length; i++) {
    double kcal = food[i].getTotalKcal();

    spots.add(
      FlSpot(
        i.toDouble(),
        kcal,
      ),
    );

    String _date = convertDateTimeToString(
      DateTime.fromMillisecondsSinceEpoch(
        food[i].timeInMillisSinceEpoch,
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
