import 'package:fitoryx/screens/subscription/subscription_page.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceholderGraph extends StatelessWidget {
  const PlaceholderGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.6,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.blue[50]!, width: 1),
                ),
              ),
              minY: 0.toDouble(),
              lineBarsData: _getLineBars(),
              showingTooltipIndicators: [],
              lineTouchData: LineTouchData(
                enabled: false,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GradientButton(
              text: "⭐ Unlock Fitoryx Pro",
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const SubscriptionPage(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<LineChartBarData> _getLineBars() {
    List<FlSpot> spots = [
      const FlSpot(0, 100),
      const FlSpot(1, 75),
      const FlSpot(2, 85),
      const FlSpot(3, 70),
      const FlSpot(4, 100),
      const FlSpot(5, 90),
      const FlSpot(6, 75),
      const FlSpot(7, 85),
      const FlSpot(8, 70),
      const FlSpot(9, 100),
      const FlSpot(10, 90),
      const FlSpot(11, 75),
      const FlSpot(12, 85),
      const FlSpot(13, 70),
      const FlSpot(14, 100),
      const FlSpot(15, 90),
      const FlSpot(16, 75),
      const FlSpot(17, 85),
      const FlSpot(18, 70),
      const FlSpot(19, 100),
      const FlSpot(20, 90),
    ];

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
