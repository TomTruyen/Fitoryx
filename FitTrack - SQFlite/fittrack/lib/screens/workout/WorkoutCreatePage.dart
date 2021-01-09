import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/exercises/ExerciseSet.dart';
import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Loader.dart';

/*
  Add save button + save functionality NOTE: if workout name is empty then make the name 'Workout' in the database
  On delete of a set, if I just typed in a value, it deletes the correct set, but the typed in value is just given to the set that is in that position
  // Example: set 0 --> weight: 123, set 1 --> null, if I then delete set 0, set 1 gets 123 in the textfield, but not on the actual object

  Make it so that this code can also be used for the 'edit' future of workouts
*/

class WorkoutCreatePage extends StatefulWidget {
  @override
  _WorkoutCreatePageState createState() => _WorkoutCreatePageState();
}

class _WorkoutCreatePageState extends State<WorkoutCreatePage> {
  Future<void> showRestDialog(
    BuildContext context,
    WorkoutChangeNotifier workout,
    Exercise _exercise,
  ) async {
    int currentExerciseRestEnabled = _exercise.restEnabled ?? 0;
    int currentExerciseRestSeconds = _exercise.restSeconds ?? 60;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.5,
                  maxHeight: MediaQuery.of(context).size.height * 0.80,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[50],
                  border: Border.all(
                    width: 0,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                child: SingleChildScrollView(
                  child: Material(
                    color: Colors.grey[50],
                    child: ListBody(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Enabled',
                              ),
                            ),
                            Spacer(flex: 2),
                            Expanded(
                              child: Switch(
                                value: currentExerciseRestEnabled == 1
                                    ? true
                                    : false,
                                onChanged: (bool value) {
                                  setState(() {
                                    currentExerciseRestEnabled = value ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16.0),
                          height: 100.0,
                          child: Opacity(
                            opacity: currentExerciseRestEnabled == 1 ? 1 : 0.5,
                            child: AbsorbPointer(
                              absorbing: currentExerciseRestEnabled == 0,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: (_exercise.restSeconds ~/ 5) - 1,
                                ),
                                squeeze: 1.0,
                                looping: true,
                                diameterRatio: 100.0,
                                itemExtent: 40.0,
                                onSelectedItemChanged: (int index) {
                                  int seconds = 5 + (index * 5);

                                  currentExerciseRestSeconds = seconds;
                                },
                                useMagnifier: true,
                                magnification: 1.5,
                                children: <Widget>[
                                  for (int i = 5; i <= 300; i += 5)
                                    Center(
                                      child: Text(
                                        '${(i / 60).floor()}:${(i % 60).toString().padLeft(2, "0")}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              _exercise.restEnabled =
                                  currentExerciseRestEnabled;
                              _exercise.restSeconds =
                                  currentExerciseRestSeconds;

                              tryPopContext(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
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
                    'Create Workout',
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Exercise _exercise = workout.exercises[index];
                      String _name = _exercise.name;

                      if (_exercise.equipment != "") {
                        _name += " (${_exercise.equipment})";
                      }

                      List<ExerciseSet> _sets = _exercise.sets;

                      return Card(
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
                                          16.0, 0.0, 16.0, 12.0),
                                      child: Text(
                                        _name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
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
                                          color: Theme.of(context).accentColor,
                                        ),
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
                                        workout.weightUnit.toUpperCase(),
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
                                      child: Text(
                                        (i + 1).toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
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
                                          autofocus: false,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          initialValue: _sets[i].weight != null
                                              ? _sets[i].weight.toString()
                                              : null,
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
                                          autofocus: false,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          initialValue: _sets[i].reps != null
                                              ? _sets[i].reps.toString()
                                              : null,
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
                                child: Text(
                                  'ADD SET',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).accentColor,
                                  ),
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
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_outlined),
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
