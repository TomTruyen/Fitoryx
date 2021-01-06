import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutCreatePage extends StatefulWidget {
  @override
  _WorkoutCreatePageState createState() => _WorkoutCreatePageState();
}

class _WorkoutCreatePageState extends State<WorkoutCreatePage> {
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
              'Create Workout',
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
          SliverToBoxAdapter(
            child: Text(
              'Make the create workout page here, for each exercise use \'Cards\' widget',
            ),
          )
        ],
      ),
    );
  }
}
