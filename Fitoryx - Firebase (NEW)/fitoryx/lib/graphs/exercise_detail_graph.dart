import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/exercise_graph_type.dart';

class ExerciseDetailGraph extends StatelessWidget {
  final Exercise exercise;
  final List<WorkoutHistory> history;
  final ExerciseGraphType type;
  final Settings settings;

  const ExerciseDetailGraph({
    Key? key,
    required this.exercise,
    required this.history,
    required this.type,
    required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            interval: history.length > 10
                ? history.length / (history.length / 10)
                : 1,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.blueAccent,
              fontSize: 10,
            ),
            reservedSize: 22,
            getTitles: (value) {
              return DateFormat('dd-MM').format(history[value.toInt()].date);
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
              var x = spots[0].x.toInt();

              String tooltip = "";

              switch (type) {
                case ExerciseGraphType.volume:
                  tooltip =
                      "${history[x].workout.getExerciseVolume(exercise).toIntString()!} ${UnitTypeHelper.toValue(settings.weightUnit)}";
                  break;
                case ExerciseGraphType.reps:
                  tooltip =
                      "${history[x].workout.getExerciseMaxReps(exercise)} reps";
                  break;
                case ExerciseGraphType.weight:
                  tooltip =
                      "${history[x].workout.getExerciseMaxWeight(exercise).toIntString()!} ${UnitTypeHelper.toValue(settings.weightUnit)}";
                  break;
              }

              return [
                LineTooltipItem(
                  tooltip,
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

    for (int i = 0; i < history.length; i++) {
      // Limit length to 25 to nut clutter the graph
      if (history.length >= 25) {
        history.removeAt(0);
      }

      double value = 0;

      switch (type) {
        case ExerciseGraphType.volume:
          value = history[i].workout.getExerciseVolume(exercise);
          break;
        case ExerciseGraphType.reps:
          value = history[i].workout.getExerciseMaxReps(exercise).toDouble();
          break;
        case ExerciseGraphType.weight:
          value = history[i].workout.getExerciseMaxWeight(exercise);
          break;
      }

      spots.add(FlSpot(i.toDouble(), value));
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
