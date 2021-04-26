import 'package:fitness_app/models/settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeightChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final int weightHistoryCount;

  final UserSettings settings;

  static String pointerValue = "0";

  WeightChart({
    this.seriesList,
    this.animate = false,
    this.weightHistoryCount = 0,
    @required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return charts.OrdinalComboChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(
        includeLine: true,
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
        renderSpec: settings.weightGoal.isEnabled && weightHistoryCount > 0
            ? charts.GridlineRendererSpec(
                lineStyle: charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(
                    Colors.green[800],
                  ),
                ),
              )
            : null,
        tickProviderSpec:
            settings.weightGoal.isEnabled && weightHistoryCount > 0
                ? charts.StaticNumericTickProviderSpec(
                    [
                      charts.TickSpec(
                        settings.weightGoal.goal,
                        style: charts.TextStyleSpec(
                          color: charts.ColorUtil.fromDartColor(Colors.green[800]),
                        ),
                      ),
                    ],
                  )
                : null,
      ),
      behaviors: [
        charts.RangeAnnotation(
          [
            charts.LineAnnotationSegment(
              settings.weightGoal.goal,
              charts.RangeAnnotationAxisType.measure,
              strokeWidthPx: 1,
              color: charts.ColorUtil.fromDartColor(Colors.green[800],),
            ),
          ],
        ),
      ],
    );
  }
}

class Weight {
  final String date;
  final double weight;
  final String dateOriginal;

  Weight({
    this.date,
    this.weight,
    this.dateOriginal,
  });
}

List<charts.Series<Weight, String>> convertWeightToChartSeries(
  Color themeAccentColor,
  UserSettings settings,
) {
  String _dateStringWithoutYear(String date) {
    List<String> dateSplitted = date.split('-');

    return "${dateSplitted[0]}/${dateSplitted[1]}";
  }

  String _dateAsString(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  }

  List weightHistory = settings.weightHistory;

  final int minWeight = 8;
  List<Weight> data = [];

  weightHistory.sort((a, b) => a['date'].compareTo(b['date']));

  weightHistory.forEach((weight) {
    data.add(
      Weight(
        date: _dateStringWithoutYear(weight['date']),
        weight: weight['weight'],
        dateOriginal: weight['date'],
      ),
    );
  });

  if (data.length < minWeight) {
    DateTime _convertStringToDateTime(String date) {
      // Date is in following format: DD-MM-YYYY

      List<String> _dateSplitted = date.split('-');

      return DateTime.parse(
          "${_dateSplitted[2].padLeft(2, '0')}${_dateSplitted[1].padLeft(2, '0')}${_dateSplitted[0].padLeft(2, '0')}");
    }

    List<DateTime> _weightDates = [];

    for (int i = 0; i < data.length; i++) {
      DateTime _convertedToDateTime =
          _convertStringToDateTime(data[i].dateOriginal);

      if (_convertedToDateTime != null) {
        _weightDates.add(_convertedToDateTime);
      }
    }

    if (_weightDates.length > 0) {
      DateTime firstDate = _weightDates[0];
      DateTime lastDate = _weightDates[_weightDates.length - 1];

      int averageDaysBetween = firstDate.difference(lastDate).abs().inDays;

      if (averageDaysBetween == 0) {
        averageDaysBetween = 1;
      }

      int difference = minWeight - data.length;

      DateTime currentDate = firstDate;

      for (int i = 0; i < difference; i++) {
        currentDate = currentDate.subtract(Duration(days: averageDaysBetween));

        data.insert(0, Weight(date: _dateAsString(currentDate), weight: 0));
      }
    }
  } else if (data.length > minWeight) {
    int difference = data.length - minWeight;

    for (int i = 0; i < difference; i++) {
      data.removeAt(0);
    }
  }

  return [
    new charts.Series<Weight, String>(
      id: 'WeightHistory',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(themeAccentColor),
      domainFn: (Weight weight, _) => weight.date,
      measureFn: (Weight weight, _) => weight.weight,
      data: data,
    ),
  ];
}
