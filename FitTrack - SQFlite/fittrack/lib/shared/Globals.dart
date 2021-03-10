import 'package:fittrack/services/SQLDatabase.dart';
import 'package:flutter/material.dart';

SQLDatabase sqlDatabase;

IconButton heartIcon = IconButton(
  icon: Icon(
    Icons.favorite,
    color: Colors.red,
  ),
  onPressed: () {
    print("HI");
  },
);

enum PageEnum {
  // globals.PageEnum.workout.index to get the index value for the 'changePage' function
  profile,
  history,
  workout,
  exercises,
  food,
}
