import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final Workout workout;
  final String workoutDuration;

  WorkoutSummaryPage({this.workout, this.workoutDuration = '00:00'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
            title: Text(
              'Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Duration: $workoutDuration'),
                  Text('Exercises: ${workout.exercises.length}'),
                  Text('Sets: ${workout.getSetCount()}'),
                  Text('Reps: ${workout.getRepCount()}'),
                  Text(
                    'Total Weight Lifted: ${workout.getTotalWeightLifted()} ${workout.weightUnit}',
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Text(
                "updated style, like: titles bold  + (add triangles with percentage changes between now and last workout)",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
