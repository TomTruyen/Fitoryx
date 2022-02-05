import 'package:fitoryx/graphs/exercise_detail_graph.dart';
import 'package:fitoryx/graphs/models/exercise_graph_type.dart';
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/widgets/graph_card.dart';
import 'package:flutter/material.dart';

class ExerciseGraphsView extends StatelessWidget {
  final Exercise exercise;
  final List<WorkoutHistory> history;
  final Settings settings;

  const ExerciseGraphsView({
    Key? key,
    required this.exercise,
    required this.history,
    required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            GraphCard(
              height: 225,
              title:
                  "Max volume (${UnitTypeHelper.toValue(settings.weightUnit)})",
              graph: Container(
                padding: const EdgeInsets.all(8),
                child: ExerciseDetailGraph(
                  exercise: exercise,
                  history: history,
                  type: ExerciseGraphType.volume,
                  settings: settings,
                ),
              ),
            ),
            GraphCard(
              height: 225,
              title: "Max reps",
              graph: Container(
                padding: const EdgeInsets.all(8),
                child: ExerciseDetailGraph(
                  exercise: exercise,
                  history: history,
                  type: ExerciseGraphType.reps,
                  settings: settings,
                ),
              ),
            ),
            GraphCard(
              height: 225,
              title: "Max weight",
              graph: Container(
                padding: const EdgeInsets.all(8),
                child: ExerciseDetailGraph(
                  exercise: exercise,
                  history: history,
                  type: ExerciseGraphType.weight,
                  settings: settings,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
