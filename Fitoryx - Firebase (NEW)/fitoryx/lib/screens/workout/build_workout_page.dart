import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/screens/exercises/exercises_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/gradient_floating_action_button.dart';
import 'package:fitoryx/widgets/workout_exercise_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class BuildWorkoutPage extends StatefulWidget {
  final Function(Workout) addWorkout;

  const BuildWorkoutPage({Key? key, required this.addWorkout})
      : super(key: key);

  @override
  State<BuildWorkoutPage> createState() => _BuildWorkoutPageState();
}

class _BuildWorkoutPageState extends State<BuildWorkoutPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout =
        Provider.of<WorkoutChangeNotifier>(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: const Text(
              'Create Workout',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  _workout.reset();
                  Navigator.pop(context);
                }
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () async {
                  if (_workout.exercises.isEmpty) {
                    await showAlert(
                      context,
                      content:
                          "At least 1 exercise should be added to a workout!",
                    );

                    return;
                  }

                  Workout workout = _workout.toWorkout();

                  workout.id = await _firestoreService.createWorkout(workout);

                  widget.addWorkout(workout);

                  if (Navigator.canPop(context)) {
                    _workout.reset();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextFormField(
                autofocus: false,
                initialValue: _workout.name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  hintText: 'Workout Name',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _workout.setName(value);
                },
              ),
            ),
          ),
          ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return WorkoutExerciseCard(
                  index: index,
                  exercise: _workout.exercises[index],
                );
              },
              childCount: _workout.exercises.length,
            ),
            onReorder: (int oldIndex, int newIndex) {
              _workout.moveExercise(oldIndex, newIndex);
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 90.0,
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFloatingActionButton(
        icon: const Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (_) => ExercisesPages(
                isSelectable: true,
                workout: _workout,
              ),
            ),
          );
        },
      ),
    );
  }
}
