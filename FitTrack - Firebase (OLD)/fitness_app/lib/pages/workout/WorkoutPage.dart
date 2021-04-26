import 'dart:ui';

import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/pages/workout/WorkoutCreatePage.dart';
import 'package:fitness_app/pages/workout/WorkoutEditPage.dart';
import 'package:fitness_app/pages/workout/WorkoutViewPage.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  bool loading = true;

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context);

    final List<WorkoutStreamProvider> dbWorkouts =
        Provider.of<List<WorkoutStreamProvider>>(context) ?? [];

    if (dbWorkouts != null && loading) {
      Future.delayed(
        Duration(seconds: 1),
        () => {
          setState(() {
            loading = false;
          })
        },
      );
    }

    return Scaffold(
      body: loading
          ? Loading()
          : ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.all(16.0),
                      title: Text('Workout'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              width: 1,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          padding: EdgeInsets.all(14.0),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        child: Text(
                          'Create Workout',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          workout.resetAll();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutCreatePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
                          child: Text(
                            'My Workouts',
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  dbWorkouts.length > 0
                      ? WorkoutListWidget()
                      : SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'No workouts created. \nPress \'Create Workout\' to create your first workout',
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}

class WorkoutListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<WorkoutStreamProvider> dbWorkouts =
        Provider.of<List<WorkoutStreamProvider>>(context) ?? [];

    final User user = Provider.of<User>(context) ?? null;

    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;

    return ReorderableSliverList(
      delegate: ReorderableSliverChildListDelegate(
        [
          for (int i = 0; i < dbWorkouts.length; i++)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.grey[400],
                  width: 1,
                ),
              ),
              margin: EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  workout.workoutStreamProviderToChangeNotifier(dbWorkouts[i]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WorkoutViewPage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                dbWorkouts[i].name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              cardColor: Color.fromRGBO(35, 35, 35, 1),
                              dividerColor: Color.fromRGBO(70, 70, 70, 1),
                            ),
                            child: PopupMenuButton(
                              offset: Offset(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              icon: Icon(
                                Icons.more_vert,
                              ),
                              onSelected: (selection) async {
                                if (selection == 'edit') {
                                  workout.workoutStreamProviderToChangeNotifier(
                                      dbWorkouts[i]);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WorkoutEditPage(),
                                    ),
                                  );
                                } else if (selection == 'duplicate') {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  final loadingSnackbar = SnackBar(
                                    elevation: 8.0,
                                    backgroundColor: Colors.orange[400],
                                    content: Text(
                                      'Duplicating...',
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(minutes: 1),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    loadingSnackbar,
                                  );

                                  dynamic result = await DatabaseService(
                                    uid: user != null ? user.uid : '',
                                  ).duplicateWorkout(dbWorkouts[i], dbWorkouts);

                                  await Future.delayed(
                                    Duration(milliseconds: 500),
                                    () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  );

                                  if (result != null) {
                                    final successSnackbar = SnackBar(
                                      duration: Duration(seconds: 1),
                                      elevation: 8.0,
                                      backgroundColor: Colors.green[400],
                                      content: GestureDetector(
                                        child: Text(
                                          'Duplicated',
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(successSnackbar);
                                  } else {
                                    final failureSnackbar = SnackBar(
                                      duration: Duration(seconds: 1),
                                      elevation: 8.0,
                                      backgroundColor: Colors.red[400],
                                      content: GestureDetector(
                                        child: Text(
                                          'Duplicating Failed',
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(failureSnackbar);
                                  }
                                } else if (selection == 'delete') {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  final loadingSnackbar = SnackBar(
                                    elevation: 8.0,
                                    backgroundColor: Colors.orange[400],
                                    content: Text(
                                      'Deleting...',
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(minutes: 1),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(loadingSnackbar);

                                  dynamic result = await DatabaseService(
                                    uid: user != null ? user.uid : '',
                                  ).removeWorkout(dbWorkouts[i], dbWorkouts);

                                  await Future.delayed(
                                    Duration(milliseconds: 500),
                                    () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  );

                                  if (result != null) {
                                    final successSnackbar = SnackBar(
                                      duration: Duration(seconds: 1),
                                      elevation: 8.0,
                                      backgroundColor: Colors.green[400],
                                      content: GestureDetector(
                                        child: Text(
                                          'Deleted',
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(successSnackbar);
                                  } else {
                                    final failureSnackbar = SnackBar(
                                      duration: Duration(seconds: 1),
                                      elevation: 8.0,
                                      backgroundColor: Colors.red[400],
                                      content: GestureDetector(
                                        child: Text(
                                          'Deleting Failed',
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(failureSnackbar);
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuItem>[
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
                        ],
                      ),
                      for (int j = 0; j < dbWorkouts[i].exercises.length; j++)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Text(
                            dbWorkouts[i].exercises[j].equipment == ""
                                ? dbWorkouts[i]
                                        .exercises[j]
                                        .sets
                                        .length
                                        .toString() +
                                    ' x ' +
                                    dbWorkouts[i].exercises[j].name
                                : dbWorkouts[i]
                                        .exercises[j]
                                        .sets
                                        .length
                                        .toString() +
                                    ' x ' +
                                    dbWorkouts[i].exercises[j].name +
                                    " (" +
                                    dbWorkouts[i].exercises[j].equipment +
                                    ")",
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
      ),
      onReorder: (int oldIndex, int newIndex) async {
        // Move Workout
        await DatabaseService(
          uid: user != null ? user.uid : '',
        ).reorderWorkout(oldIndex, newIndex, dbWorkouts);
      },
    );
  }
}
