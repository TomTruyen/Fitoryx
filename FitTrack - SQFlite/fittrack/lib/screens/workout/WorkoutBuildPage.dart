import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/shared/GradientFloatingActionButton.dart';
import 'package:fittrack/shared/WorkoutExerciseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class WorkoutBuildPage extends StatefulWidget {
  final Function updateWorkouts;
  final bool isEdit;

  WorkoutBuildPage({this.updateWorkouts, this.isEdit = false});

  @override
  _WorkoutBuildPageState createState() => _WorkoutBuildPageState();
}

class _WorkoutBuildPageState extends State<WorkoutBuildPage> {
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
              widget.isEdit ? 'Edit Workout' : 'Create Workout',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                workout.reset();
                tryPopContext(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () async {
                  dynamic result;
                  if (widget.isEdit) {
                    result = await globals.sqlDatabase.updateWorkout(
                      workout.convertToWorkout(
                        globals.sqlDatabase.settings.defaultRestTime ?? 60,
                        globals.sqlDatabase.settings.isRestTimerEnabled ?? 1,
                      ),
                    );
                  } else {
                    result = await globals.sqlDatabase.addWorkout(
                      workout.convertToWorkout(
                        globals.sqlDatabase.settings.defaultRestTime ?? 60,
                        globals.sqlDatabase.settings.isRestTimerEnabled ?? 1,
                      ),
                    );
                  }

                  if (result != null) {
                    await widget.updateWorkouts();
                    tryPopContext(context);
                  } else {
                    if (widget.isEdit) {
                      showPopupError(
                        context,
                        'Editing workout failed',
                        'Something went wrong editing the workout. Please try again.',
                      );
                    } else {
                      showPopupError(
                        context,
                        'Adding workout failed',
                        'Something went wrong adding the workout. Please try again.',
                      );
                    }
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextFormField(
                autofocus: false,
                initialValue: workout.name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Workout Name',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  workout.updateName(value);
                },
              ),
            ),
          ),
          ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Exercise _exercise = workout.exercises[index];

                if (_exercise.type == 'weight') {
                  return WorkoutExerciseWidget(
                    exercise: _exercise,
                    workoutChangeNotifier: workout,
                    exerciseIndex: index,
                    isTime: false,
                  );
                } else {
                  return WorkoutExerciseWidget(
                    exercise: _exercise,
                    workoutChangeNotifier: workout,
                    exerciseIndex: index,
                    isTime: true,
                  );
                }
              },
              childCount: workout.exercises.length,
            ),
            onReorder: (int oldIndex, int newIndex) {
              workout.moveExercise(oldIndex, newIndex);
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90.0,
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFloatingActionButton(
        icon: Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (_) => ExercisesPage(
                isSelectActive: true,
                workout: workout,
              ),
            ),
          );
        },
      ),
    );
  }
}
