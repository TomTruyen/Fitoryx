import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/pages/profile/widgets/UserInfoWidget.dart';
import 'package:fitness_app/pages/profile/widgets/WorkoutsPerWeekGraphWidget.dart';
import 'package:fitness_app/pages/profile/widgets/WeightHistoryGraphWidget.dart';
import 'package:fitness_app/pages/settings/SettingsPage.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = true;

  bool settingProgressiveOverload = false;

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<WorkoutHistory> workouts =
        Provider.of<List<WorkoutHistory>>(context) ?? [];
    User user = Provider.of<User>(context) ?? null;
    UserSettings settings = Provider.of<UserSettings>(context) ?? null;

    if (loading) {
      Future.delayed(
        Duration(seconds: 1),
        () => {
          setState(() {
            loading = false;
          }),
        },
      );
    }

    return loading
        ? Loading()
        : ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.all(16.0),
                    title: Text('Profile'),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
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
                      if (user != null && settings != null)
                        UserInfoWidget(
                          user: user,
                          workoutCount: workouts.length,
                        ),
                      if (workouts != null && settings != null && user != null)
                        Container(
                          height: 250.0,
                          child: WorkoutsPerWeekGraphWidget(
                            workouts: workouts,
                            settings: settings,
                            user: user,
                          ),
                        ),
                      if (user != null && settings != null)
                        Container(
                          height: 250.0,
                          child: WeightHistoryGraphWidget(
                            user: user,
                            settings: settings,
                          ),
                        ),
                      Container(height: 100.0, child: Text("Item 1")),
                      Container(height: 100.0, child: Text("Item 2")),
                      Container(height: 100.0, child: Text("Item 3")),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
