import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/widgets/complete_button.dart';
import 'package:fitoryx/widgets/delete_button.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:fitoryx/widgets/time_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeSetRow extends StatelessWidget {
  final int exerciseIndex;
  final int setIndex;
  final bool started;

  const TimeSetRow({
    Key? key,
    required this.exerciseIndex,
    required this.setIndex,
    this.started = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout =
        Provider.of<WorkoutChangeNotifier>(context);

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            (setIndex + 1).toString(),
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
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FormInput(
              hintText: '0',
              initialValue:
                  _workout.exercises[exerciseIndex].sets[setIndex].getTime(),
              readOnly: true,
              isDense: true,
              centerText: true,
              onTap: () async {
                int time = await showTimeDialog(
                  context,
                  _workout.exercises[exerciseIndex].sets[setIndex].time,
                );

                _workout.updateTime(exerciseIndex, setIndex, time);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: started
              ? CompleteButton(
                  started: started,
                  exerciseIndex: exerciseIndex,
                  setIndex: setIndex,
                  workout: _workout)
              : DeleteButton(
                  onTap: () {
                    _workout.removeSet(exerciseIndex, setIndex);
                  },
                ),
        ),
      ],
    );
  }
}
