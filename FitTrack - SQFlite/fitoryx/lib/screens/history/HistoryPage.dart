import 'dart:math';

import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:Fitoryx/screens/history/HistoryCalendarPage.dart';
import 'package:Fitoryx/screens/history/HistoryViewPage.dart';
import 'package:Fitoryx/shared/ExerciseWidget.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:Fitoryx/shared/GradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final Function changePage;

  HistoryPage({this.changePage});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Workout> workoutsHistory =
      List.of(globals.sqlDatabase.workoutsHistory) ?? [];
  bool sortAscending = false;

  int currentMonth;
  int currentYear;

  Future<void> updateWorkoutsHistory() async {
    await globals.sqlDatabase.fetchWorkoutsHistory();

    workoutsHistory = globals.sqlDatabase.workoutsHistory;

    sortWorkoutsHistory(workoutsHistory, sortAscending);
  }

  void sortWorkoutsHistory(
    List<Workout> _workoutsHistory,
    bool orderAscending,
  ) {
    List<Workout> sortedWorkoutHistory = sortByDate(
      _workoutsHistory,
      orderAscending,
    ).cast<Workout>();

    setState(() {
      sortAscending = orderAscending;
      workoutsHistory = sortedWorkoutHistory;
      currentMonth = null;
      currentYear = null;
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
              'History',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              globals.getDonationButton(context),
              IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => HistoryCalendarPage(
                        workoutsHistory: workoutsHistory,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (workoutsHistory.length <= 0)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("No workouts performed."),
                    SizedBox(height: 10.0),
                    Container(
                      height: 40.0,
                      width: 150.0,
                      child: GradientButton(
                        text: 'Start now',
                        onPressed: () {
                          widget.changePage(globals.PageEnum.workout.index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (workoutsHistory.length > 0)
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
                      Transform(
                        alignment: Alignment.center,
                        transform: sortAscending
                            ? Matrix4.rotationX(pi)
                            : Matrix4.rotationX(0),
                        child: Icon(
                          Icons.sort,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text('Sort by date'),
                    ],
                  ),
                  onPressed: () {
                    sortWorkoutsHistory(workoutsHistory, !sortAscending);
                  },
                ),
              ),
            ),
          if (workoutsHistory.length > 0)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Workout _workout = workoutsHistory[index];

                  String name = _workout.name;
                  DateTime _date = DateTime.fromMillisecondsSinceEpoch(
                    _workout.timeInMillisSinceEpoch,
                  );

                  String dateDivider = "";

                  if ((currentMonth == null && currentYear == null) ||
                      requiresDateDivider(_date, currentMonth, currentYear)) {
                    currentMonth = _date.month;
                    currentYear = _date.year;

                    DateFormat format = new DateFormat("MMMM yyyy");
                    dateDivider = format.format(_date);
                  }

                  return Column(
                    children: <Widget>[
                      if (dateDivider != "")
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dateDivider,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .fontSize *
                                  0.8,
                            ),
                          ),
                        ),
                      Card(
                        key: UniqueKey(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            _workout.setUncompleted();

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    HistoryViewPage(
                                  workout: _workout.clone(),
                                  updateWorkoutsHistory: updateWorkoutsHistory,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                    16.0,
                                    16.0,
                                    16.0,
                                    12.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                for (int i = 0; i < 3; i++)
                                  buildExerciseWidget(context, _workout, i),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    _workout.exercises.length > 3
                                        ? 'More...'
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                childCount: workoutsHistory.length,
              ),
            ),
        ],
      ),
    );
  }
}
