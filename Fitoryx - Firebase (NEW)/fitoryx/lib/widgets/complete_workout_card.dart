import 'dart:math';

import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_set.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompleteWorkoutCard extends StatelessWidget {
  final WorkoutHistory history;

  const CompleteWorkoutCard({Key? key, required this.history})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              history.workout.name,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              DateFormat('EEEE, dd MMMM y, H:mm').format(history.date),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        history.duration,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Transform.rotate(
                        angle: -pi / 4,
                        child: const Icon(
                          Icons.fitness_center_outlined,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${history.workout.getTotalVolume().toIntString()!} ${UnitTypeHelper.toValue(history.workout.unit)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    "Exercise",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Expanded(
                  child: Text(
                    "Best set",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) {
                  final exercise = history.workout.exercises[index];

                  return Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${exercise.sets.length} x ${exercise.getTitle()}",
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: Text(
                          _bestSetTitle(exercise),
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
                itemCount: history.workout.exercises.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _bestSetTitle(Exercise exercise) {
    ExerciseSet set = exercise.getBestSet();

    return "${set.reps} x ${set.weight?.toIntString()} ${UnitTypeHelper.toValue(history.workout.unit)}";
  }
}
