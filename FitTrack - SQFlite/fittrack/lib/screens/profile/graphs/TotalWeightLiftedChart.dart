import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/exercises/ExerciseSet.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalWeightLiftedChart extends StatelessWidget {
  final List<Workout> workoutHistory;
  final Settings settings;
  final int timespan;

  final List<String> datesList = [];

  TotalWeightLiftedChart({
    this.workoutHistory,
    this.settings,
    this.timespan = 30,
  });

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
            interval: getInterval(workoutHistory, timespan, settings),
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
          _getTotalWeightLiftedList(
            List.of(workoutHistory),
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

              date = getTitle(timeInMillisecondsSinceEpoch, datesList);

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

double getInterval(
    List<Workout> workoutHistory, int timespan, Settings settings) {
  final double maxInterval = 6.0;

  if (workoutHistory.isEmpty) {
    DateTime now = DateTime.now();

    workoutHistory = [
      Workout(
          weightUnit: settings.weightUnit,
          timeInMillisSinceEpoch:
              now.subtract(Duration(days: 10)).millisecondsSinceEpoch,
          exercises: [
            Exercise(sets: [ExerciseSet(weight: 10, reps: 10)])
          ]),
      Workout(
          weightUnit: settings.weightUnit,
          timeInMillisSinceEpoch:
              now.subtract(Duration(days: 17)).millisecondsSinceEpoch),
    ];

    // workoutHistory = [
    //   Workout(
    //     weightUnit: settings.weightUnit,
    //     timeInMillisSinceEpoch: now.millisecondsSinceEpoch,
    //   ),
    //   Workout(
    //     weightUnit: settings.weightUnit,
    //     timeInMillisSinceEpoch: now
    //         .subtract(
    //           Duration(days: timespan),
    //         )
    //         .millisecondsSinceEpoch,
    //   ),
    // ];
  } else if (workoutHistory.length < 2) {
    Workout _clone = workoutHistory[0].clone();
    _clone.timeInMillisSinceEpoch = DateTime.now()
        .subtract(Duration(days: timespan))
        .millisecondsSinceEpoch;

    workoutHistory.add(_clone);
  }

  if (timespan > -1) {
    List<Workout> _workoutHistory = getWorkoutHistoryWithinTimespan(
      workoutHistory,
      timespan,
    );

    if (_workoutHistory.length < maxInterval)
      return _workoutHistory.length.toDouble();
  } else {
    if (workoutHistory.length < maxInterval)
      return workoutHistory.length.toDouble();
  }

  return (workoutHistory.length / maxInterval).round().toDouble();
}

LineChartBarData _getTotalWeightLiftedList(
  List<Workout> workoutHistory,
  List<String> datesList,
  Settings settings,
  int timespan,
) {
  if (workoutHistory.isEmpty) {
    DateTime now = DateTime.now();

    workoutHistory = [
      Workout(
        weightUnit: settings.weightUnit,
        timeInMillisSinceEpoch: now.millisecondsSinceEpoch,
      ),
      Workout(
        weightUnit: settings.weightUnit,
        timeInMillisSinceEpoch: now
            .subtract(
              Duration(days: timespan),
            )
            .millisecondsSinceEpoch,
      ),
    ];
  } else if (workoutHistory.length < 2) {
    Workout _clone = workoutHistory[0].clone();
    _clone.timeInMillisSinceEpoch = DateTime.now()
        .subtract(Duration(days: timespan))
        .millisecondsSinceEpoch;

    workoutHistory.add(_clone);
  }

  List<FlSpot> spots = [];

  workoutHistory = sortWorkoutHistoryByDate(workoutHistory, false);

  workoutHistory = getWorkoutHistoryWithinTimespan(workoutHistory, timespan);

  for (int i = 0; i < workoutHistory.length; i++) {
    spots.add(FlSpot(i.toDouble(), workoutHistory[i].getTotalWeightLifted()));

    String date = dateTimeToString(
      DateTime.fromMillisecondsSinceEpoch(
        workoutHistory[i].timeInMillisSinceEpoch,
      ),
    );

    datesList.add(date);
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
