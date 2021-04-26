import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/AppData.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/services/Auth.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Popups
import 'package:fitness_app/pages/settings/popups/personal_info/WeightPopup.dart';
import 'package:fitness_app/pages/settings/popups/personal_info/HeightPopup.dart';
import 'package:fitness_app/pages/settings/popups/units/WeightUnitPopup.dart';
import 'package:fitness_app/pages/settings/popups/units/HeightUnitPopup.dart';
import 'package:fitness_app/pages/settings/popups/nutrition/DailyGoalPopup.dart';
import 'package:fitness_app/pages/settings/popups/rest_timer/RestTimerPopup.dart';
import 'package:fitness_app/pages/settings/popups/data/DeleteDataPopup.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int developerModeTapCount = 0;
  bool isSigningOut = false;

  bool settingProgressiveOverload = false;
  bool vibrateUponFinish = true;

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context) ?? null;
    UserSettings settings = Provider.of<UserSettings>(context) ?? null;
    AppData appData = Provider.of<AppData>(context) ?? AppData();
    List<WorkoutStreamProvider> workouts =
        Provider.of<List<WorkoutStreamProvider>>(context) ?? null;
    List<WorkoutHistory> workoutHistory =
        Provider.of<List<WorkoutHistory>>(context) ?? null;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: isSigningOut
              ? <Widget>[
                  SliverFillRemaining(
                    child: Loading(text: 'Signing out...'),
                  ),
                ]
              : <Widget>[
                  SliverAppBar(
                    forceElevated: true,
                    floating: true,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        popContextWhenPossible(context);
                      },
                    ),
                    title: Text('Settings'),
                  ),
                  SliverFillRemaining(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Personal Info',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: Text('Weight'),
                          subtitle: Text(
                            settings.weightHistory.length > 0
                                ? settings.weightUnit == 'metric'
                                    ? "${settings.weightHistory[settings.weightHistory.length - 1]['weight']} kg"
                                    : "${settings.weightHistory[settings.weightHistory.length - 1]['weight']} lbs"
                                : settings.weightUnit == 'metric'
                                    ? "0 kg"
                                    : "0 lbs",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () {
                            String currentWeight = "0";
                            if (settings.weightHistory.length > 0) {
                              currentWeight = settings.weightHistory[
                                      settings.weightHistory.length - 1]
                                      ['weight']
                                  .toString();
                            }

                            showPopupWeight(
                                user, settings, currentWeight, context);
                          },
                        ),
                        ListTile(
                          title: Text('Height'),
                          subtitle: Text(
                            settings.heightHistory.length > 0
                                ? settings.heightUnit == 'metric'
                                    ? "${settings.heightHistory[settings.heightHistory.length - 1]['height']} cm"
                                    : "${settings.heightHistory[settings.heightHistory.length - 1]['height']} ft"
                                : settings.heightUnit == 'metric'
                                    ? "0 cm"
                                    : "0 ft",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () {
                            String currentHeight = "0";
                            if (settings.heightHistory.length > 0) {
                              currentHeight = settings.heightHistory[
                                      settings.heightHistory.length - 1]
                                      ['height']
                                  .toString();
                            }

                            showPopupHeight(
                              user,
                              settings,
                              currentHeight,
                              context,
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        ListTile(
                          title: Text(
                            'Units',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Weight Unit'),
                          subtitle: Text(
                            settings != null
                                ? settings.weightUnit == 'metric'
                                    ? 'Metric (kg)'
                                    : 'Imperial (lbs)'
                                : 'Metric (kg)',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () {
                            showPopupWeightUnit(user, settings, context,
                                workouts, workoutHistory);
                          },
                        ),
                        ListTile(
                          title: Text('Height Unit'),
                          subtitle: Text(
                            settings != null
                                ? settings.heightUnit == 'metric'
                                    ? 'Metric (cm)'
                                    : 'Imperial (ft)'
                                : 'Metric (cm)',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () {
                            showPopupHeightUnit(user, settings, context);
                          },
                        ),
                        Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        ListTile(
                          title: Text(
                            'Nutrition',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Daily goal'),
                          subtitle: Text(
                            'Daily nutritional goal (kcal & macro\'s)',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () {
                            showPopupNutritionGoals(
                              user,
                              settings,
                              context,
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        ListTile(
                          title: Text(
                            'Rest Timer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Timer increment value'),
                          subtitle: Text(
                            settings != null
                                ? '${settings.timerIncrementValue}s'
                                : '30s',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () {
                            showPopupTimerIncrementValue(
                              user,
                              settings,
                              context,
                            );
                          },
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: ListTile(
                                  title: Text(
                                    'Vibrate upon finish',
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Switch(
                                  onChanged: (bool value) async {
                                    setState(() {
                                      vibrateUponFinish = value;
                                    });

                                    settings.vibrateUponFinish = value;

                                    dynamic result = await DatabaseService(
                                      uid: user != null ? user.uid : '',
                                    ).updateSettings(settings);

                                    if (result == null) {
                                      // DISPLAY ERROR
                                    }
                                  },
                                  value: settings != null
                                      ? settings.vibrateUponFinish
                                      : false,
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            setState(() {
                              vibrateUponFinish = !vibrateUponFinish;
                            });

                            settings.vibrateUponFinish =
                                !settings.vibrateUponFinish;

                            dynamic result = await DatabaseService(
                              uid: user != null ? user.uid : '',
                            ).updateSettings(settings);

                            if (result == null) {
                              // DISPLAY ERROR
                            }
                          },
                        ),
                        if (settings != null && settings.developerMode)
                          Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        if (settings != null && settings.developerMode)
                          ListTile(
                            title: Text(
                              'Experimental',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (settings != null && settings.developerMode)
                          InkWell(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: ListTile(
                                    title: Text(
                                      'Generate progressive overload',
                                    ),
                                    subtitle: Text(
                                      'Auto generate workout with progressive overload',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Switch(
                                    onChanged: (bool value) async {
                                      setState(() {
                                        settingProgressiveOverload = value;
                                      });

                                      settings.progressiveOverload = value;

                                      dynamic result = await DatabaseService(
                                        uid: user != null ? user.uid : '',
                                      ).updateSettings(settings);

                                      if (result == null) {
                                        // DISPLAY ERROR
                                      }
                                    },
                                    value: settings != null
                                        ? settings.progressiveOverload
                                        : false,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              setState(() {
                                settingProgressiveOverload =
                                    !settingProgressiveOverload;
                              });

                              settings.progressiveOverload =
                                  !settings.progressiveOverload;

                              dynamic result = await DatabaseService(
                                uid: user != null ? user.uid : '',
                              ).updateSettings(settings);

                              if (result == null) {
                                // DISPLAY ERROR
                              }
                            },
                          ),
                        Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        ListTile(
                          title: Text(
                            'Data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Delete all data'),
                          onTap: () {
                            showPopupDeleteData(
                              user,
                              context,
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        ListTile(
                          title: Text(
                            'Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              padding: EdgeInsets.all(14.0),
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isSigningOut = true;
                              });

                              dynamic result = await Future.delayed(
                                Duration(seconds: 1),
                                () {
                                  return AuthService().signOut();
                                },
                              );

                              if (result != null) {
                                setState(() {
                                  isSigningOut = false;
                                });
                              }
                            },
                          ),
                        ),
                        if (appData != null)
                          Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                        if (appData != null)
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "Build version: ${appData.version}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            onTap: () async {
                              developerModeTapCount++;

                              if (developerModeTapCount == 7) {
                                if (user != null) {
                                  settings.developerMode =
                                      !settings.developerMode;

                                  dynamic result =
                                      await DatabaseService(uid: user.uid)
                                          .updateSettings(settings);

                                  if (result != null) {
                                    final snackBar = SnackBar(
                                      duration: Duration(seconds: 1),
                                      elevation: 8.0,
                                      backgroundColor: settings.developerMode
                                          ? Colors.green[400]
                                          : Colors.red[400],
                                      content: Text(
                                        settings.developerMode
                                            ? 'Developer mode enabled'
                                            : 'Developer mode disabled',
                                        textAlign: TextAlign.center,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }

                                developerModeTapCount = 0;
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
