import 'package:fittrack/models/settings/Settings.dart';
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
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Nutrition',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // kcal, carbs, protein, fat goals
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Rest Timer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // rest timer settings like: default enabled, vibrate on finish, default time
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // clear, import/export data settings
              ],
            ),
          ),
        ],
      ),
    );
  }
}
