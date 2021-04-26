// Flutter Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/pages/exercise/ExercisePage.dart';
import 'package:fittrack/misc/workouts/WorkoutRestPopup.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Widget buildWorkoutExercises(
  BuildContext context,
  WorkoutChangeNotifier workout,
  int index,
  ExerciseFilter _exerciseFilter,
  bool isEdit,
) {
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
                    : currentExercise.name + " (${currentExercise.equipment})",
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
                onSelected: (selection) {
                  if (selection == 'remove') {
                    workout.removeExercise(currentExercise);
                  } else if (selection == 'rest') {
                    showRestDialog(context, workout, currentExercise);
                  } else if (selection == 'notes') {
                    workout.toggleNotes(currentExercise);
                  } else if (selection == 'replace') {
                    _exerciseFilter.clearFilters();

                    workout.backupExercises = [...workout.exercises];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ExercisePage(
                          isSelectActive: true,
                          isReplaceExercise: true,
                          exerciseIndexToReplace: index,
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
                globals.settings.weightUnit.toUpperCase(),
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
                      initialValue: workout.weightUnit !=
                              globals.settings.weightUnit
                          ? recalculateWeights(
                                  currentExercise.sets[setIndex].weight,
                                  globals.settings.weightUnit)
                              .toString()
                          : currentExercise.sets[setIndex].weight.toString(),
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
                        if (isEdit &&
                            !currentExercise.sets[setIndex].isEdited) {
                          currentExercise.sets[setIndex].isEdited = true;
                        }

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
