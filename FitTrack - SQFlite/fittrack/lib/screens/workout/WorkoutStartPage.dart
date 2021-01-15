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
            actions: <Widget>[
              isStarted
                  ? IconButton(
                      icon: Icon(
                        Icons.stop_rounded,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isStarted = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isStarted = true;
                        });
                      },
                    )
            ],
          ),
          SliverToBoxAdapter(
            child: Text(
                'show workout as if it is a started. But add a button at the top that says "start workout" and then after clicking it, we start the workout and then change the button name to "end workout", besides that make sure we use a timer and a persistent push notification (if possible). Also add a custom "rest timer", don\'t use the circle thing as we used in the other version. Use some type of digital clock with an option to "skip rest" and nothing else'),
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
