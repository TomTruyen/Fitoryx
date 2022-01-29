import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/screens/exercises/exercises_page.dart';
import 'package:fitoryx/screens/history/history_detail_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/confirm_alert.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/gradient_floating_action_button.dart';
import 'package:fitoryx/widgets/workout_exercise_card.dart';
import 'package:fitoryx/widgets/workout_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({Key? key}) : super(key: key);

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  final FirestoreService _firestoreService = FirestoreService();

  bool _started = false;

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
            title: Text(
              _workout.name,
              overflow: TextOverflow.ellipsis,
            ),
            actions: _started
                ? <Widget>[
                    InkWell(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Text(
                          'FINISH',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      onTap: () async {
                        if (!_workout.isWorkoutCompleted()) {
                          showConfirmAlert(
                            context,
                            title: "Are you sure?",
                            content:
                                "You have not completed all sets. Are you sure you want to finish your workout?",
                            onConfirm: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              _saveWorkout(_workout);
                            },
                          );

                          return;
                        }

                        _saveWorkout(_workout);
                      },
                    ),
                  ]
                : [],
            leading: CloseButton(
              onPressed: () async {
                if (_started) {
                  showConfirmAlert(
                    context,
                    title: "Are you sure?",
                    content: "Are you sure you want to cancel the workout?",
                    onConfirm: () {
                      _endWorkout();

                      if (Navigator.canPop(context)) {
                        // Remove Popup
                        Navigator.pop(context);
                        // Close Start page
                        Navigator.pop(context);
                      }
                    },
                  );

                  return;
                }

                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _started
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            _workout.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        WorkoutTimer(started: _started, workout: _workout),
                        const SizedBox(height: 20.0),
                        FormInput(
                          maxLines: null,
                          hintText: 'Workout Note',
                          isDense: true,
                          onChanged: (String value) {
                            _workout.note = value.trim();
                          },
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: GradientButton(
                      text: 'Start Workout',
                      onPressed: () {
                        _startWorkout();
                      },
                    ),
                  ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return WorkoutExerciseCard(
                  index: index,
                  exercise: _workout.exercises[index],
                  started: _started,
                );
              },
              childCount: _workout.exercises.length,
            ),
          )
        ],
      ),
      floatingActionButton: !_started
          ? GradientFloatingActionButton(
              icon: const Icon(Icons.add_outlined),
              onPressed: () {
                clearFocus(context);

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
            )
          : null,
    );
  }

  void _startWorkout() {
    setState(() => _started = true);
  }

  void _endWorkout() {
    setState(() => _started = false);
  }

  void _saveWorkout(WorkoutChangeNotifier workout) async {
    _endWorkout();

    try {
      WorkoutHistory workoutHistory = workout.toWorkoutHistory();

      workoutHistory.id = await _firestoreService.createWorkoutHistory(
        workoutHistory,
      );

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => HistoryDetailPage(
            history: workoutHistory,
            readonly: true,
          ),
        ),
      );
    } catch (e) {
      showAlert(context, content: "Failed to save workout");
    }
  }
}
