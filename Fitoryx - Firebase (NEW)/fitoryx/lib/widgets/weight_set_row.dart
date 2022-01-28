import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/complete_button.dart';
import 'package:fitoryx/widgets/delete_button.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WeightSetRow extends StatelessWidget {
  final int exerciseIndex;
  final int setIndex;
  final bool started;

  const WeightSetRow({
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
              color: Colors.blue[700],
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FormInput(
              hintText: '0',
              initialValue: convertDoubleToIntString(_workout
                      .exercises[exerciseIndex].sets[setIndex].weight) ??
                  "",
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.allow(
                  RegExp(r'(^\d*\.?\d{0,2})'),
                )
              ],
              inputType: TextInputType.number,
              centerText: true,
              isDense: true,
              inputAction: TextInputAction.next,
              onChanged: (String value) {
                _workout.updateWeight(exerciseIndex, setIndex, value);
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FormInput(
              hintText: '0',
              initialValue: _workout
                      .exercises[exerciseIndex].sets[setIndex].reps
                      ?.toString() ??
                  "",
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.digitsOnly,
              ],
              inputType: TextInputType.number,
              centerText: true,
              isDense: true,
              inputAction: TextInputAction.next,
              onChanged: (String value) {
                _workout.updateReps(exerciseIndex, setIndex, value);
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