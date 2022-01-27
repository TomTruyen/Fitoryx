import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:flutter/material.dart';

class CompleteButton extends StatelessWidget {
  final bool started;
  final int exerciseIndex;
  final int setIndex;
  final WorkoutChangeNotifier workout;

  const CompleteButton({
    Key? key,
    this.started = false,
    required this.exerciseIndex,
    required this.setIndex,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !started,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: workout.exercises[exerciseIndex].sets[setIndex].completed
                ? Colors.green[400]
                : null,
          ),
          child: Icon(
            Icons.check,
            color: workout.exercises[exerciseIndex].sets[setIndex].completed
                ? Colors.white
                : Colors.black,
          ),
        ),
        onTap: () {
          workout.toggleSet(exerciseIndex, setIndex);
        },
      ),
    );
  }
}
