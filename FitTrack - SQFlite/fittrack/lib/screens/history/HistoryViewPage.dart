import 'dart:math';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/screens/history/popups/DeleteHistoryPopup.dart';
import 'package:fittrack/screens/workout/WorkoutStartPage.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/GradientText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class HistoryViewPage extends StatelessWidget {
  final Workout workout;
  final Function updateWorkoutsHistory;
  final bool isHistory;

  HistoryViewPage({
    this.workout,
    this.updateWorkoutsHistory,
    this.isHistory = true,
  });

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
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
            title: Text(
              workout.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: isHistory
                ? <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: Color.fromRGBO(35, 35, 35, 1),
                        dividerColor: Color.fromRGBO(70, 70, 70, 1),
                      ),
                      child: PopupMenuButton(
                        offset: Offset(0.0, 80.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        icon: Icon(Icons.more_vert, color: Colors.black),
                        onSelected: (selection) async {
                          if (selection == 'template') {
                            dynamic result =
                                globals.sqlDatabase.addWorkout(workout.clone());

                            if (result != null) {
                              await globals.sqlDatabase.fetchWorkouts();

                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      WorkoutStartPage(
                                    workout:
                                        globals.sqlDatabase.workouts[0].clone(),
                                  ),
                                ),
                              );
                            } else {
                              showPopupError(
                                context,
                                'Failed to save',
                                'Something went wrong saving history as a workout. Please try again.',
                              );
                            }
                          } else if (selection == 'delete') {
                            bool isDeleted = await showPopupDeleteHistory(
                              context,
                              workout.id,
                              updateWorkoutsHistory,
                            );

                            if (isDeleted) {
                              tryPopContext(context);
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuItem>[
                          PopupMenuItem(
                            height: 40.0,
                            value: 'template',
                            child: Text(
                              'Save as workout',
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                            ),
                          ),
                          PopupMenuItem(
                            height: 40.0,
                            value: 'delete',
                            child: Text(
                              'Delete',
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getDateTimeFromMilliseconds(workout.timeInMillisSinceEpoch),
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize:
                          Theme.of(context).textTheme.bodyText2.fontSize * 1.2,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Duration: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: workout.duration,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Total Weight Lifted: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: workout.getTotalWeightLifted().toString() +
                              " " +
                              globals.sqlDatabase.settings.weightUnit,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Note: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: workout.note != "" ? workout.note : "/",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Exercise _exercise = workout.exercises[index];

                return Card(
                  key: UniqueKey(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  16.0,
                                  0.0,
                                  16.0,
                                  12.0,
                                ),
                                child: GradientText(
                                  text: _exercise.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  16.0,
                                  0.0,
                                  16.0,
                                  12.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Transform.rotate(
                                      angle: -pi / 4,
                                      child: Icon(
                                        Icons.fitness_center_outlined,
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    GradientText(
                                      text:
                                          "${_exercise.getTotalWeightLifted().toString()} ${globals.sqlDatabase.settings.weightUnit}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < _exercise.sets.length; i++)
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: GradientText(
                                  text: (i + 1).toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue:
                                        _exercise.sets[i].weight?.toString() ??
                                            '0.0',
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: '50',
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.all(6.0),
                                      isDense: true,
                                    ),
                                    onChanged: (String value) {},
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue:
                                        _exercise.sets[i].reps?.toString() ??
                                            '0',
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: '10',
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.all(6.0),
                                      isDense: true,
                                    ),
                                    onChanged: (String value) {},
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
              childCount: workout.exercises.length,
            ),
          ),
        ],
      ),
    );
  }
}
