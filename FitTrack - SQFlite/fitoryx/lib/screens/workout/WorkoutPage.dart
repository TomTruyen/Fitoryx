import 'dart:math';

import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/settings/Settings.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:Fitoryx/models/workout/WorkoutChangeNotifier.dart';
import 'package:Fitoryx/screens/workout/WorkoutBuildPage.dart';
import 'package:Fitoryx/screens/workout/WorkoutStartPage.dart';
import 'package:Fitoryx/screens/workout/popups/DeleteWorkoutPopup.dart';
import 'package:Fitoryx/shared/ExerciseWidget.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:Fitoryx/shared/GradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  Settings settings;

  List<Workout> workouts = List.of(globals.sqlDatabase.workouts) ?? [];
  bool sortAscending = false;

  Future<void> updateWorkouts() async {
    await globals.sqlDatabase.fetchWorkouts();

    workouts = globals.sqlDatabase.workouts;

    sortWorkouts(workouts, sortAscending);
  }

  void sortWorkouts(List<Workout> _workouts, bool orderAscending) {
    List<Workout> sortedWorkouts = sortByDate(
      _workouts,
      orderAscending,
    ).cast<Workout>();

    setState(() {
      sortAscending = orderAscending;
      workouts = sortedWorkouts;
    });
  }

  @override
  void initState() {
    super.initState();

    settings = globals.sqlDatabase.settings;
  }

  @override
  Widget build(BuildContext context) {
    WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;

    return Scaffold(
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
            actions: <Widget>[
              globals.getDonationButton(context),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: GradientButton(
                text: 'Create Workout',
                onPressed: () {
                  workout.reset();

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
          if (workouts.length <= 0)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 76.0,
                  ), // move it up a little (height + padding of button) so it aligns with history page
                  child: Text('No workouts created.'),
                ),
              ),
            ),
          if (workouts.length > 0)
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
                        child: Icon(Icons.sort),
                      ),
                      SizedBox(width: 5.0),
                      Text('Sort by date'),
                    ],
                  ),
                  onPressed: () {
                    sortWorkouts(workouts, !sortAscending);
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
                                WorkoutStartPage(workout: _workout.clone()),
                          ),
                        );
                      },
                      child: Container(
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
                                        16.0, 0.0, 16.0, 12.0),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      cardColor: Color.fromRGBO(35, 35, 35, 1),
                                      dividerColor:
                                          Color.fromRGBO(150, 150, 150, 1),
                                    ),
                                    child: PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.blue[700],
                                      ),
                                      onSelected: (selection) async {
                                        switch (selection) {
                                          case 'edit':
                                            workout.copyWorkout(_workout);

                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder:
                                                    (BuildContext context) =>
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
                                            await showPopupDeleteWorkout(
                                              context,
                                              _workout.id,
                                              updateWorkouts,
                                            );

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
                                                  fontWeight: FontWeight.normal,
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
                                                  fontWeight: FontWeight.normal,
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
                                                  fontWeight: FontWeight.normal,
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
                childCount: workouts.length,
              ),
            ),
        ],
      ),
    );
  }
}
