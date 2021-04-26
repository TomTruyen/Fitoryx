// Dart Packages
import 'dart:isolate';

// Flutter Packages
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

// My Packages
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/pages/workout/WorkoutCreatePage.dart';
import 'package:fittrack/pages/workout/WorkoutEditPage.dart';
import 'package:fittrack/shared/Snackbars.dart';
import 'package:fittrack/model/workout/Workout.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/pages/workout/WorkoutViewPage.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<Workout> workouts;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<bool> refreshWorkouts() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadWorkouts,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<Workout> _workouts = data;

      globals.workouts = _workouts;

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

  static void _loadWorkouts(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<Workout> workouts = await Database(uid: _uid).getWorkouts() ?? [];

    _sendPort.send(workouts);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _WorkoutPageView(this);
  }
}

class _WorkoutPageView extends StatelessWidget {
  final _WorkoutPageState state;

  _WorkoutPageView(this.state);

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;

    final Function _refreshWorkouts = state.refreshWorkouts;
    final Function _updateState = state.updateState;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: RefreshIndicator(
          displacement: 120.0,
          onRefresh: () async {
            return await _refreshWorkouts();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
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
                  color: Colors.transparent,
                  padding: EdgeInsets.all(12.0),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
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
                          builder: (context) => WorkoutCreatePage(
                            refreshWorkouts: _refreshWorkouts,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              WorkoutList(
                workout: workout,
                refreshWorkouts: _refreshWorkouts,
                updateState: _updateState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final WorkoutChangeNotifier workout;
  final Function refreshWorkouts;
  final Function updateState;

  WorkoutList({
    this.workout,
    this.refreshWorkouts,
    this.updateState,
  });

  @override
  Widget build(BuildContext context) {
    if (globals.workouts.length > 0) {
      return ReorderableSliverList(
        onReorder: (int oldIndex, int newIndex) async {
          Workout workout = globals.workouts.removeAt(oldIndex);
          globals.workouts.insert(newIndex, workout);

          updateState();

          await Database(uid: globals.uid).reorderWorkout(globals.workouts);
        },
        delegate: ReorderableSliverChildListDelegate(
          [
            for (int i = 0; i < globals.workouts.length; i++)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.grey[400],
                    width: 1.0,
                  ),
                ),
                margin: EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    workout.workoutToChangeNotifier(globals.workouts[i]);
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
                                  globals.workouts[i].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w500),
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
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                icon: Icon(Icons.more_vert),
                                onSelected: (selection) async {
                                  if (selection == 'edit') {
                                    workout.workoutToChangeNotifier(
                                        globals.workouts[i]);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            WorkoutEditPage(
                                          refreshWorkouts: refreshWorkouts,
                                        ),
                                      ),
                                    );
                                  } else if (selection == 'duplicate') {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(duplicatingSnackbar);

                                    bool isDuplicated =
                                        await Database(uid: globals.uid)
                                            .duplicateWorkout(
                                                globals.workouts[i],
                                                globals.workouts);

                                    if (isDuplicated) {
                                      await refreshWorkouts();

                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              duplicateSuccessSnackbar);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(duplicateFailSnackbar);
                                    }
                                  } else if (selection == 'delete') {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      deletingSnackbar,
                                    );

                                    bool isDeleted =
                                        await Database(uid: globals.uid)
                                            .deleteWorkout(globals.workouts[i],
                                                globals.workouts);

                                    if (isDeleted) {
                                      await refreshWorkouts();

                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        deleteSuccessSnackbar,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        deleteFailedSnackbar,
                                      );
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
                        for (int j = 0;
                            j < globals.workouts[i].exercises.length;
                            j++)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Text(
                              globals.workouts[i].exercises[j].equipment == ""
                                  ? "${globals.workouts[i].exercises[j].sets.length} x ${globals.workouts[i].exercises[j].name}"
                                  : "${globals.workouts[i].exercises[j].sets.length} x ${globals.workouts[i].exercises[j].name} (${globals.workouts[i].exercises[j].equipment})",
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
      );
    } else {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No workouts created. \nPress \'Create Workout\' to create your first workout",
          ),
        ),
      );
    }
  }
}
