import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/pages/workout/WorkoutStartPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(14.0),
                  backgroundColor: Theme.of(context).accentColor,
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
