import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/widgets/complete_button.dart';
import 'package:fitoryx/widgets/delete_button.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:fitoryx/widgets/time_dialog.dart';
import 'package:flutter/material.dart';

class TimeSetRow extends StatefulWidget {
  final WorkoutChangeNotifier workout;
  final int exerciseIndex;
  final int setIndex;
  final bool started;
  final bool readonly;

  const TimeSetRow({
    Key? key,
    required this.workout,
    required this.exerciseIndex,
    required this.setIndex,
    this.started = false,
    this.readonly = false,
  }) : super(key: key);

  @override
  State<TimeSetRow> createState() => _TimeSetRowState();
}

class _TimeSetRowState extends State<TimeSetRow> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _controller.text = widget
          .workout.exercises[widget.exerciseIndex].sets[widget.setIndex]
          .getTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            (widget.setIndex + 1).toString(),
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
              controller: _controller,
              readOnly: true,
              isDense: true,
              centerText: true,
              onTap: widget.readonly
                  ? null
                  : () async {
                      int time = await showTimeDialog(
                        context,
                        widget.workout.exercises[widget.exerciseIndex]
                            .sets[widget.setIndex].time,
                      );

                      widget.workout.updateTime(
                        widget.exerciseIndex,
                        widget.setIndex,
                        time,
                      );

                      _updateTime();
                    },
            ),
          ),
        ),
        if (!widget.readonly)
          Expanded(
            flex: 1,
            child: widget.started
                ? CompleteButton(
                    started: widget.started,
                    exerciseIndex: widget.exerciseIndex,
                    setIndex: widget.setIndex,
                    workout: widget.workout,
                  )
                : DeleteButton(
                    onTap: () {
                      widget.workout.removeSet(
                        widget.exerciseIndex,
                        widget.setIndex,
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
