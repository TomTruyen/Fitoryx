// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/pages/workout/WorkoutStartTimerPage.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Widget buildWorkoutExercises(
  BuildContext context,
  WorkoutChangeNotifier workout,
  int index,
  Function toggleWorkoutComplete,
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
                    : currentExercise.name + " (${currentExercise.equipment})",
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
                            color: workout
                                    .exercises[index].sets[setIndex].setComplete
                                ? Colors.green[400]
                                : null,
                          ),
                          child: Icon(
                            Icons.check,
                            color: workout
                                    .exercises[index].sets[setIndex].setComplete
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onTap: () {
                          toggleWorkoutComplete(index, setIndex);
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

String _calculateInitialWeight(
  double weight,
  WorkoutChangeNotifier workout,
) {
  if (workout.weightUnit == globals.settings.weightUnit) {
    return weight.toString();
  }

  return recalculateWeights(weight, globals.settings.weightUnit).toString();
}
