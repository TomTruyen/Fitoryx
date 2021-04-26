import 'dart:async';

import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/pages/workout/WorkoutStartTimerPage.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutStartPage extends StatefulWidget {
  @override
  _WorkoutStartPageState createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  WorkoutChangeNotifier workout;

  String timeToDisplay = "00:00";
  Stopwatch stopwatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void startTimer() {
    Timer(duration, keepRunning);
  }

  void keepRunning() {
    if (stopwatch.isRunning) {
      startTimer();
    }

    setState(() {
      if (stopwatch.elapsed.inHours < 1) {
        timeToDisplay =
            (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
                ":" +
                (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      } else {
        timeToDisplay = stopwatch.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      }
    });
  }

  void stopTimer() {}

  @override
  void initState() {
    super.initState();

    // Start Stopwatch
    stopwatch.start();
    startTimer();
  }

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 250.0,
              maxHeight: MediaQuery.of(context).size.height * 0.80,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[50],
              border: Border.all(
                width: 0,
              ),
            ),
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
            child: SingleChildScrollView(
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Color.fromRGBO(70, 70, 70, 1),
                  unselectedWidgetColor: Color.fromRGBO(
                    200,
                    200,
                    200,
                    1,
                  ),
                ),
                child: Material(
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                  color: Colors.grey[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'You are not done',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'You haven\'t finished every set in your workout.',
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(8.0),
                        child: TextButton(
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            popContextWhenPossible(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkoutExercises(
    WorkoutChangeNotifier workout,
    int index,
    UserSettings settings,
  ) {
    final WorkoutExercise currentExercise = workout.exercises[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
            if (currentExercise.restEnabled)
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.schedule,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "${currentExercise.restSeconds ~/ 60}:${(currentExercise.restSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),

        // Design for this part (notes)
        if (currentExercise.hasNotes)
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
            child: TextFormField(
              autofocus: false,
              maxLines: null,
              enabled: false,
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
              return Padding(
                padding: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 8.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            (setIndex + 1).toString(),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            enabled: false,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            initialValue: _calculateInitialWeight(
                              currentExercise.sets[setIndex].weight,
                              workout,
                              settings,
                            ),
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
                            enabled: false,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            initialValue:
                                currentExercise.sets[setIndex].reps.toString(),
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
                              workout.updateSetReps(index, setIndex, value);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              color: workout.exercises[index].sets[setIndex]
                                      .setComplete
                                  ? Colors.green[400]
                                  : null,
                            ),
                            child: Icon(
                              Icons.check,
                              color: workout.exercises[index].sets[setIndex]
                                      .setComplete
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              workout.exercises[index].sets[setIndex]
                                      .setComplete =
                                  !workout.exercises[index].sets[setIndex]
                                      .setComplete;
                            });
                            if (workout.exercises[index].sets[setIndex]
                                    .setComplete &&
                                workout.exercises[index].restEnabled) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WorkoutStartTimerPage(
                                    restSeconds:
                                        workout.exercises[index].restSeconds,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier dbWorkout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;
    final UserSettings settings = Provider.of<UserSettings>(context) ?? null;

    final User user = Provider.of<User>(context) ?? null;

    // Store exercise in state and then show this and then also when we update the provider we will also update the state of the the checkmark button

    if (dbWorkout != null) {
      setState(() {
        workout = dbWorkout;
      });
    }

    return Scaffold(
      body: workout == null || settings == null
          ? Loading()
          : ScrollConfiguration(
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
                    title: Text('Workout'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () async {
                          if (workout.finishedWorkout()) {
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
                            ).finishWorkout(workout, timeToDisplay);

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

                              stopwatch.stop();

                              Future.delayed(
                                Duration(milliseconds: 1500),
                                () {
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
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
                          } else {
                            _showMyDialog();
                          }
                        },
                      ),
                    ],
                  ),
                  SliverFillRemaining(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              workout.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(timeToDisplay),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Workout note',
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
                                workout.workoutNote = value;
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: workout.exercises.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: index > 0
                                      ? EdgeInsets.symmetric(vertical: 24.0)
                                      : EdgeInsets.only(bottom: 24.0),
                                  child: _buildWorkoutExercises(
                                    workout,
                                    index,
                                    settings,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

String _calculateInitialWeight(
  double weight,
  WorkoutChangeNotifier workout,
  UserSettings settings,
) {
  if (workout.weightUnit == settings.weightUnit) {
    return weight.toString();
  }

  return recalculateWeights(weight, settings.weightUnit).toString();
}
