// Dart Packages
import 'dart:isolate';
import 'dart:math';

// Flutter Packages
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:intl/intl.dart';

// My Packages
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/pages/history/HistoryViewPage.dart';
import 'package:fittrack/pages/history/HistoryCalendarPage.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/misc/history/WorkoutHistoryPageFunctions.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int lastMonth;
  int lastYear;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<bool> refreshWorkoutHistory() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadWorkoutHistory,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<WorkoutHistory> _workoutHistory = data;

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

  static void _loadWorkoutHistory(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<WorkoutHistory> workouts =
        await Database(uid: _uid).getWorkoutHistory() ?? [];

    _sendPort.send(workouts);
  }

  @override
  Widget build(BuildContext context) {
    return _HistoryPageView(this);
  }
}

class _HistoryPageView extends StatelessWidget {
  final _HistoryPageState state;

  _HistoryPageView(this.state);

  @override
  Widget build(BuildContext context) {
    int _lastMonth = state.lastMonth;
    int _lastYear = state.lastYear;
    List<WorkoutHistory> _workoutHistory = globals.workoutHistory;

    final Function _refreshWorkoutHistory = state.refreshWorkoutHistory;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: RefreshIndicator(
          displacement: 120.0,
          onRefresh: () async {
            return await _refreshWorkoutHistory();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(16.0),
                  title: Text('History'),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.event),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HistoryCalendarPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              _workoutHistory.length > 0
                  ? SliverList(
                      delegate: (SliverChildBuilderDelegate(
                        (context, index) {
                          int count = 0;
                          bool dateDivider = false;

                          if (_lastMonth != null && _lastYear != null) {
                            int currentMonth =
                                _workoutHistory[index].workoutTime.month;
                            int currentYear =
                                _workoutHistory[index].workoutTime.year;
                            if (currentMonth != _lastMonth ||
                                currentYear != _lastYear) {
                              dateDivider = true;
                              _lastMonth = currentMonth;
                              _lastYear = currentYear;
                            }
                          } else {
                            dateDivider = true;
                            _lastMonth =
                                _workoutHistory[index].workoutTime.month;
                            _lastYear = _workoutHistory[index].workoutTime.year;
                          }

                          if (dateDivider) {
                            // Get count of exercises from this month
                            for (int i = 0; i < _workoutHistory.length; i++) {
                              if (_workoutHistory[i].workoutTime.month ==
                                      _workoutHistory[index]
                                          .workoutTime
                                          .month &&
                                  _workoutHistory[i].workoutTime.year ==
                                      _workoutHistory[index].workoutTime.year) {
                                count++;
                              }
                            }
                          }

                          return _WorkoutHistoryTile(
                              workoutHistory: _workoutHistory[index],
                              dateDivider: dateDivider,
                              workoutCount: count,
                              refreshWorkoutHistory: _refreshWorkoutHistory);
                        },
                        childCount: _workoutHistory.length,
                      )),
                    )
                  : SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No workouts performed. \nPress the \'+\' icon to start a workout',
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutHistoryTile extends StatelessWidget {
  final WorkoutHistory workoutHistory;
  final bool dateDivider;
  final int workoutCount;
  final Function refreshWorkoutHistory;

  _WorkoutHistoryTile({
    this.workoutHistory,
    this.dateDivider = false,
    this.workoutCount = 0,
    this.refreshWorkoutHistory,
  });

  @override
  Widget build(BuildContext context) {
    final String weightUnit = globals.settings.weightUnit;

    return Column(
      children: <Widget>[
        if (dateDivider)
          if (dateDivider)
            Container(
              padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat("MMMM yyyy")
                          .format(workoutHistory.workoutTime)
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Text(
                    '$workoutCount workouts',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HistoryViewPage(
                    history: workoutHistory,
                    refreshWorkoutHistory: refreshWorkoutHistory,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      workoutHistory.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat("d MMMM").format(workoutHistory.workoutTime),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.watch_later, size: 16.0),
                              SizedBox(width: 5.0),
                              Text(
                                workoutHistory.workoutDuration,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30.0),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Transform.rotate(
                                angle: -pi / 4,
                                child: Icon(
                                  Icons.fitness_center,
                                  size: 16.0,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                getTotalWeightLifted(
                                      workoutHistory.exercises,
                                      workoutHistory.weightUnit,
                                      weightUnit,
                                    ) +
                                    weightUnit,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Exercise',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  for (int i = 0; i < workoutHistory.exercises.length; i++)
                    Row(
                      children: <Widget>[
                        Text(workoutHistory.exercises[i].sets.length.toString(),
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(width: 5.0),
                        Text('x', style: Theme.of(context).textTheme.caption),
                        SizedBox(width: 5.0),
                        Text(workoutHistory.exercises[i].name,
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
