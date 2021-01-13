import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/screens/workout/WorkoutBuildPage.dart';
import 'package:fittrack/shared/Loader.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<Workout> workouts = globals.sqlDatabase.workouts;

  Future<void> updateWorkouts() async {
    await globals.sqlDatabase.getWorkouts();

    setState(() {
      workouts = globals.sqlDatabase.workouts;
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
    WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;

    return workout == null
        ? Loader()
        : Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.grey[50],
                  floating: true,
                  pinned: true,
                  title: Text(
                    'Workout',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 60.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'Create Workout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) => WorkoutBuildPage(
                              updateWorkouts: updateWorkouts,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (workouts.length > 0)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Workout _workout = workouts[index];

                        String name = _workout.name;

                        return Card(
                          key: UniqueKey(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 0.0, 16.0, 12.0),
                                        child: Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          cardColor:
                                              Color.fromRGBO(35, 35, 35, 1),
                                          dividerColor:
                                              Color.fromRGBO(150, 150, 150, 1),
                                        ),
                                        child: PopupMenuButton(
                                          offset: Offset(0, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          icon: Icon(
                                            Icons.more_vert,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          onSelected: (selection) async {
                                            switch (selection) {
                                              case 'edit':
                                                workout = _workout
                                                    .clone()
                                                    .convertToWorkoutChangeNotifier();

                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        WorkoutBuildPage(
                                                      updateWorkouts:
                                                          updateWorkouts,
                                                      isEdit: true,
                                                    ),
                                                  ),
                                                );
                                                break;
                                              case 'duplicate':
                                                dynamic result = await globals
                                                    .sqlDatabase
                                                    .duplicateWorkout(_workout);

                                                if (result != null) {
                                                  await updateWorkouts();
                                                }
                                                break;
                                              case 'delete':
                                                dynamic result = await globals
                                                    .sqlDatabase
                                                    .deleteWorkout(_workout.id);

                                                if (result != null) {
                                                  await updateWorkouts();
                                                }
                                                break;
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry>[
                                            PopupMenuItem(
                                              height: 40.0,
                                              value: 'edit',
                                              child: Text(
                                                'Edit workout',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              height: 40.0,
                                              value: 'duplicate',
                                              child: Text(
                                                'Duplicate workout',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              height: 40.0,
                                              value: 'delete',
                                              child: Text(
                                                'Delete workout',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                        );
                      },
                      childCount: workouts.length,
                    ),
                  ),
              ],
            ),
          );
  }
}
