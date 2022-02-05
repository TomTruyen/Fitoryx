import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fitoryx/utils/history_list_extension.dart';
import 'package:fitoryx/widgets/exercise_record_row.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:flutter/material.dart';

class ExerciseRecordsView extends StatelessWidget {
  final Exercise exercise;
  final List<WorkoutHistory> history;
  final Settings settings;

  const ExerciseRecordsView({
    Key? key,
    required this.exercise,
    required this.history,
    required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ListDivider(text: 'Personal Records', padding: null),
          ExerciseRecordRow(
            title: 'Max volume',
            value: _maxVolume(),
          ),
          ExerciseRecordRow(
            title: 'Max reps',
            value: _maxReps(),
          ),
          ExerciseRecordRow(
            title: 'Max weight',
            value: _maxWeight(),
          ),
          const SizedBox(height: 20),
          const ListDivider(text: 'Lifetime Stats', padding: null),
          ExerciseRecordRow(
            title: 'Total reps',
            value: _totalReps(),
          ),
          ExerciseRecordRow(
            title: 'Total volume',
            value: _totalVolume(),
          ),
        ],
      ),
    );
  }

  String? _maxVolume() {
    var volume = history.getMaxVolume(exercise);

    if (volume == 0) return '-';

    return "${volume.toIntString()} ${UnitTypeHelper.toValue(settings.weightUnit)}";
  }

  String? _maxReps() {
    var reps = history.getMaxReps(exercise);

    if (reps == 0) return '-';

    return "$reps reps";
  }

  String? _maxWeight() {
    var weight = history.getMaxWeight(exercise);

    if (weight == 0) return '-';

    return "${weight.toIntString()} ${UnitTypeHelper.toValue(settings.weightUnit)}";
  }

  String? _totalReps() {
    var reps = history.getTotalReps(exercise);

    if (reps == 0) return '-';

    return "$reps reps";
  }

  String? _totalVolume() {
    var weight = history.getTotalVolume(exercise);

    if (weight == 0) return '-';

    return "${weight.toIntString()} ${UnitTypeHelper.toValue(settings.weightUnit)}";
  }
}
