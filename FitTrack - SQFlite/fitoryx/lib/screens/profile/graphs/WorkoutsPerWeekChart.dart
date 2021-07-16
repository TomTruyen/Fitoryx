import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/settings/Settings.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutsPerWeekChart extends StatelessWidget {
  final List<Workout> workoutHistory;
  final Settings settings;

  final List<String> datesList = [];

  WorkoutsPerWeekChart({
    this.workoutHistory,
    this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
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
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.blue[50], width: 1),
          ),
        ),
        barGroups: _getWorkoutsPerWeekBarDataList(
          workoutHistory,
          datesList,
          settings,
          MediaQuery.of(context).size.shortestSide,
        ),
        barTouchData: BarTouchData(
          touchExtraThreshold: EdgeInsets.all(12.0),
          touchTooltipData: BarTouchTooltipData(
              tooltipPadding: EdgeInsets.all(10.0),
              tooltipBgColor: Colors.blueGrey,
              fitInsideVertically: true,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String date = _getTitle(group.x.toDouble(), datesList);

                date = date.split('-').join('/');

                String untilDate =
                    "${(int.parse(date.split('/')[0]) + 7)}/${date.split('/')[1]}";

                return BarTooltipItem(
                  "$date - $untilDate \n ${rod.y.toInt()} workout",
                  TextStyle(color: Colors.blue[50]),
                );
              }),
        ),
      ),
    );
  }
}

String _getTitle(double value, List<String> _datesList) {
  int _value = value.toInt();

  return _datesList[_value - 1];
}

List<BarChartGroupData> _getWorkoutsPerWeekBarDataList(
  List<Workout> _workoutHistory,
  List<String> _datesList,
  Settings settings,
  double shortestSize,
) {
  final totalWeeks = shortestSize < 600 ? 6 : 12;

  void _insertData(
    DateTime startOfCurrentWeek,
    List<BarChartGroupData> workoutsPerWeekBarData,
    int count,
  ) {
    _datesList.insert(
      0,
      convertDateTimeToStringWithoutYear(startOfCurrentWeek),
    );

    workoutsPerWeekBarData.insert(
      0,
      BarChartGroupData(
        x: totalWeeks - workoutsPerWeekBarData.length,
        barRods: [
          BarChartRodData(
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              y: settings.workoutsPerWeekGoal?.toDouble() ?? 7,
              colors: [Colors.blue[50]],
            ),
            colors: [
              Colors.blueAccent[700],
              Colors.blueAccent[400],
              Colors.blueAccent[200],
            ],
            width: 20,
            y: count.toDouble(),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8.0),
              bottom: Radius.zero,
            ),
          ),
        ],
      ),
    );
  }

  List<Workout> getWorkoutsWithinTimespan(
    List<Workout> workouts,
    DateTime start,
    DateTime end,
  ) {
    List<Workout> workoutsWithinTimespan = workouts.where((Workout workout) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        workout.timeInMillisSinceEpoch,
      );

      if (date.isBefore(end) &&
          (date.isAfter(start) || isSameDay(date, start))) {
        return true;
      }

      return false;
    }).toList();

    return workoutsWithinTimespan;
  }

  List<Workout> workoutHistory = _workoutHistory ?? [];

  workoutHistory.sort(
    (a, b) => a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch),
  );

  List<BarChartGroupData> workoutsPerWeekBarData = [];

  DateTime now = DateTime.now();
  DateTime startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
  startOfCurrentWeek = convertDateTimeToDate(startOfCurrentWeek);

  DateTime startOfNextWeek = now.add(Duration(days: 7 - now.weekday + 1));
  startOfNextWeek = convertDateTimeToDate(startOfNextWeek);

  for (int i = 0; i < totalWeeks; i++) {
    List<Workout> workoutsWithinTimespan = getWorkoutsWithinTimespan(
      _workoutHistory,
      startOfCurrentWeek,
      startOfNextWeek,
    );

    int count = workoutsWithinTimespan.length;

    _insertData(startOfCurrentWeek, workoutsPerWeekBarData, count);

    startOfCurrentWeek = startOfCurrentWeek.subtract(Duration(days: 7));
    startOfNextWeek = startOfNextWeek.subtract(Duration(days: 7));
  }

  return workoutsPerWeekBarData;
}
