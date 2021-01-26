import 'dart:math';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/screens/history/HistoryViewPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

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

  Future<void> updateWorkoutsHistory() async {
    await globals.sqlDatabase.getWorkoutsHistory();

    workoutsHistory = globals.sqlDatabase.workouts;

    sortWorkoutsHistory(sortAscending);
  }

  void sortWorkoutsHistory(bool orderAscending) {
    workoutsHistory.sort((Workout a, Workout b) {
      if (orderAscending) {
        return a.timeInMillisSinceEpoch < b.timeInMillisSinceEpoch
            ? -1
            : a.timeInMillisSinceEpoch > b.timeInMillisSinceEpoch
                ? 1
                : 0;
      } else {
        return a.timeInMillisSinceEpoch < b.timeInMillisSinceEpoch
            ? 1
            : a.timeInMillisSinceEpoch > b.timeInMillisSinceEpoch
                ? -1
                : 0;
      }
    });

    setState(() {
      sortAscending = orderAscending;
    });
  }

  Widget buildExerciseWidget(
    BuildContext context,
    Workout workout,
    int exerciseIndex,
  ) {
    String exerciseString = "";

    if (workout.exercises.length > exerciseIndex) {
      Exercise exercise = workout.exercises[exerciseIndex];

      exerciseString = "${exercise.sets.length} x ${exercise.name}";

      if (exercise.equipment != "") {
        exerciseString += " (${exercise.equipment})";
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      child: Text(
        exerciseString,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
    );
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
                    FlatButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'Start now',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        widget.changePage(globals.PageEnum.workout.index);
                      },
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
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.transparent,
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
                    sortWorkoutsHistory(!sortAscending);
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

                  return InkWell(
                    onTap: () {
                      _workout.setUncompleted();

                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => HistoryViewPage(
                            workout: _workout.clone(),
                            updateWorkoutsHistory: updateWorkoutsHistory,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      key: UniqueKey(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
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
                                _workout.exercises.length > 3 ? 'More...' : '',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
