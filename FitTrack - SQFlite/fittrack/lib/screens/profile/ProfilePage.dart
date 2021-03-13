import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/screens/profile/graphs/BodyFatChart.dart';
import 'package:fittrack/screens/profile/graphs/NutritionChart.dart';
import 'package:fittrack/screens/profile/graphs/TotalVolumeChart.dart';
import 'package:fittrack/screens/profile/graphs/UserWeightChart.dart';
import 'package:fittrack/screens/profile/graphs/WorkoutsPerWeekChart.dart';
import 'package:fittrack/screens/profile/popups/TimespanPopup.dart';
import 'package:fittrack/screens/profile/popups/ToggleGraphsPopup.dart';
import 'package:fittrack/screens/profile/popups/WorkoutsPerWeekPopup.dart';
import 'package:fittrack/screens/settings/SettingsPage.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Settings settings;
  List<Workout> workoutHistory;
  List<Food> food;

  int weightTimespan = 30; // timespan of weightgraph (in days)
  int bodyFatTimespan = 30; // timespan of volumegraph (in days)
  int volumeTimespan = 30; // timespan of volumegraph (in days)
  int nutritionTimespan = 30; // timespan of volumegraph (in days)

  @override
  void initState() {
    super.initState();

    updateProfilePage();
  }

  String _getTimespanString(timespan) {
    switch (timespan) {
      case 7:
        return "1 Week";
      case 30:
        return "1 Month";
      case 365:
        return "1 Year";
      default:
        return "All";
    }
  }

  void updateProfilePage() {
    setState(() {
      workoutHistory = globals.sqlDatabase.workoutsHistory ?? [];
      food = globals.sqlDatabase.food ?? [];
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
              globals.getDonationButton(context),
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
                      builder: (context) => SettingsPage(
                        updateProfilePage: updateProfilePage,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  primary: Theme.of(context).textTheme.bodyText2.color,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.remove_red_eye),
                    SizedBox(width: 5.0),
                    Text('Toggle graphs'),
                  ],
                ),
                onPressed: () async {
                  await showPopupToggleGraphs(
                    context,
                    settings,
                    updateSettings,
                  );
                },
              ),
            ),
          ),
          if (settings.shouldShowNoGraphs())
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No graphs to show'),
              ),
            ),
          if (!settings.shouldShowNoGraphs())
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (settings.shouldShowGraph('workoutsPerWeekGraph'))
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Workouts per week',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        cardColor:
                                            Color.fromRGBO(35, 35, 35, 1),
                                        dividerColor:
                                            Color.fromRGBO(150, 150, 150, 1),
                                      ),
                                      child: PopupMenuButton(
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: WorkoutsPerWeekChart(
                                  workoutHistory: List.of(workoutHistory) ?? [],
                                  settings: settings,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (settings.shouldShowGraph('userWeightGraph'))
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Weight (${_getTimespanString(weightTimespan)})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        cardColor:
                                            Color.fromRGBO(35, 35, 35, 1),
                                        dividerColor: Color.fromRGBO(
                                          150,
                                          150,
                                          150,
                                          1,
                                        ),
                                      ),
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.more_vert,
                                        ),
                                        onSelected: (selection) async {
                                          if (selection == 'timespan') {
                                            int _timespan =
                                                await showPopupTimespan(
                                              context,
                                              weightTimespan,
                                            );

                                            setState(() {
                                              weightTimespan = _timespan;
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'timespan',
                                            child: Text(
                                              'Edit timespan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: UserWeightChart(
                                  userWeights:
                                      List.of(settings.userWeight) ?? [],
                                  settings: settings,
                                  timespan: weightTimespan,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (settings.shouldShowGraph('bodyFatGraph'))
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Body Fat (${_getTimespanString(bodyFatTimespan)})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        cardColor:
                                            Color.fromRGBO(35, 35, 35, 1),
                                        dividerColor: Color.fromRGBO(
                                          150,
                                          150,
                                          150,
                                          1,
                                        ),
                                      ),
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.more_vert,
                                        ),
                                        onSelected: (selection) async {
                                          if (selection == 'timespan') {
                                            int _timespan =
                                                await showPopupTimespan(
                                              context,
                                              bodyFatTimespan,
                                            );

                                            setState(() {
                                              bodyFatTimespan = _timespan;
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'timespan',
                                            child: Text(
                                              'Edit timespan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: BodyFatChart(
                                  bodyFat: List.of(settings.bodyFat) ?? [],
                                  settings: settings,
                                  timespan: nutritionTimespan,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (settings.shouldShowGraph('totalVolumeGraph'))
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Total volume (${_getTimespanString(volumeTimespan)})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        cardColor:
                                            Color.fromRGBO(35, 35, 35, 1),
                                        dividerColor: Color.fromRGBO(
                                          150,
                                          150,
                                          150,
                                          1,
                                        ),
                                      ),
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.more_vert,
                                        ),
                                        onSelected: (selection) async {
                                          if (selection == 'timespan') {
                                            int _timespan =
                                                await showPopupTimespan(
                                              context,
                                              volumeTimespan,
                                            );

                                            setState(() {
                                              volumeTimespan = _timespan;
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'timespan',
                                            child: Text(
                                              'Edit timespan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: TotalVolumeChart(
                                  workoutHistory: List.of(workoutHistory) ?? [],
                                  settings: settings,
                                  timespan: volumeTimespan,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (settings.shouldShowGraph('caloriesGraph'))
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Calories (${_getTimespanString(nutritionTimespan)})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        cardColor:
                                            Color.fromRGBO(35, 35, 35, 1),
                                        dividerColor: Color.fromRGBO(
                                          150,
                                          150,
                                          150,
                                          1,
                                        ),
                                      ),
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.more_vert,
                                        ),
                                        onSelected: (selection) async {
                                          if (selection == 'timespan') {
                                            int _timespan =
                                                await showPopupTimespan(
                                              context,
                                              nutritionTimespan,
                                            );

                                            setState(() {
                                              nutritionTimespan = _timespan;
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'timespan',
                                            child: Text(
                                              'Edit timespan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: NutritionChart(
                                  food: List.of(food) ?? [],
                                  settings: settings,
                                  timespan: nutritionTimespan,
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
