import 'package:fittrack/screens/settings/SettingsPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          // Allow users to set their current weight, height, age, gender etc.... Either through settings of through profile page somewhere
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // https://pub.dev/packages/fl_chart --> Docs lezen
                // https://www.youtube.com/watch?v=LB7B3zudivI --> Tutorial video voor linechart


                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   margin: EdgeInsets.symmetric(
                //     horizontal: 8.0,
                //     vertical: 4.0,
                //   ),
                //   child: LineChart(
                //     LineChartData(

                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
