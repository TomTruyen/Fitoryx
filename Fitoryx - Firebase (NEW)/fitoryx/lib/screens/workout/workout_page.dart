import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/popup_option.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/subscription.dart';
import 'package:fitoryx/models/workout.dart';
import 'package:fitoryx/providers/subscription_provider.dart';
import 'package:fitoryx/providers/workout_change_notifier.dart';
import 'package:fitoryx/screens/workout/build_workout_page.dart';
import 'package:fitoryx/screens/workout/start_workout_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/confirm_alert.dart';
import 'package:fitoryx/widgets/exercise_row.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/popup_menu.dart';
import 'package:fitoryx/widgets/pro_dialog.dart';
import 'package:fitoryx/widgets/sort_button.dart';
import 'package:fitoryx/widgets/subscription_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  bool _loading = true;

  final FirestoreService _firestoreService = FirestoreService();
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  List<Workout> _workouts = [];

  bool isAscending = true;

  final List<PopupOption> _popupOptions = [
    PopupOption(text: 'Edit workout', value: 'edit'),
    PopupOption(text: 'Duplicate workout', value: 'duplicate'),
    PopupOption(text: 'Delete workout', value: 'delete'),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout = Provider.of<WorkoutChangeNotifier>(
      context,
      listen: false,
    );

    final _subscription =
        Provider.of<SubscriptionProvider>(context).subscription;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          const SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            title: Text('Workout'),
            actions: <Widget>[
              SubscriptionIcon(),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: GradientButton(
                text: 'Create Workout',
                onPressed: () async {
                  if (_subscription is FreeSubscription &&
                      _workouts.length >= _subscription.workoutLimit!) {
                    await showProDialog(
                      context,
                      content:
                          "You have reached your maximum amount of workouts (${_subscription.workoutLimit}). Upgrade to Pro to get unlimited workouts!",
                    );
                    return;
                  }

                  _workout.reset();
                  _workout.setUnit(_settings.weightUnit);

                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => BuildWorkoutPage(
                        updateWorkout: _addWorkout,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_workouts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 66,
                  ), // move it up a little (height + padding of button) so it aligns with history page
                  child: _loading
                      ? const Loader()
                      : const Text('No workouts created.'),
                ),
              ),
            ),
          if (_workouts.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: SortButton(
                  isAscending: isAscending,
                  text: 'Sort by name',
                  onPressed: _sortWorkouts,
                ),
              ),
            ),
          if (_workouts.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Workout workout = _workouts[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        if (workout.unit != _settings.weightUnit) {
                          _workout.withWorkout(
                            workout.clone(fullClone: true),
                            newUnit: _settings.weightUnit,
                          );
                        } else {
                          _workout.withWorkout(
                            workout.clone(fullClone: true),
                          );
                        }

                        _workout.fillEmpty();

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const StartWorkoutPage(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    16.0,
                                    0.0,
                                    16.0,
                                    12.0,
                                  ),
                                  child: Text(
                                    workout.name,
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              PopupMenu(
                                items: _popupOptions,
                                onSelected: (selection) async {
                                  switch (selection) {
                                    case 'edit':
                                      _workout.reset();

                                      if (workout.unit !=
                                          _settings.weightUnit) {
                                        _workout.withWorkout(
                                          workout.clone(fullClone: true),
                                          newUnit: _settings.weightUnit,
                                        );
                                      } else {
                                        _workout.withWorkout(
                                          workout.clone(fullClone: true),
                                        );
                                      }

                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) =>
                                              BuildWorkoutPage(
                                            updateWorkout: _editWorkout,
                                            isEdit: true,
                                          ),
                                        ),
                                      );
                                      break;
                                    case 'duplicate':
                                      _duplicateWorkout(workout.clone());
                                      break;
                                    case 'delete':
                                      _deleteWorkout(workout);
                                      break;
                                  }
                                },
                              )
                            ],
                          ),
                          _buildExerciseRows(workout.exercises),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              workout.exercises.length > 3 ? 'More...' : '',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _workouts.length,
              ),
            ),
        ],
      ),
    );
  }

  void _init() async {
    try {
      _workouts = await _firestoreService.getWorkouts();
      _sortWorkouts(noToggle: true);
    } catch (e) {
      showAlert(context, content: "Failed to load workouts");
    }

    var settings = await _settingsService.getSettings();

    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  void _addWorkout(Workout workout) {
    _workouts.add(workout);
    _sortWorkouts(noToggle: true);
  }

  void _editWorkout(Workout workout) {
    int index = _workouts.indexWhere((w) => w.id == workout.id);

    if (index > -1) {
      _workouts[index] = workout;

      _sortWorkouts(noToggle: true);
    }
  }

  void _deleteWorkout(Workout workout) {
    showConfirmAlert(
      context,
      content:
          "You will be deleting \"${workout.name}\". This action can't be reversed!",
      onConfirm: () async {
        try {
          await _firestoreService.deleteWorkout(workout.id);

          _workouts.removeWhere((w) => w.id == workout.id);

          _sortWorkouts(noToggle: true);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } catch (e) {
          showAlert(
            context,
            content: "Failed to delete workout",
          );
        }
      },
    );
  }

  void _duplicateWorkout(Workout workout) async {
    try {
      workout = await _firestoreService.saveWorkout(workout, duplicate: true);

      _addWorkout(workout);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      showAlert(context, content: "Failed to duplicate workout");
    }
  }

  void _sortWorkouts({bool noToggle = false}) {
    if (!noToggle) {
      isAscending = !isAscending;
    }

    _workouts.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    if (!isAscending) {
      _workouts = _workouts.reversed.toList();
    }

    setState(() {
      _workouts = _workouts;
    });
  }

  Column _buildExerciseRows(List<Exercise> exercises) {
    List<ExerciseRow> rows = [];

    for (int i = 0; i < 3; i++) {
      ExerciseRow row = const ExerciseRow();

      if (exercises.length > i) {
        row = ExerciseRow(
          sets: exercises[i].sets.length.toString(),
          name: exercises[i].name,
          equipment: exercises[i].equipment,
        );
      }

      rows.add(row);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}
