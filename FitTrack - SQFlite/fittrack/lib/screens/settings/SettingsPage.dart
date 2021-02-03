import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/settings/popups/data/DeleteDataPopup.dart';
import 'package:fittrack/screens/settings/popups/rest_timer/TimerIncrementValuePopup.dart';
import 'package:fittrack/screens/settings/popups/units/WeightUnitPopup.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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
                  title: Text('Import data'),
                  subtitle: Text(
                    'Imports data from a file',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    if (await Permission.storage.request().isGranted) {
                      // give warning that users will lose their current data
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        print("file picked");
                        File file = File(result.files.single.path);

                        dynamic readResult = await readFromFile(file);

                        if (readResult != null) {
                          print("file read success");
                          dynamic dbResult = await globals.sqlDatabase
                              .importDatabase(readResult.toString());

                          if (dbResult != null) {
                            print("import db success");
                            updateSettings(globals.sqlDatabase.settings);
                            // show success message
                          } else {
                            print("import db failed");
                            // show error message
                          }
                        } else {
                          print("Failed to read file");
                          // failed to read file
                        }
                      }
                    }
                  },
                ),
                ListTile(
                  title: Text('Export data'),
                  subtitle: Text(
                    'Exports data to a file',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () async {
                    if (await Permission.storage.request().isGranted) {
                      // show users the path of where their file will be saved
                      String devicePath = await getDevicePath();

                      DateFormat dateFormat = new DateFormat("d-M-y-hms");
                      String date = dateFormat.format(DateTime.now());

                      File file =
                          await getFile(devicePath, 'FitTrack-$date.db');

                      dynamic result =
                          await globals.sqlDatabase.exportDatabase();

                      if (result != null) {
                        print("db export success");
                        dynamic writeResult =
                            await writeToFile(file, result.toString());

                        if (writeResult != null) {
                          print("write success");
                          // success
                        } else {
                          print("write fail");
                          // error result write
                        }
                      } else {
                        print("db export fail");
                        // error exporting
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
                  onTap: () {
                    showPopupDeleteData(context, updateSettings);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
