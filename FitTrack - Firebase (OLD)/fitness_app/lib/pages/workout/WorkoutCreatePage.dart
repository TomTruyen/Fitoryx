import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/exercises/ExerciseFilter.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/models/workout/WorkoutStreamProvider.dart';
import 'package:fitness_app/pages/exercises/ExercisePage.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutCreatePage extends StatefulWidget {
  @override
  _WorkoutCreatePageState createState() => _WorkoutCreatePageState();
}

class _WorkoutCreatePageState extends State<WorkoutCreatePage> {
  bool currentExerciseRestEnabled = true;
  int currentExerciseRestSeconds = 60;

  Future<void> _showRestDialog(
      WorkoutChangeNotifier workout, WorkoutExercise currentExercise) async {
    currentExerciseRestEnabled = currentExercise.restEnabled;
    currentExerciseRestSeconds = currentExercise.restSeconds;

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
                                value: currentExerciseRestEnabled,
                                onChanged: (bool value) {
                                  setState(() {
                                    currentExerciseRestEnabled = value;
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
                            opacity: currentExerciseRestEnabled ? 1 : 0.5,
                            child: AbsorbPointer(
                              absorbing: !currentExerciseRestEnabled,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem:
                                      (currentExercise.restSeconds ~/ 5) - 1,
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
                          child: TextButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              currentExercise.restEnabled =
                                  currentExerciseRestEnabled;
                              currentExercise.restSeconds =
                                  currentExerciseRestSeconds;

                              popContextWhenPossible(context);
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

  Widget _buildWorkoutExercises(
      WorkoutChangeNotifier workout, int index, UserSettings settings) {
    final WorkoutExercise currentExercise = workout.exercises[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                child: Text(
                  currentExercise.equipment == ""
                      ? currentExercise.name
                      : currentExercise.name +
                          " (${currentExercise.equipment})",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Color.fromRGBO(35, 35, 35, 1),
                  dividerColor: Color.fromRGBO(150, 150, 150, 1),
                ),
                child: PopupMenuButton(
                  offset: Offset(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).accentColor,
                  ),
                  onSelected: (selection) => {
                    if (selection == 'remove')
                      {workout.removeExercise(currentExercise)}
                    else if (selection == 'rest')
                      {_showRestDialog(workout, currentExercise)}
                    else if (selection == 'notes')
                      {workout.toggleNotes(currentExercise)}
                    else if (selection == 'replace')
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ExercisePage(
                              selectActive: true,
                              replaceExercise: true,
                              replaceIndex: index,
                            ),
                          ),
                        ),
                      }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      height: 40.0,
                      value: 'notes',
                      child: Text(
                        currentExercise.hasNotes ? 'Remove notes' : 'Add notes',
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      height: 40.0,
                      value: 'rest',
                      child: Text(
                        'Rest timer',
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      height: 40.0,
                      value: 'replace',
                      child: Text(
                        'Replace exercise',
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    PopupMenuItem(
                      height: 40.0,
                      value: 'remove',
                      child: Text(
                        'Remove exercise',
                        style: Theme.of(context).textTheme.button.copyWith(
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
        if (currentExercise.hasNotes)
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
            child: TextFormField(
              autofocus: false,
              maxLines: null,
              initialValue: currentExercise.notes,
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
                currentExercise.updateNotes(value);
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
                  settings.weightUnit == 'metric' ? 'KG' : 'LBS',
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
        Column(
          children: List.generate(
            currentExercise.sets.length,
            (setIndex) {
              return Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      (setIndex + 1).toString(),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        initialValue:
                            currentExercise.sets[setIndex].weight.toString(),
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
                          contentPadding: EdgeInsets.all(8.0),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          workout.updateSetWeight(index, setIndex, value);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        initialValue:
                            currentExercise.sets[setIndex].reps.toString(),
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
                          contentPadding: EdgeInsets.all(8.0),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          workout.updateSetReps(index, setIndex, value);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          workout.deleteSet(index, setIndex);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 16.0),
          child: TextButton(
            child: Text(
              'ADD SET',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              workout.addSet(index);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context) ?? null;
    final ExerciseFilter exerciseFilter =
        Provider.of<ExerciseFilter>(context) ?? null;
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context);
    final List<WorkoutStreamProvider> dbWorkouts =
        Provider.of<List<WorkoutStreamProvider>>(context) ?? null;
    final UserSettings settings = Provider.of<UserSettings>(context) ?? null;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  popContextWhenPossible(context);
                },
              ),
              title: Text('Create workout'),
              actions: [
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    if (workout.exercises.length > 0) {
                      if (settings != null &&
                          workout.weightUnit != settings.weightUnit) {
                        workout.weightUnit = settings.weightUnit;
                      }

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      final loadingSnackbar = SnackBar(
                        elevation: 8.0,
                        backgroundColor: Colors.orange[400],
                        content: Text(
                          'Saving...',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(minutes: 1),
                      );

                      ScaffoldMessenger.of(context)
                          .showSnackBar(loadingSnackbar);

                      dynamic result = await DatabaseService(
                        uid: user != null ? user.uid : '',
                      ).addWorkout(workout, dbWorkouts);

                      await Future.delayed(
                        Duration(milliseconds: 500),
                        () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      );

                      if (result != null) {
                        final successSnackbar = SnackBar(
                          duration: Duration(seconds: 1),
                          elevation: 8.0,
                          backgroundColor: Colors.green[400],
                          content: GestureDetector(
                            child: Text(
                              'Saved',
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

                        Future.delayed(
                          Duration(milliseconds: 1500),
                          () {
                            popContextWhenPossible(context);
                          },
                        );
                      } else {
                        final failureSnackbar = SnackBar(
                          duration: Duration(seconds: 1),
                          elevation: 8.0,
                          backgroundColor: Colors.red[400],
                          content: GestureDetector(
                            child: Text(
                              'Save Failed',
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
              delegate: ReorderableSliverChildListDelegate([
                for (int i = 0; i < workout.exercises.length; i++)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildWorkoutExercises(workout, i, settings),
                    key: UniqueKey(),
                  )
              ]),
              onReorder: (int oldIndex, int newIndex) {
                workout.moveListItem(oldIndex, newIndex);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          exerciseFilter.clearFilters();

          workout.backupExercises = [...workout.exercises];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExercisePage(
                selectActive: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
