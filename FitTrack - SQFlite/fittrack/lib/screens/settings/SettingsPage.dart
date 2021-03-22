import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/settings/SettingsProfilePage.dart';
import 'package:fittrack/screens/settings/popups/data/AutoExportDataPopup.dart';
import 'package:fittrack/screens/settings/popups/data/DeleteDataPopup.dart';
import 'package:fittrack/screens/settings/popups/data/ExportDataPopup.dart';
import 'package:fittrack/screens/settings/popups/data/ImportDataPopup.dart';
import 'package:fittrack/screens/settings/popups/food/NutritionGoalsPopup.dart';
import 'package:fittrack/screens/settings/popups/rest_timer/DefaultRestTimePopup.dart';
import 'package:fittrack/screens/settings/popups/units/HeightUnitPopup.dart';
import 'package:fittrack/screens/settings/popups/units/WeightUnitPopup.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final Function updateProfilePage;

  SettingsPage({this.updateProfilePage});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings;
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();

    settings = globals.sqlDatabase.settings;

    getPackageInfo();
  }

  Future<void> getPackageInfo() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      packageInfo = _packageInfo;
    });
  }

  void updateSettings(Settings _settings) {
    globals.sqlDatabase.settings = _settings;

    setState(() {
      settings = _settings;
    });

    widget.updateProfilePage();
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
                await globals.sqlDatabase.fetchSettings();

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
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Edit Profile'),
                  subtitle: Text(
                    'Edit your weight, height, body fat,...',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => SettingsProfilePage(
                          updateSettings: updateSettings,
                          settings: settings,
                        ),
                      ),
                    );
                  },
                ),
                Divider(color: Color.fromRGBO(70, 70, 70, 1)),
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
                  onTap: () async {
                    await showPopupWeightUnit(
                      context,
                      settings,
                      updateSettings,
                    );
                  },
                ),
                ListTile(
                  title: Text('Height Unit'),
                  subtitle: Text(
                    settings.heightUnit == 'cm'
                        ? 'Metric (cm)'
                        : 'Imperial (ft)',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    await showPopupHeightUnit(
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
                ListTile(
                  title: Text('Nutrition Goals'),
                  subtitle: Text(
                    'Set your nutrition goals',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    await showPopupNutritionGoals(
                      context,
                      updateSettings,
                      settings,
                    );
                  },
                ),
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
                  title: Text('Default rest time'),
                  subtitle: Text(
                    settings.defaultRestTime > 60
                        ? "${settings.defaultRestTime ~/ 60}m ${(settings.defaultRestTime % 60).toString().padLeft(2, '0')}s"
                        : "${settings.defaultRestTime}s",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    await showPopupDefaultRestTime(
                      context,
                      updateSettings,
                      settings,
                    );
                  },
                ),
                SwitchListTile(
                  activeColor: Colors.blueAccent[700],
                  title: Text('Rest timer enabled'),
                  value: settings.isRestTimerEnabled == 1,
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
                  activeColor: Colors.blueAccent[700],
                  title: Text('Vibrate upon finish'),
                  value: settings.isVibrateUponFinishEnabled == 1,
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
                  title: Text('Import data'),
                  subtitle: Text(
                    'Imports data from a file',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    await showPopupImportData(
                      context,
                      updateSettings,
                    );
                  },
                ),
                ListTile(
                  title: Text('Export data'),
                  subtitle: Text(
                    'Exports data to a file',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    DateFormat dateFormat = new DateFormat("d-M-y-hms");
                    String date = dateFormat.format(DateTime.now());

                    String fileName = 'FitTrack-$date.db';

                    await showPopupExportData(
                      context,
                      fileName,
                      updateSettings,
                    );
                  },
                ),
                SwitchListTile(
                  activeColor: Colors.blueAccent[700],
                  title: Text('Auto export data'),
                  subtitle: Text(
                    'Automatically exports data to a file',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  value: settings.isAutoExportEnabled == 1,
                  onChanged: (bool value) async {
                    bool isConfirmed = false;

                    if (settings.isAutoExportEnabled == 0 && value == true) {
                      isConfirmed = await showPopupAutoExportData(
                        context,
                        updateSettings,
                      );
                    }

                    if (isConfirmed) {
                      Settings newSettings = settings.clone();
                      newSettings.isAutoExportEnabled = 1;

                      dynamic result = await globals.sqlDatabase.updateSettings(
                        newSettings,
                      );

                      if (result != null) {
                        updateSettings(newSettings);
                      }
                    } else {
                      Settings newSettings = settings.clone();
                      newSettings.isAutoExportEnabled = 0;

                      dynamic result = await globals.sqlDatabase.updateSettings(
                        newSettings,
                      );

                      if (result != null) {
                        updateSettings(newSettings);
                      }
                    }
                  },
                ),
                ListTile(
                  title: Text('Delete data'),
                  subtitle: Text(
                    'Deletes all your data',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    await showPopupDeleteData(context, updateSettings);
                  },
                ),
                Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Contact and support',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Report bug'),
                  subtitle: Text(
                    'Found a bug? Send us the details',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    if (packageInfo == null) {
                      packageInfo = await PackageInfo.fromPlatform();
                    }

                    final String toMail = "tom.truyen@gmail.com";
                    final String subject =
                        "Bug Report Version:${packageInfo.version} - Build:${packageInfo.buildNumber}";

                    String body =
                        "Please write your bug above this line and don't remove anything below this line\n\n";

                    if (packageInfo.packageName
                            .toLowerCase()
                            .contains('premium') ||
                        packageInfo.appName.toLowerCase().contains('premium')) {
                      body += "Premium User\n\n";
                    } else {
                      body += "Free User\n\n";
                    }

                    body += "Deviceinfo:\n";

                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                    if (Platform.isAndroid) {
                      AndroidDeviceInfo androidDeviceInfo =
                          await deviceInfo.androidInfo;
                      body +=
                          convertAndroidDeviceInfoToString(androidDeviceInfo);
                    } else if (Platform.isIOS) {
                      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
                      body += convertIosDeviceInfoToString(iosDeviceInfo);
                    }

                    final url = 'mailto:$toMail?subject=$subject&body=$body';

                    if (await canLaunch(url)) {
                      launch(url);
                    }
                  },
                ),
                if (packageInfo != null)
                  Divider(color: Color.fromRGBO(70, 70, 70, 1)),
                if (packageInfo != null)
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Version: ${packageInfo.version} - Build: ${packageInfo.buildNumber}",
                      style: Theme.of(context).textTheme.caption,
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
