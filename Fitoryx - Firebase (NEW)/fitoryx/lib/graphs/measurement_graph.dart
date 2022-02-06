import 'package:fitoryx/models/body_weight.dart';
import 'package:fitoryx/models/fat_percentage.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeasurementGraph extends StatelessWidget {
  final List<dynamic> data;

  const MeasurementGraph({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            interval: data.length > 10 ? data.length / (data.length / 10) : 1,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.blueAccent,
              fontSize: 10,
            ),
            reservedSize: 22,
            getTitles: (value) {
              var item = data[value.toInt()];

              if (item is BodyWeight || item is FatPercentage) {
                var date = (data[value.toInt()]).date;
                return DateFormat('dd-MM').format(date);
              }

              return "";
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
              var x = spots[0].x;

              var item = data[x.toInt()];

              String tooltip = "";
              if (item is BodyWeight) {
                tooltip = "${item.weight.toIntString()} ${item.unit}";
              } else if (item is FatPercentage) {
                tooltip = "${item.percentage.toIntString()}%";
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

    var interval = data.length > 10 ? data.length / (data.length / 10) : 1;

    for (int i = 0; i < data.length; i += interval.toInt()) {
      double value = 0;

      if (data[i] is BodyWeight) {
        value = (data[i] as BodyWeight).weight;
      } else if (data[i] is FatPercentage) {
        value = (data[i] as FatPercentage).percentage;
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
