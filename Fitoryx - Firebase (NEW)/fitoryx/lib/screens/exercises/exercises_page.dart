import 'package:collection/collection.dart';
import 'package:fitoryx/data/exercise_list.dart' as default_exercises;
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/subscription.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/providers/subscription_provider.dart';
import 'package:fitoryx/providers/workout_change_notifier.dart';
import 'package:fitoryx/screens/exercises/add_exercise_page.dart';
import 'package:fitoryx/screens/exercises/exercise_detail_page.dart';
import 'package:fitoryx/screens/exercises/exercise_filter_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/confirm_alert.dart';
import 'package:fitoryx/widgets/exercise_item.dart';
import 'package:fitoryx/widgets/gradient_floating_action_button.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/pro_dialog.dart';
import 'package:fitoryx/widgets/subscription_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisesPages extends StatefulWidget {
  final WorkoutChangeNotifier? workout;
  final bool isSelectable;
  final bool isReplace;

  const ExercisesPages({
    Key? key,
    this.workout,
    this.isSelectable = false,
    this.isReplace = false,
  }) : super(key: key);

  @override
  State<ExercisesPages> createState() => _ExercisesPagesState();
}

class _ExercisesPagesState extends State<ExercisesPages> {
  bool _loading = true;

  final FirestoreService _firestoreService = FirestoreService();
  final SettingsService _settingsService = SettingsService();

  // History (used in details)
  List<WorkoutHistory> _history = [];

  // Settings
  Settings _settings = Settings();

  // Search
  bool hideSearch = true;
  final TextEditingController _searchController = TextEditingController();

  // Exercises
  List<Exercise> _filtered = [];
  List<Exercise> _exercises = [];
  List<dynamic> _exercisesWithDividers = [];

  // Workout (Exercises)
  List<Exercise> _workoutExercises = [];

  // Replace
  Exercise? _initialReplaceExercise;
  Exercise? _replaceExercise;

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter _filter = Provider.of<ExerciseFilter>(context);
    final _subscription =
        Provider.of<SubscriptionProvider>(context).subscription;

    _filterExercises(_filter);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          hideSearch ? _defaultAppBar(_subscription) : _searchAppBar(_filter),
          _loading
              ? const SliverFillRemaining(child: Loader())
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      var item = _exercisesWithDividers[i];

                      if (item is Exercise) {
                        bool selected = false;
                        int selectedIndex = -1;

                        if (widget.isReplace) {
                          selected = item.equals(_replaceExercise!);
                        } else if (widget.isSelectable) {
                          selectedIndex = _workoutExercises.indexWhere(
                            (exercise) => exercise.equals(item),
                          );

                          selected = selectedIndex > -1;
                        }

                        return ExerciseItem(
                          exercise: item,
                          onDelete: item.userCreated && !widget.isSelectable
                              ? () async {
                                  clearFocus(context);

                                  showConfirmAlert(
                                    context,
                                    content:
                                        "You will be deleting \"${item.name}\". This action can't be reversed!",
                                    onConfirm: () async {
                                      try {
                                        await _firestoreService.deleteExercise(
                                          item.id,
                                        );

                                        _deleteExercise(item.id);

                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        showAlert(
                                          context,
                                          content: "Failed to delete exercise",
                                        );
                                      }
                                    },
                                  );
                                }
                              : null,
                          selected: selected,
                          isSelectable: widget.isSelectable,
                          onTap: widget.isSelectable
                              ? () {
                                  if (widget.isReplace) {
                                    var clone = item.clone();
                                    clone.restSeconds = _settings.rest;
                                    setState(() {
                                      _replaceExercise = clone;
                                    });
                                  } else {
                                    if (selected) {
                                      _workoutExercises.removeAt(selectedIndex);
                                    } else {
                                      var clone = item.clone();
                                      clone.restSeconds = _settings.rest;
                                      _workoutExercises.add(clone);
                                    }

                                    setState(() {
                                      _workoutExercises = List.of(
                                        _workoutExercises,
                                      );
                                    });
                                  }
                                }
                              : () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => ExerciseDetailPage(
                                        exercise: item,
                                        history: _history,
                                        settings: _settings,
                                      ),
                                    ),
                                  );
                                },
                        );
                      }

                      return ListDivider(text: item);
                    },
                    childCount: _exercisesWithDividers.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  void _init() async {
    _exercises = List.of(default_exercises.exercises);

    if (widget.workout != null) {
      _workoutExercises = List.of(widget.workout!.exercises);

      if (widget.isReplace) {
        _replaceExercise =
            widget.workout!.exercises[widget.workout!.replaceIndex!];
        _initialReplaceExercise =
            widget.workout!.exercises[widget.workout!.replaceIndex!];
      }
    }

    try {
      List<Exercise> userExercises = await _firestoreService.getExercises();

      _exercises.addAll(userExercises);
    } catch (e) {
      showAlert(context, content: "Failed to load custom exercises");
    }

    _updateExercisesWithDividers();

    var history = await _firestoreService.getHistory();
    var settings = await _settingsService.getSettings();

    for (int i = 0; i < history.length; i++) {
      if (history[i].workout.unit != _settings.weightUnit) {
        history[i].workout.changeUnit(_settings.weightUnit);
      }
    }

    setState(() {
      _history = history;
      _settings = settings;
      _loading = false;
    });
  }

  void _addExercise(Exercise exercise) {
    if (!_exercises.contains(exercise)) {
      setState(() {
        _exercises.add(exercise);
      });
    }
  }

  void _deleteExercise(String? id) {
    if (id != null) {
      setState(() {
        _exercises.removeWhere((exercise) => exercise.id == id);
      });
    }
  }

  void _filterExercises(ExerciseFilter filter) {
    List<Exercise> _oldFiltered = List.of(_filtered);

    _filtered = _exercises.where((exercise) {
      if (filter.categories.isNotEmpty &&
          !filter.categories.contains(exercise.category)) {
        return false;
      }

      if (filter.equipments.isNotEmpty &&
          !filter.equipments.contains(exercise.equipment)) {
        return false;
      }

      if (filter.types.isNotEmpty &&
          !filter.types.contains(ExerciseTypeHelper.toValue(exercise.type))) {
        return false;
      }

      if (filter.search != "" &&
          !exercise.name.toLowerCase().contains(filter.search.toLowerCase())) {
        return false;
      }

      // hide all from workout list excepti
      if (widget.isReplace) {
        if (_workoutExercises.indexWhere((e) => e.equals(exercise)) > -1 &&
            !exercise.equals(_replaceExercise!) &&
            !exercise.equals(_initialReplaceExercise!)) {
          return false;
        }
      }

      return true;
    }).toList();

    Function eq = const DeepCollectionEquality.unordered().equals;
    if (!eq(_oldFiltered, _filtered)) {
      _updateExercisesWithDividers();

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        filter.setCount(_filtered.length);
      });
    }
  }

  void _updateExercisesWithDividers() {
    setState(() {
      _exercisesWithDividers = addListDividers(_filtered);
    });
  }

  SliverAppBar _defaultAppBar(Subscription subscription) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      leading: widget.isSelectable ? const CloseButton() : null,
      title: const Text('Exercises'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () {
            setState(() => hideSearch = false);
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_outlined),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => const ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectable) const SubscriptionIcon(),
        if (!widget.isSelectable)
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final userExerciseCount =
                    _exercises.where((e) => e.userCreated).length;

                if (subscription is FreeSubscription &&
                    userExerciseCount >= subscription.exerciseLimit!) {
                  await showProDialog(
                    context,
                    content:
                        "You have reached your maximum amount of exercises (${subscription.exerciseLimit}). Upgrade to Pro to get unlimited exercises!",
                  );
                  return;
                }

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) =>
                        AddExercisePage(addExercise: _addExercise),
                  ),
                );
              })
      ],
    );
  }

  SliverAppBar _searchAppBar(ExerciseFilter filter) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: Colors.grey[300],
          filled: true,
          hintText: 'Search exercises...',
          hintStyle: const TextStyle(color: Colors.black54),
          suffixIcon: GestureDetector(
            child: const Icon(Icons.close_outlined, color: Colors.black),
            onTap: () {
              _searchController.text = "";
              filter.setSearch("");
            },
          ),
        ),
        onChanged: (query) {
          filter.setSearch(query);
        },
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        onPressed: () {
          setState(() {
            hideSearch = true;
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.filter_list_outlined),
          onPressed: () {
            clearFocus(context);

            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => const ExerciseFilterPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  GradientFloatingActionButton? _floatingActionButton() {
    if (widget.isReplace) {
      if (_replaceExercise!
          .equals(widget.workout!.exercises[widget.workout!.replaceIndex!])) {
        return null;
      }

      return GradientFloatingActionButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          widget.workout?.replaceExercise(_replaceExercise!);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
    }

    if (widget.isSelectable) {
      return GradientFloatingActionButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          if (widget.workout != null) {
            widget.workout!.updateExercises(_workoutExercises);
          }

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
    }

    return null;
  }
}
