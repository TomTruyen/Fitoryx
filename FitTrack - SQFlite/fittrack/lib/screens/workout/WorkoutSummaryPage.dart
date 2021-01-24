import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
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
            child: Text(
                "Basic idea for what this page should look like: https://drive.google.com/file/d/1Du18irqq5pDLIvWlx17c6v4XkU8ccmr5/view?usp=sharing"),
          ),
          SliverToBoxAdapter(
            child: Text(
              "Show summary of workout here (time of workout, amount of exercises, total amount of weight lifted, amount of reps done,...)",
            ),
          ),
          SliverToBoxAdapter(
            child: Text('Use Cards (and graphs maybe) to build this page'),
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
