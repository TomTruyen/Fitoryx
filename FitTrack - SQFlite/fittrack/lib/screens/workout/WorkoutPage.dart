import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fittrack/screens/workout/WorkoutCreatePage.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.grey[50],
          floating: true,
          pinned: true,
          title: Text(
            'Workout',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 60.0,
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Create Workout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => WorkoutCreatePage(),
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Text(
            'Finish workoutcreatepage, and show all workouts here in a sliverlist with as childs: \'Card\' widgets',
          ),
        )
      ],
    );
  }
}
