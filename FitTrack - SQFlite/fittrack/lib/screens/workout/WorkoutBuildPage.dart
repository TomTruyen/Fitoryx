import 'package:fittrack/shared/GradientFloatingActionButton.dart';
import 'package:fittrack/shared/GradientIcon.dart';
import 'package:fittrack/shared/GradientText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/exercises/ExerciseSet.dart';
import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/screens/workout/popups/RestDialogPopup.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
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
                              globals.sqlDatabase.settings.defaultRestTime ??
                                  60,
                              globals.sqlDatabase.settings.isRestTimerEnabled ??
                                  1,
                            ),
                          );
                        } else {
                          result = await globals.sqlDatabase.addWorkout(
                            workout.convertToWorkout(
                              globals.sqlDatabase.settings.defaultRestTime ??
                                  60,
                              globals.sqlDatabase.settings.isRestTimerEnabled ??
                                  1,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      String _name = _exercise.name;

                      if (_exercise.equipment != "") {
                        _name += " (${_exercise.equipment})";
                      }

                      List<ExerciseSet> _sets = _exercise.sets;

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
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        text: _name,
                                        overflow: TextOverflow.ellipsis,
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
                                        icon: GradientIcon(),
                                        onSelected: (selection) {
                                          if (selection == 'remove') {
                                            workout.removeExercise(index);
                                          } else if (selection == 'rest') {
                                            showRestDialog(
                                              context,
                                              workout,
                                              _exercise,
                                            );
                                          } else if (selection == 'notes') {
                                            workout.toggleNotes(index);
                                          } else if (selection == 'replace') {
                                            workout.exerciseToReplaceIndex =
                                                index;

                                            workout.exerciseToReplace =
                                                _exercise;

                                            Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder:
                                                    (BuildContext context) =>
                                                        ExercisesPage(
                                                  isSelectActive: true,
                                                  isReplaceActive: true,
                                                  workout: workout,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'notes',
                                            child: Text(
                                              _exercise.hasNotes == 1
                                                  ? 'Remove notes'
                                                  : 'Add notes',
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
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'rest',
                                            child: Text(
                                              'Rest timer',
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
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            height: 40.0,
                                            value: 'replace',
                                            child: Text(
                                              'Replace exercise',
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
                                            value: 'remove',
                                            child: Text(
                                              'Remove exercise',
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
                              if (_exercise.hasNotes == 1)
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 0.0, 16.0, 12.0),
                                  child: TextFormField(
                                    autofocus: false,
                                    maxLines: null,
                                    initialValue: _exercise.notes,
                                    decoration: InputDecoration(
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
                                      contentPadding: EdgeInsets.all(8.0),
                                      isDense: true,
                                    ),
                                    onChanged: (value) {
                                      _exercise.notes = value;
                                    },
                                  ),
                                ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'SET',
                                        style: TextStyle(fontSize: 11.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        globals.sqlDatabase.settings.weightUnit
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 11.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'REPS',
                                        style: TextStyle(fontSize: 11.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                  ],
                                ),
                              ),
                              for (int i = 0; i < _sets.length; i++)
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
                                          initialValue:
                                              _sets[i].weight?.toString(),
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
                                          textInputAction: TextInputAction.next,
                                          onChanged: (String value) {
                                            workout.updateExerciseSetWeight(
                                              index,
                                              i,
                                              value,
                                            );
                                          },
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
                                          initialValue:
                                              _sets[i].reps?.toString(),
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
                                          textInputAction: TextInputAction.next,
                                          onChanged: (String value) {
                                            workout.updateExerciseSetReps(
                                              index,
                                              i,
                                              value,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          workout.deleteExerciseSet(index, i);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              FlatButton(
                                child: GradientText(
                                  text: 'ADD SET',
                                  fontWeight: FontWeight.w600,
                                ),
                                onPressed: () {
                                  workout.addExerciseSet(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
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
