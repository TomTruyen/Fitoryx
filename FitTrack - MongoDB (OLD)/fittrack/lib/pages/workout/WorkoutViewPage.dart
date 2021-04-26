// Flutter Packages
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:provider/provider.dart';

// My Packages
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/pages/workout/WorkoutStartPage.dart';
import 'package:fittrack/misc/Functions.dart';

class WorkoutViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;

    return Scaffold(
      body: workout != null
          ? ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    forceElevated: true,
                    floating: true,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        popContextWhenPossible(context);
                      },
                    ),
                    title: workout != null
                        ? Text(workout.name)
                        : Text('New exercise'),
                  ),
                  SliverList(
                    delegate: (SliverChildBuilderDelegate(
                      (context, index) {
                        return ListTile(
                          title: Text(
                            workout.exercises[index].equipment == ""
                                ? "${workout.exercises[index].sets.length} x ${workout.exercises[index].name}"
                                : "${workout.exercises[index].sets.length} x ${workout.exercises[index].name} (${workout.exercises[index].equipment})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                      childCount: workout.exercises.length,
                    )),
                  ),
                ],
              ),
            )
          : Text('Failed to load workout'),
      bottomNavigationBar: workout != null
          ? Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(14.0),
                ),
                onPressed: () {
                  workout.setExercisesNotCompleted();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WorkoutStartPage(),
                    ),
                  );
                },
                child: Text(
                  'Start Workout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
