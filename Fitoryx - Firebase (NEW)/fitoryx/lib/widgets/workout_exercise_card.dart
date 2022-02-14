import 'dart:math';

import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/models/popup_option.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/providers/workout_change_notifier.dart';
import 'package:fitoryx/screens/exercises/exercises_page.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fitoryx/utils/int_extension.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:fitoryx/widgets/popup_menu.dart';
import 'package:fitoryx/widgets/rest_dialog.dart';
import 'package:fitoryx/widgets/time_header_row.dart';
import 'package:fitoryx/widgets/time_set_row.dart';
import 'package:fitoryx/widgets/weight_header_row.dart';
import 'package:fitoryx/widgets/weight_set_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseCard extends StatelessWidget {
  final int index;
  final Exercise exercise;
  final bool readonly;
  final bool started;
  final bool hideEmptyNotes;

  final List<PopupOption> _popupOptions = [
    PopupOption(text: 'Rest timer', value: 'rest'),
    PopupOption(text: 'Replace exercise', value: 'replace'),
    PopupOption(text: 'Remove exercise', value: 'remove'),
  ];

  WorkoutExerciseCard(
      {Key? key,
      required this.index,
      required this.exercise,
      this.readonly = false,
      this.started = false,
      this.hideEmptyNotes = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout =
        Provider.of<WorkoutChangeNotifier>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    exercise.getTitle(),
                    style: TextStyle(color: Colors.blue[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              readonly
                  ? _historyOption(_workout)
                  : _cardOption(context, _workout),
            ],
          ),
          if (!hideEmptyNotes || exercise.notes != "")
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
              child: FormInput(
                readOnly: readonly,
                hintText: 'Exercise notes',
                maxLines: null,
                isDense: true,
                initialValue: exercise.notes,
                onChanged: (String value) {
                  exercise.notes = value.trim();
                },
              ),
            ),
          exercise.type == ExerciseType.time
              ? const TimeHeaderRow()
              : WeightHeaderRow(unit: _workout.unit, readonly: readonly),
          for (int i = 0; i < exercise.sets.length; i++)
            Container(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: exercise.type == ExerciseType.time
                  ? TimeSetRow(
                      exerciseIndex: index,
                      setIndex: i,
                      started: started,
                      readonly: readonly,
                      workout: _workout,
                    )
                  : WeightSetRow(
                      exerciseIndex: index,
                      setIndex: i,
                      started: started,
                      readonly: readonly),
            ),
          readonly
              ? const SizedBox(height: 16.0)
              : TextButton(
                  child: Text(
                    'ADD SET',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    _workout.addSet(index);
                  },
                )
        ],
      ),
    );
  }

  Widget _historyOption(WorkoutChangeNotifier workout) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: exercise.type == ExerciseType.weight
              ? <Widget>[
                  Transform.rotate(
                    angle: -pi / 4,
                    child: Icon(
                      Icons.fitness_center_outlined,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "${exercise.getTotalWeight().toIntString()} ${UnitTypeHelper.toValue(workout.unit)}",
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ]
              : <Widget>[
                  Icon(
                    Icons.schedule,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    exercise.getTotalTime(),
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
        ),
      ),
    );
  }

  Widget _cardOption(BuildContext context, WorkoutChangeNotifier workout) {
    if (started) {
      return exercise.restEnabled
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.schedule,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "${(exercise.restSeconds ~/ 60).withZeroPadding()}:${(exercise.restSeconds % 60).withZeroPadding()}",
                    style: TextStyle(
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            )
          : Container();
    }

    return PopupMenu(
      items: _popupOptions,
      onSelected: (selected) {
        switch (selected) {
          case 'rest':
            showRestDialog(
              context,
              workout,
              exercise,
            );
            break;
          case 'replace':
            workout.replaceIndex = index;

            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ExercisesPages(
                  isSelectable: true,
                  isReplace: true,
                  workout: workout,
                ),
              ),
            );
            break;
          case 'remove':
            workout.removeExercise(index);
            break;
          default:
            break;
        }
      },
    );
  }
}
