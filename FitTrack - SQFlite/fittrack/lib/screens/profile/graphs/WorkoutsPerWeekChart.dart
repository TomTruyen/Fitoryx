import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/functions/Functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutsPerWeekChart extends StatelessWidget {
  final List<Workout> workoutHistory;
  final Settings settings;

  final List<String> datesList = [];

  WorkoutsPerWeekChart({this.workoutHistory, this.settings});

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
) {
  const TOTAL_WEEKS = 6;
  bool _isBetweenDates(
    DateTime beforeDate,
    DateTime afterDate,
    DateTime valueDate,
  ) {
    return valueDate.isBefore(beforeDate) &&
        (valueDate.isAtSameMomentAs(afterDate) || valueDate.isAfter(afterDate));
  }

  void _insertData(
    DateTime startOfCurrentWeek,
    List<BarChartGroupData> workoutsPerWeekBarData,
    int count,
  ) {
    _datesList.insert(
      0,
      dateTimeToStringWithoutYear(startOfCurrentWeek),
    );

    workoutsPerWeekBarData.insert(
      0,
      BarChartGroupData(
        x: TOTAL_WEEKS - workoutsPerWeekBarData.length,
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

  List<Workout> workoutHistory = _workoutHistory ?? [];

  workoutHistory.sort(
    (a, b) => a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch),
  );

  List<BarChartGroupData> workoutsPerWeekBarData = [];

  DateTime now = DateTime.now();
  DateTime startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
  startOfCurrentWeek = convertDateTimeToDate(startOfCurrentWeek);

  DateTime startOfNextWeek = now.add(Duration(days: 7 - now.weekday));
  startOfNextWeek = convertDateTimeToDate(startOfNextWeek);

  int count = 0;
  if (workoutHistory.isNotEmpty) {
    for (int i = workoutHistory.length - 1; i >= 0; i--) {
      DateTime workoutDate = DateTime.fromMillisecondsSinceEpoch(
        workoutHistory[i].timeInMillisSinceEpoch,
      );

      if (_isBetweenDates(startOfNextWeek, startOfCurrentWeek, workoutDate)) {
        count++;
      } else {
        _insertData(startOfCurrentWeek, workoutsPerWeekBarData, count);

        if (workoutsPerWeekBarData.length >= TOTAL_WEEKS) {
          break;
        }

        count = 0;

        bool isBetweenDates = false;
        while (!isBetweenDates) {
          startOfCurrentWeek = startOfCurrentWeek.subtract(Duration(days: 7));
          startOfNextWeek = startOfNextWeek.subtract(Duration(days: 7));

          if (_isBetweenDates(
              startOfNextWeek, startOfCurrentWeek, workoutDate)) {
            isBetweenDates = true;
            count++;
          } else if (workoutsPerWeekBarData.length >= TOTAL_WEEKS) {
            isBetweenDates = true;
            break;
          } else {
            _insertData(startOfCurrentWeek, workoutsPerWeekBarData, 0);
          }
        }
      }
    }

    if (count != 0) {
      _insertData(startOfCurrentWeek, workoutsPerWeekBarData, count);
    }
  }

  if (workoutsPerWeekBarData.length < TOTAL_WEEKS) {
    int diff = TOTAL_WEEKS - workoutsPerWeekBarData.length;

    if (workoutsPerWeekBarData.length == 0) {
      startOfCurrentWeek = startOfCurrentWeek.add(Duration(days: 7));
      startOfNextWeek = startOfNextWeek.add(Duration(days: 7));
    }

    for (int i = 0; i < diff; i++) {
      startOfCurrentWeek = startOfCurrentWeek.subtract(Duration(days: 7));
      startOfNextWeek = startOfNextWeek.subtract(Duration(days: 7));

      _insertData(startOfCurrentWeek, workoutsPerWeekBarData, 0);
    }
  }

  return workoutsPerWeekBarData;
}
