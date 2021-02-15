import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/screens/profile/graphs/WorkoutsPerWeekChart.dart';
import 'package:fittrack/screens/profile/popups/WorkoutsPerWeekPopup.dart';
import 'package:fittrack/screens/settings/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Settings settings;
  List<Workout> workoutHistory;

  @override
  void initState() {
    super.initState();

    setState(() {
      workoutHistory = globals.sqlDatabase.workoutsHistory ?? [];
      settings = globals.sqlDatabase.settings ?? Settings();
    });
  }

  void updateSettings(Settings _settings) {
    globals.sqlDatabase.settings = _settings;

    setState(() {
      settings = _settings;
    });
  }

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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // https://pub.dev/packages/fl_chart --> Docs lezen
                // https://www.youtube.com/watch?v=LB7B3zudivI --> Tutorial video voor linechart

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3.0,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Workouts per week',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: Color.fromRGBO(35, 35, 35, 1),
                                    dividerColor:
                                        Color.fromRGBO(150, 150, 150, 1),
                                  ),
                                  child: PopupMenuButton(
                                    offset: Offset(0, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.more_vert,
                                    ),
                                    onSelected: (selection) async {
                                      if (selection == 'edit') {
                                        showWorkoutsPerWeekPopup(
                                          context,
                                          settings,
                                          updateSettings,
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      PopupMenuItem(
                                        height: 40.0,
                                        value: 'edit',
                                        child: Text(
                                          'Edit goal',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(top: 16.0),
                            child: WorkoutsPerWeekChart(
                              workoutHistory: workoutHistory,
                              settings: settings,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
