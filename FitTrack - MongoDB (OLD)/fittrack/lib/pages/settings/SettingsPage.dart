// Dart Packages
import 'dart:isolate';

// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/main.dart';
import 'package:fittrack/model/settings/Settings.dart';
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/services/Auth.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/shared/Snackbars.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

// Popups
import 'package:fittrack/pages/settings/popups/personal_info/WeightPopup.dart';
import 'package:fittrack/pages/settings/popups/personal_info/HeightPopup.dart';
import 'package:fittrack/pages/settings/popups/units/WeightUnitPopup.dart';
import 'package:fittrack/pages/settings/popups/units/HeightUnitPopup.dart';
import 'package:fittrack/pages/settings/popups/nutrition/NutritionGoalsPopup.dart';
import 'package:fittrack/pages/settings/popups/rest_timer/RestTimerPopup.dart';
import 'package:fittrack/pages/settings/popups/data/DeleteDataPopup.dart';

class SettingsPage extends StatefulWidget {
  final Function updateProfileState;
  final Function refreshProfile;

  SettingsPage({this.updateProfileState, this.refreshProfile});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool progressiveOverload =
      globals.settings.isProgressiveOverloadEnabled ?? false;
  bool restTimerEnabled = globals.settings.isRestTimerEnabled ?? true;
  bool vibrateUponFinish = globals.settings.isVibrateUponFinishEnabled ?? true;
  bool isSigningOut = false;
  bool isClosingPage = false;

  void updateIsSigningOut(bool value) {
    setState(() {
      isSigningOut = value;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // Refresh Settings
  static void _loadSettings(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    Settings settings = await Database(uid: _uid).getSettings() ?? Settings();

    _sendPort.send(settings);
  }

  Future<bool> refreshSettings() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadSettings,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      Settings _settings = data;

      globals.settings = _settings;

      receivePort.close();
      isolate.kill();
      isolate = null;
    });

    bool isCompleted = false;

    await Future.doWhile(() async {
      return await Future.delayed(Duration(milliseconds: 500), () {
        return isolate != null;
      });
    });

    setState(() {});

    return isCompleted;
  }

  // Refresh Nutrition (on Daily goal change)
  Future<bool> refreshNutrition() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadNutrition,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<Nutrition> _nutritionHistory = data;

      globals.nutritionHistory = _nutritionHistory;

      receivePort.close();
      isolate.kill();
      isolate = null;
    });

    bool isCompleted = false;

    await Future.doWhile(() async {
      return await Future.delayed(Duration(milliseconds: 500), () {
        return isolate != null;
      });
    });

    return isCompleted;
  }

  static void _loadNutrition(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<Nutrition> nutritionHistory =
        await Database(uid: _uid).getNutritionHistory() ?? [];

    _sendPort.send(nutritionHistory);
  }

  void updateVibrateUponFinish(bool value) {
    setState(() {
      vibrateUponFinish = value;
    });
  }

  void updateProgressiveOverload(bool value) {
    setState(() {
      progressiveOverload = value;
    });
  }

  void updateRestTimerEnabled(bool value) {
    setState(() {
      restTimerEnabled = value;
    });
  }

  void updateSettingsState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsPageView(this);
  }
}

class _SettingsPageView extends StatelessWidget {
  final _SettingsPageState state;

  _SettingsPageView(this.state);

  @override
  Widget build(BuildContext context) {
    int _developerModeTapCount = 0;

    final bool _isSigningOut = state.isSigningOut;

    final Function _updateIsSigningOut = state.updateIsSigningOut;
    final Function _refreshSettings = state.refreshSettings;
    final Function _refreshNutrition = state.refreshNutrition;
    final Function _refreshProfile = state.widget.refreshProfile;
    final Function _updateVibrateUponFinish = state.updateVibrateUponFinish;
    final Function _updateProgressiveOverload = state.updateProgressiveOverload;
    final Function _updateRestTimerEnabled = state.updateRestTimerEnabled;
    final Function _updateSettingsState = state.updateSettingsState;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: _isSigningOut
            ? LoaderWithMessage(text: 'Signing out...')
            : RefreshIndicator(
                displacement: 120.0,
                onRefresh: () async {
                  return await _refreshSettings();
                },
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      forceElevated: true,
                      floating: true,
                      pinned: true,
                      leading: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () async {
                          if (!state.isClosingPage) {
                            state.isClosingPage = true;

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context)
                                .showSnackBar(savingSnackbar);

                            bool isSaved = await Database(uid: globals.uid)
                                .updateSettings(globals.settings);

                            if (isSaved) {
                              await _refreshSettings();
                              await _refreshProfile();
                              await _refreshNutrition();

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(saveSuccessSnackbar);

                              Future.delayed(Duration(seconds: 1), () {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                popContextWhenPossible(context);
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(saveFailSnackbar);

                              state.isClosingPage = false;
                            }
                          }
                        },
                      ),
                      title: Text('Settings'),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(height: 10.0),
                          ListTile(
                            title: Text(
                              'Personal Info',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: Text('Weight'),
                            subtitle: Text(
                              globals.settings.weightHistory.length > 0
                                  ? "${globals.settings.weightHistory[globals.settings.weightHistory.length - 1]['weight']} ${globals.settings.weightUnit}"
                                  : "0 ${globals.settings.weightUnit}",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            onTap: () {
                              showPopupWeight(
                                context,
                                _refreshSettings,
                                state.widget.updateProfileState,
                                _updateSettingsState,
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Height'),
                            subtitle: Text(
                              globals.settings.heightHistory.length > 0
                                  ? "${globals.settings.heightHistory[globals.settings.heightHistory.length - 1]['height']} ${globals.settings.heightUnit}"
                                  : "0 ${globals.settings.heightUnit}",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            onTap: () {
                              showPopupHeight(
                                context,
                                _refreshSettings,
                                _updateSettingsState,
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
                              globals.settings.weightUnit == 'kg'
                                  ? 'Metric (kg)'
                                  : 'Imperial (lbs)',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            onTap: () {
                              showPopupWeightUnit(
                                context,
                                _refreshSettings,
                                _updateSettingsState,
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Height Unit'),
                            subtitle: Text(
                              globals.settings.heightUnit == 'cm'
                                  ? 'Metric (cm)'
                                  : 'Imperial (ft)',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            onTap: () {
                              showPopupHeightUnit(
                                context,
                                _refreshSettings,
                                _updateSettingsState,
                              );
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
                                context,
                                _refreshSettings,
                                _refreshNutrition,
                                _updateSettingsState,
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
                              "${globals.settings.timerIncrementValue}s",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            onTap: () {
                              showPopupTimerIncrementValue(
                                context,
                                _refreshSettings,
                                _updateSettingsState,
                              );
                            },
                          ),
                          SwitchListTile(
                            title: Text('Rest timer enabled'),
                            value: state.restTimerEnabled,
                            onChanged: (bool value) async {
                              _updateRestTimerEnabled(value);

                              globals.settings.isRestTimerEnabled = value;
                            },
                          ),
                          SwitchListTile(
                            title: Text('Vibrate upon finish'),
                            value: state.vibrateUponFinish,
                            onChanged: (bool value) async {
                              _updateVibrateUponFinish(value);

                              globals.settings.isVibrateUponFinishEnabled =
                                  value;
                            },
                          ),
                          if (globals.settings.isDeveloperModeEnabled)
                            Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                          if (globals.settings.isDeveloperModeEnabled)
                            ListTile(
                              title: Text(
                                'Experimental',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (globals.settings.isDeveloperModeEnabled)
                            SwitchListTile(
                              title: Text('Generate progressive overload'),
                              subtitle: Text(
                                'Auto generate workout with progressive overload',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              value: state.progressiveOverload,
                              onChanged: (bool value) async {
                                _updateProgressiveOverload(value);

                                globals.settings.isProgressiveOverloadEnabled =
                                    value;
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
                                context,
                                _refreshSettings,
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
                                _updateIsSigningOut(true);

                                dynamic isSignedOut = await Auth().signOut();
                                if (isSignedOut) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => Main(),
                                    ),
                                  );
                                } else {
                                  _updateIsSigningOut(false);
                                }
                              },
                            ),
                          ),
                          Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "Build version: ${globals.appdata.version}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            onTap: () async {
                              _developerModeTapCount++;

                              if (_developerModeTapCount == 7) {
                                _developerModeTapCount = 0;

                                globals.settings.isDeveloperModeEnabled =
                                    !globals.settings.isDeveloperModeEnabled;

                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                if (globals.settings.isDeveloperModeEnabled) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(enablingDevModeSnackbar);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(disablingDevModeSnackbar);
                                }

                                bool isUpdated =
                                    await Database(uid: globals.uid)
                                        .updateSettings(globals.settings);

                                if (isUpdated) {
                                  await _refreshSettings();

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  if (globals.settings.isDeveloperModeEnabled) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        enablingDevModeSuccessSnackbar);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        disablingDevModeSuccessSnackbar);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
