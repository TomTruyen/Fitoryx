import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:flutter/material.dart';

Widget buildExerciseWidget(
  BuildContext context,
  Workout workout,
  int exerciseIndex,
) {
  String exerciseString = "";

  if (workout.exercises.length > exerciseIndex) {
    Exercise exercise = workout.exercises[exerciseIndex];

    exerciseString = "${exercise.sets.length} x ${exercise.name}";

    if (exercise.equipment != "") {
      exerciseString += " (${exercise.equipment})";
    }
  }

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 4.0,
    ),
    child: Text(
      exerciseString,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.caption,
    ),
  );
}
