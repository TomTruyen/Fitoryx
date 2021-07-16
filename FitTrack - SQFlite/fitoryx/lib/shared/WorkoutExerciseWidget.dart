import 'dart:math';

import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/exercises/Exercise.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:Fitoryx/models/workout/WorkoutChangeNotifier.dart';
import 'package:Fitoryx/screens/exercises/ExercisesPage.dart';
import 'package:Fitoryx/screens/workout/WorkoutRestTimerPage.dart';
import 'package:Fitoryx/screens/workout/popups/RestDialogPopup.dart';
import 'package:Fitoryx/screens/workout/popups/TimePopup.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class WorkoutExerciseWidget extends StatelessWidget {
  final Exercise exercise;
  final WorkoutChangeNotifier workoutChangeNotifier;
  final Workout workout;
  final int exerciseIndex;
  final bool isTime; // Type of exercise measurement is 'Time' or 'Weight'
  final bool isStart; // Is WorkoutStartPage
  final bool isHistory;
  final Function getIsStarted;
  final Function toggleCompleted;

  WorkoutExerciseWidget({
    this.exercise,
    this.workoutChangeNotifier,
    this.workout,
    this.exerciseIndex,
    this.isTime = false,
    this.isStart = false,
    this.isHistory = false,
    this.getIsStarted,
    this.toggleCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    0.0,
                    16.0,
                    12.0,
                  ),
                  child: Text(
                    exercise.equipment == ""
                        ? exercise.name
                        : "${exercise.name} (${exercise.equipment})",
                    style: TextStyle(
                      color: Colors.blue[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (isStart && exercise.restEnabled == 1)
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.schedule,
                        color: Colors.blue[700],
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "${exercise.restSeconds ~/ 60}:${(exercise.restSeconds % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              if (isHistory)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: isTime
                          ? <Widget>[
                              Icon(
                                Icons.schedule,
                                color: Colors.blue[700],
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                exercise.getTotalTime(),
                                style: TextStyle(
                                  color: Colors.blue[700],
                                ),
                              ),
                            ]
                          : <Widget>[
                              Transform.rotate(
                                angle: -pi / 4,
                                child: Icon(
                                  Icons.fitness_center_outlined,
                                  color: Colors.blue[700],
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "${tryConvertDoubleToInt(exercise.getTotalVolume()).toString()} ${globals.sqlDatabase.settings.weightUnit}",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              if (!isStart && !isHistory)
                Container(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      cardColor: Color.fromRGBO(35, 35, 35, 1),
                      dividerColor: Color.fromRGBO(150, 150, 150, 1),
                    ),
                    child: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      icon: Icon(Icons.more_vert, color: Colors.blue[700]),
                      onSelected: (selection) {
                        if (selection == 'remove') {
                          workoutChangeNotifier.removeExercise(exerciseIndex);
                        } else if (selection == 'rest') {
                          showRestDialog(
                            context,
                            workoutChangeNotifier,
                            exercise,
                          );
                        } else if (selection == 'notes') {
                          workoutChangeNotifier.toggleNotes(exerciseIndex);
                        } else if (selection == 'replace') {
                          workoutChangeNotifier.exerciseToReplaceIndex =
                              exerciseIndex;
                          workoutChangeNotifier.exerciseToReplace = exercise;

                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) => ExercisesPage(
                                isSelectActive: true,
                                isReplaceActive: true,
                                workout: workoutChangeNotifier,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          height: 40.0,
                          value: 'notes',
                          child: Text(
                            exercise.hasNotes == 1
                                ? 'Remove notes'
                                : 'Add notes',
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
          if (exercise.hasNotes == 1)
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
              child: TextFormField(
                enabled: !isHistory ? true : false,
                autofocus: false,
                maxLines: null,
                initialValue: exercise.notes,
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
                  exercise.notes = value;
                },
              ),
            ),
          Row(
            children: isTime
                ? <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        'SET',
                        style: TextStyle(fontSize: 11.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        'TIME',
                        style: TextStyle(fontSize: 11.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    !isHistory ? Spacer(flex: 1) : SizedBox(width: 8.0),
                  ]
                : <Widget>[
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
                        globals.sqlDatabase.settings.weightUnit.toUpperCase(),
                        style: TextStyle(fontSize: 11.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "REPS",
                        style: TextStyle(fontSize: 11.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    !isHistory ? Spacer(flex: 1) : SizedBox(width: 8.0),
                  ],
          ),
          for (int i = 0; i < exercise.sets.length; i++)
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: isTime
                    ? <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.blue[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: TextFormField(
                              enabled: !isStart && !isHistory ? true : false,
                              readOnly: true,
                              initialValue: exercise.sets[i].getTime(),
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '0',
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
                              onTap: !isStart && !isHistory
                                  ? () async {
                                      int time = await showTimeDialog(
                                        context,
                                        exercise.sets[i].time,
                                      );

                                      workoutChangeNotifier
                                          .updateExerciseSetTime(
                                              exerciseIndex, i, time);
                                    }
                                  : null,
                            ),
                          ),
                        ),
                        if (!isStart && !isHistory)
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onTap: () {
                                workoutChangeNotifier.deleteExerciseSet(
                                  exerciseIndex,
                                  i,
                                );
                              },
                            ),
                          ),
                        if (isStart)
                          Expanded(
                            flex: 1,
                            child: AbsorbPointer(
                              absorbing: !getIsStarted(),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  margin: EdgeInsets.only(left: 2.0),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    color: exercise.sets[i].isCompleted
                                        ? Colors.green[400]
                                        : null,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: exercise.sets[i].isCompleted
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  if (getIsStarted()) {
                                    if (exercise.restEnabled == 1 &&
                                        !exercise.sets[i].isCompleted) {
                                      if (globals.sqlDatabase.settings
                                              .isRestTimerEnabled ==
                                          1) {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            fullscreenDialog: true,
                                            builder: (BuildContext context) =>
                                                WorkoutRestTimerPage(
                                              restSeconds: exercise.restSeconds,
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    toggleCompleted(exercise.sets[i]);
                                  }
                                },
                              ),
                            ),
                          ),
                        if (isHistory) SizedBox(width: 8.0),
                      ]
                    : <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14.0,
                            ),
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
                              enabled: !isStart && !isHistory ? true : false,
                              initialValue:
                                  tryConvertDoubleToInt(exercise.sets[i].weight)
                                          ?.toString() ??
                                      '0',
                              autofocus: false,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\d*\.?\d{0,2})'),
                                )
                              ],
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
                                workoutChangeNotifier.updateExerciseSetWeight(
                                  exerciseIndex,
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
                              enabled: !isStart && !isHistory ? true : false,
                              initialValue:
                                  exercise.sets[i].reps?.toString() ?? '0',
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                                workoutChangeNotifier.updateExerciseSetReps(
                                  exerciseIndex,
                                  i,
                                  value,
                                );
                              },
                            ),
                          ),
                        ),
                        if (!isStart && !isHistory)
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onTap: () {
                                workoutChangeNotifier.deleteExerciseSet(
                                  exerciseIndex,
                                  i,
                                );
                              },
                            ),
                          ),
                        if (isStart)
                          Expanded(
                            flex: 1,
                            child: AbsorbPointer(
                              absorbing: !getIsStarted(),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                    2.0,
                                    0.0,
                                    6.0,
                                    0.0,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    color: exercise.sets[i].isCompleted
                                        ? Colors.green[400]
                                        : null,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: exercise.sets[i].isCompleted
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  if (getIsStarted()) {
                                    if (exercise.restEnabled == 1 &&
                                        !exercise.sets[i].isCompleted) {
                                      if (globals.sqlDatabase.settings
                                              .isRestTimerEnabled ==
                                          1) {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            fullscreenDialog: true,
                                            builder: (BuildContext context) =>
                                                WorkoutRestTimerPage(
                                              restSeconds: exercise.restSeconds,
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    toggleCompleted(exercise.sets[i]);
                                  }
                                },
                              ),
                            ),
                          ),
                        if (isHistory) SizedBox(width: 8.0),
                      ],
              ),
            ),
          !isStart && !isHistory
              ? TextButton(
                  child: Text(
                    'ADD SET',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    workoutChangeNotifier.addExerciseSet(exerciseIndex);
                  },
                )
              : SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
