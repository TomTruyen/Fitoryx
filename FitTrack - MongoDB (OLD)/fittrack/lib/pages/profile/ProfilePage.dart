// Dart Packages
import 'dart:isolate';

// Flutter Packages
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/pages/profile/widgets/WorkoutsPerWeekGraph.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/model/settings/Settings.dart';
import 'package:fittrack/pages/profile/widgets/UserInfo.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/pages/profile/widgets/WeightHistoryGraph.dart';
import 'package:fittrack/pages/settings/SettingsPage.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Refresh Profile
  static void _loadProfile(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    Settings settings = await Database(uid: _uid).getSettings() ?? Settings();
    List<WorkoutHistory> workoutHistory =
        await Database(uid: _uid).getWorkoutHistory() ?? [];

    _sendPort.send({
      'settings': settings,
      'workoutHistory': workoutHistory,
    });
  }

  Future<bool> refreshProfile() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadProfile,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      Settings _settings = data['settings'];
      List<WorkoutHistory> _workoutHistory = data['workoutHistory'];

      globals.settings = _settings;
      globals.workoutHistory = _workoutHistory;

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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: RefreshIndicator(
          displacement: 120.0,
          onRefresh: () async {
            return await refreshProfile();
          },
          child: CustomScrollView(
            slivers: <Widget>[
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
                          builder: (context) => SettingsPage(
                            updateProfileState: updateState,
                            refreshProfile: refreshProfile,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    UserInfo(),
                    Container(
                      height: 250.0,
                      child: WorkoutsPerWeekGraph(
                        updateState: updateState,
                        refreshSettings: refreshSettings,
                      ),
                    ),
                    Container(
                      height: 250.0,
                      child: WeightHistoryGraph(
                        updateState: updateState,
                        refreshSettings: refreshSettings,
                      ),
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
