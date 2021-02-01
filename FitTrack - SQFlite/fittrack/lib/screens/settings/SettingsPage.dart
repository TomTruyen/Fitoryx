import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/settings/popups/data/DeleteDataPopup.dart';
import 'package:fittrack/screens/settings/popups/rest_timer/TimerIncrementValuePopup.dart';
import 'package:fittrack/screens/settings/popups/units/WeightUnitPopup.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings;

  @override
  void initState() {
    super.initState();

    settings = globals.sqlDatabase.settings;
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
              'Settings',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () async {
                await globals.sqlDatabase.getSettings();

                tryPopContext(context);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Units',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Weight Unit'),
                  subtitle: Text(
                    settings.weightUnit == 'kg'
                        ? 'Metric (kg)'
                        : 'Imperial (lbs)',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    showPopupWeightUnit(
                      context,
                      settings,
                      updateSettings,
                    );
                  },
                ),
                Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Nutrition',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // kcal, carbs, protein, fat goals
                Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Rest Timer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Timer increment value'),
                  subtitle: Text(
                    "${settings.timerIncrementValue}s",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    showPopupTimerIncrementValue(
                      context,
                      updateSettings,
                      settings,
                    );
                  },
                ),
                SwitchListTile(
                  title: Text('Rest timer enabled'),
                  value: settings.isRestTimerEnabled == 1 ? true : false,
                  onChanged: (bool value) async {
                    Settings newSettings = settings.clone();
                    newSettings.isRestTimerEnabled =
                        newSettings.isRestTimerEnabled == 1 ? 0 : 1;

                    dynamic result =
                        await globals.sqlDatabase.updateSettings(newSettings);

                    if (result != null) {
                      updateSettings(newSettings);
                    }
                  },
                ),
                SwitchListTile(
                  title: Text('Vibrate upon finish'),
                  value:
                      settings.isVibrateUponFinishEnabled == 1 ? true : false,
                  onChanged: (bool value) async {
                    Settings newSettings = settings.clone();
                    newSettings.isVibrateUponFinishEnabled =
                        newSettings.isVibrateUponFinishEnabled == 1 ? 0 : 1;

                    dynamic result =
                        await globals.sqlDatabase.updateSettings(newSettings);

                    if (result != null) {
                      updateSettings(newSettings);
                    }
                  },
                ),
                Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Delete data'),
                  subtitle: Text(
                    'Deletes all your data',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    showPopupDeleteData(context, updateSettings);
                  },
                ),
                // import/export data settings
              ],
            ),
          ),
        ],
      ),
    );
  }
}
