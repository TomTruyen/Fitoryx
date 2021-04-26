// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/shared/Globals.dart' as globals;

class UserInfo extends StatelessWidget {
  final double avatarRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CircleAvatar(
              backgroundColor: Colors.grey[700],
              radius: avatarRadius,
              child: Icon(
                Icons.person_rounded,
                color: Colors.grey[50],
                size: avatarRadius * 1.5,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    globals.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    "${globals.workoutHistory.length} workouts",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
