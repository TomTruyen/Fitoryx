import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

class WorkoutStartPage extends StatefulWidget {
  final Workout workout;

  WorkoutStartPage({this.workout});

  @override
  _WorkoutStartPageState createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  bool isStarted = false;

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
            title: Text(
              widget.workout.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
          ),

          // add a custom "rest timer", don\'t use the circle thing as we used in the other version. Use some type of digital clock with an option to "skip rest" and nothing else'
          // On start workout: add a 'start timer' which counts down from 3 to 0 and then it starts the workout
          // add exercises (dispaly exercises)
          SliverToBoxAdapter(
            child: Container(
              height: 60.0,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  isStarted ? 'End Workout' : 'Start Workout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: isStarted ? Colors.red : Theme.of(context).accentColor,
                onPressed: () {
                  setState(() {
                    isStarted = !isStarted;
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              "isStarted: $isStarted",
              style: TextStyle(fontSize: 30.0),
            ),
          )
        ],
      ),
    );
  }
}
