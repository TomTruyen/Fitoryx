import 'package:fittrack/models/workout/Workout.dart';
import 'package:flutter/material.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final Workout workout;

  WorkoutSummaryPage({this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: Text(
              'Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              "Show summary of workout here (time of workout, amount of exercises, total amount of weight lifted, amount of reps done,...)",
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              "ALSO add option here for user to either, save their workout, or just remove it (no saving)",
            ),
          ),
        ],
      ),
    );
  }
}
