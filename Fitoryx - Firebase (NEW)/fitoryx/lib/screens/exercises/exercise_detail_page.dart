import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/screens/exercises/exercise_graphs_view.dart';
import 'package:fitoryx/screens/exercises/exercise_records_view.dart';
import 'package:flutter/material.dart';

class ExerciseDetailPage extends StatelessWidget {
  final Exercise exercise;
  final List<WorkoutHistory> history;
  final Settings settings;

  const ExerciseDetailPage({
    Key? key,
    required this.exercise,
    required this.history,
    required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: const CloseButton(),
                floating: true,
                pinned: true,
                title: Text(exercise.getTitle()),
                bottom: TabBar(
                  indicatorColor: Colors.blue[700],
                  labelColor: Colors.blue[700],
                  unselectedLabelColor: Colors.blue[200],
                  tabs: const [
                    Tab(text: "Records"),
                    Tab(text: "Graphs"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ExerciseRecordsView(
                exercise: exercise,
                history: history,
                settings: settings,
              ),
              ExerciseGraphsView(
                exercise: exercise,
                history: history,
                settings: settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
