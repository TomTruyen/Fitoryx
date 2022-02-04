import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/datetime_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutsPerWeekGraph extends StatelessWidget {
  final int total = 6;

  final int? goal;
  final List<WorkoutHistory> history;

  const WorkoutsPerWeekGraph({Key? key, this.goal, required this.history})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.blueAccent,
              fontSize: 10.0,
            ),
            getTitles: (double value) {
              int index = value.toInt();

              DateTime start = DateTime.now()
                  .today()
                  .startOfWeek()
                  .subtract(Duration(days: (total - index) * 7));

              return DateFormat("dd-MM").format(start);
            },
          ),
          leftTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.blue[50]!, width: 1),
          ),
        ),
        barGroups: _getBarGroups(),
        barTouchData: BarTouchData(
          touchExtraThreshold: const EdgeInsets.all(12),
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipBgColor: Colors.blueGrey,
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              int index = group.x.toInt();

              DateTime startDate = DateTime.now()
                  .today()
                  .startOfWeek()
                  .subtract(Duration(days: (total - index) * 7));

              DateTime endDate = startDate.add(const Duration(days: 7));

              String start = DateFormat("dd/MM").format(startDate);
              String end = DateFormat("dd/MM").format(endDate);

              return BarTooltipItem(
                "$start - $end\n${rod.y.toInt()} workouts",
                TextStyle(color: Colors.blue[50]!),
              );
            },
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    List<BarChartGroupData> barGroups = [];

    DateTime start = DateTime.now().today().startOfWeek();
    DateTime end = start.add(const Duration(days: 7));

    for (int i = 0; i < total; i++) {
      // Get Count (y-value)
      int count = history
          .where((h) =>
              h.date.isAtSameMomentAs(start) ||
              (h.date.isAfter(start) && h.date.isBefore(end)))
          .toList()
          .length;

      // Add BarChartGroupData
      barGroups.insert(
        0,
        BarChartGroupData(
          x: total - barGroups.length,
          barRods: <BarChartRodData>[
            BarChartRodData(
              y: count.toDouble(),
              width: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: Radius.zero,
              ),
              colors: <Color>[
                Colors.blueAccent[700]!,
                Colors.blueAccent[400]!,
                Colors.blueAccent[200]!,
              ],
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                y: goal?.toDouble() ?? 7,
                colors: <Color>[
                  Colors.blue[50]!,
                ],
              ),
            ),
          ],
        ),
      );

      // Update Dates
      start = start.subtract(const Duration(days: 7));
      end = end.subtract(const Duration(days: 7));
    }

    return barGroups;
  }
}
