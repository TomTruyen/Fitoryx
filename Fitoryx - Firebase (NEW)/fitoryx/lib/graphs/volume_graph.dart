import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/datetime_extension.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VolumeGraph extends StatelessWidget {
  final int total = 7;
  final List<WorkoutHistory> workouts;
  final Settings settings;

  const VolumeGraph({Key? key, required this.workouts, required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 0.toDouble(),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.blueAccent,
              fontSize: 10,
            ),
            reservedSize: 22,
            getTitles: (value) {
              DateTime now = DateTime.now().today().subtract(
                    Duration(days: total),
                  );

              var date = now.add(Duration(days: value.toInt()));

              return DateFormat('dd-MM').format(date);
            },
          ),
          topTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.blue[50]!, width: 1),
          ),
        ),
        minX: 1,
        maxX: total.toDouble(),
        lineBarsData: _getLineBars(),
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
                  getDotPainter: (
                    FlSpot spot,
                    double percent,
                    LineChartBarData bar,
                    int index,
                  ) {
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
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> spots) {
              return [
                LineTooltipItem(
                  "${spots[0].y.toIntString()} ${UnitTypeHelper.toValue(settings.weightUnit)}",
                  TextStyle(color: Colors.blue[50]),
                )
              ];
            },
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _getLineBars() {
    List<FlSpot> spots = [];

    DateTime now = DateTime.now().subtract(Duration(days: total)).today();
    for (int i = 1; i < total + 1; i++) {
      var date = now.add(Duration(days: i));

      List<WorkoutHistory> dateWorkouts = workouts
          .where((workout) =>
              workout.date.isAtSameMomentAs(date) ||
              (workout.date.isAfter(date) &&
                  workout.date.isBefore(date.add(const Duration(days: 1)))))
          .toList();

      if (dateWorkouts.isEmpty) {
        spots.add(FlSpot(i.toDouble(), 0));
      } else {
        double volume = 0;

        for (var history in dateWorkouts) {
          volume += history.workout.getTotalVolume();
        }

        spots.add(FlSpot(i.toDouble(), volume));
      }
    }

    return [
      LineChartBarData(
        spots: spots,
        colors: [
          Colors.blueAccent[700]!,
          Colors.blueAccent[400]!,
          Colors.blueAccent[200]!,
        ],
        barWidth: 2.0,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: [const Color.fromRGBO(227, 242, 253, 1)],
        ),
      )
    ];
  }
}
