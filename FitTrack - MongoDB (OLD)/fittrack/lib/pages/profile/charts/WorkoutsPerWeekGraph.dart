import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/model/settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WorkoutsPerWeekChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final int workoutsCount;
  final Settings settings;

  WorkoutsPerWeekChart({
    this.seriesList,
    this.animate = false,
    this.workoutsCount = 0,
    @required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return charts.OrdinalComboChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        cornerStrategy: const charts.ConstCornerStrategy(5),
        barRendererDecorator: charts.BarLabelDecorator<String>(),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
          ),
          tickLengthPx: 0,
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: settings.workoutPerWeekGoal.isEnabled && workoutsCount > 0
            ? charts.GridlineRendererSpec(
                lineStyle: charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(
                    Colors.green[800],
                  ),
                ),
              )
            : charts.NoneRenderSpec(),
        tickProviderSpec: settings.workoutPerWeekGoal.isEnabled &&
                workoutsCount > 0
            ? charts.StaticNumericTickProviderSpec([
                charts.TickSpec(
                  settings.workoutPerWeekGoal.goal,
                  style: charts.TextStyleSpec(
                    color: charts.ColorUtil.fromDartColor(Colors.green[800]),
                  ),
                )
              ])
            : null,
      ),
      customSeriesRenderers: [
        charts.LineRendererConfig(
          strokeWidthPx: 1,
          customRendererId: 'targetLine',
        ),
      ],
    );
  }
}

class WorkoutsPerWeek {
  final String week;
  final int workoutCount;
  final DateTime workoutDate;

  WorkoutsPerWeek({this.week, this.workoutCount, this.workoutDate});
}

List<charts.Series<WorkoutsPerWeek, String>> convertWorkoutsToChartSeries(
  List<WorkoutHistory> workouts,
  Color themeAccentColor,
  Settings settings,
) {
  final int minWorkouts = 8;
  List<WorkoutsPerWeek> data = [];
  List<WorkoutsPerWeek> targetData = [];

  DateTime getMonday(DateTime date) {
    return date.subtract(Duration(days: (date.weekday - 1)));
  }

  String getDateAsString(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  }

  int weeksBetween(DateTime newDate, DateTime oldDate) {
    return ((newDate.difference(oldDate).inDays).abs() / 7).floor();
  }

  bool isAtleastOneWeekBetween(DateTime newDate, DateTime oldDate) {
    if (weeksBetween(newDate, oldDate) >= 1) {
      return true;
    }

    return false;
  }

  void addData(DateTime date, int count) {
    data.add(
      WorkoutsPerWeek(
        week: getDateAsString(date),
        workoutCount: count,
        workoutDate: date,
      ),
    );

    targetData.add(
      WorkoutsPerWeek(
        week: getDateAsString(date),
        workoutCount: settings.workoutPerWeekGoal.goal,
        workoutDate: date,
      ),
    );
  }

  void insertData(DateTime date, int count, int index) {
    data.insert(
      index,
      WorkoutsPerWeek(
        week: getDateAsString(date),
        workoutCount: count,
        workoutDate: date,
      ),
    );

    targetData.insert(
      index,
      WorkoutsPerWeek(
        week: getDateAsString(date),
        workoutCount: settings.workoutPerWeekGoal.goal,
        workoutDate: date,
      ),
    );
  }

  void deleteData(int index) {
    data.removeAt(index);
    targetData.removeAt(index);
  }

  workouts.sort((a, b) => a.workoutTime.compareTo(b.workoutTime));

  int workoutCount = 0;
  DateTime workoutTime;

  workouts.forEach((workout) {
    DateTime dateMonday = getMonday(workout.workoutTime);

    if (workoutTime == null) {
      workoutTime = dateMonday;
    }

    if (isAtleastOneWeekBetween(dateMonday, workoutTime)) {
      addData(workoutTime, workoutCount);

      int weeks = weeksBetween(dateMonday, workoutTime);

      for (int i = 0; i < weeks - 1; i++) {
        workoutTime = workoutTime.add(Duration(days: 7));

        addData(workoutTime, 0);
      }

      workoutCount = 1;
      workoutTime = dateMonday;
    } else {
      workoutCount++;
    }
  });

  if (workoutTime != null && workoutCount > 0) {
    addData(workoutTime, workoutCount);
  }

  if (data.length > 0) {
    DateTime lastDate = getMonday(data[data.length - 1].workoutDate);

    DateTime lastMonday = getMonday(DateTime.now());

    if (lastDate != lastMonday) {
      int weeks = weeksBetween(lastDate, lastMonday);

      DateTime startDate = lastDate.add(Duration(days: 7));

      for (int i = 0; i < weeks + 1; i++) {
        addData(startDate, 0);

        startDate = startDate.add(Duration(days: 7));
      }
    }
  }

  if (data.length < minWorkouts) {
    DateTime date = data.length > 0 ? data[0].workoutDate : DateTime.now();
    int difference = minWorkouts - data.length;

    for (int i = 0; i < difference; i++) {
      date = date.subtract(Duration(days: 7));

      insertData(date, 0, 0);
    }
  } else if (data.length > minWorkouts) {
    // Remove in front (until we find a solution to scroll on the graph to earlier dates)
    int difference = data.length - minWorkouts;

    for (int i = 0; i < difference; i++) {
      deleteData(0);
    }
  }

  if (settings.workoutPerWeekGoal.isEnabled) {
    return [
      new charts.Series<WorkoutsPerWeek, String>(
        id: 'WorkoutsPerWeek',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(themeAccentColor),
        domainFn: (WorkoutsPerWeek workouts, _) => workouts.week,
        measureFn: (WorkoutsPerWeek workouts, _) => workouts.workoutCount,
        data: data,
        labelAccessorFn: (WorkoutsPerWeek workouts, _) =>
            workouts.workoutCount > 0 ? workouts.workoutCount.toString() : null,
      ),
      new charts.Series<WorkoutsPerWeek, String>(
        id: 'WorkoutsPerWeekGoal',
        colorFn: (_, __) => workouts.length > 0
            ? charts.ColorUtil.fromDartColor(
                Colors.green[800],
              )
            : charts.ColorUtil.fromDartColor(Colors.transparent),
        domainFn: (WorkoutsPerWeek workouts, _) => workouts.week,
        measureFn: (WorkoutsPerWeek workouts, _) => workouts.workoutCount,
        data: targetData,
      )..setAttribute(charts.rendererIdKey, 'targetLine')
    ];
  }

  return [
    new charts.Series<WorkoutsPerWeek, String>(
      id: 'WorkoutsPerWeek',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(themeAccentColor),
      domainFn: (WorkoutsPerWeek workouts, _) => workouts.week,
      measureFn: (WorkoutsPerWeek workouts, _) => workouts.workoutCount,
      data: data,
      labelAccessorFn: (WorkoutsPerWeek data, _) =>
          data.workoutCount > 0 ? data.workoutCount.toString() : null,
    ),
  ];
}
