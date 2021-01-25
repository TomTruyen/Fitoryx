import 'package:fittrack/screens/workout/WorkoutStartPage.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class HistoryViewPage extends StatelessWidget {
  final Workout workout;
  final Function updateWorkoutsHistory;

  HistoryViewPage({this.workout, this.updateWorkoutsHistory});

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
            actions: <Widget>[
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
                  icon: Icon(Icons.more_vert),
                  onSelected: (selection) async {
                    if (selection == 'template') {
                      dynamic result =
                          globals.sqlDatabase.addWorkout(workout.clone());

                      if (result != null) {
                        await globals.sqlDatabase.getWorkouts();

                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) => WorkoutStartPage(
                              workout: globals.sqlDatabase.workouts[0].clone(),
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
                      dynamic result = await globals.sqlDatabase
                          .deleteWorkoutHistory(workout.id);

                      if (result != null) {
                        await updateWorkoutsHistory();

                        tryPopContext(context);
                      } else {
                        showPopupError(
                          context,
                          'Failed to delete',
                          'Something went wrong deleting this history. Please try again.',
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuItem>[
                    PopupMenuItem(
                      height: 40.0,
                      value: 'template',
                      child: Text(
                        'Save as workout',
                        style: Theme.of(context).textTheme.button.copyWith(
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
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: Text('show view history summary here')),
        ],
      ),
    );
  }
}
