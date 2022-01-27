import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/data/exercise_list.dart' as default_exercises;
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/screens/exercises/add_exercise_page.dart';
import 'package:fitoryx/screens/exercises/exercise_filter_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/exercise_divider.dart';
import 'package:fitoryx/widgets/exercise_item.dart';
import 'package:fitoryx/widgets/gradient_floating_action_button.dart';
import 'package:fitoryx/widgets/loader.dart';
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
  bool loading = true;

  final _firestoreService = FirestoreService();

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
  Exercise? _replaceExercise;

  @override
  void initState() {
    super.initState();
    _exercises = List.of(default_exercises.exercises);

    if (widget.workout != null) {
      _workoutExercises = List.of(widget.workout!.exercises);

      if (widget.isReplace) {
        _replaceExercise =
            widget.workout!.exercises[widget.workout!.replaceIndex!];
      }
    }

    _init();
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter _filter = Provider.of<ExerciseFilter>(context);

    _filterExercises(_filter);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          hideSearch ? _defaultAppBar() : _searchAppBar(_filter),
          loading
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
                          deleteExercise: _deleteExercise,
                          selected: selected,
                          isSelectable: widget.isSelectable,
                          onTap: widget.isSelectable
                              ? () {
                                  if (widget.isReplace) {
                                    setState(() {
                                      _replaceExercise = item.clone();
                                    });
                                  } else {
                                    if (selected) {
                                      _workoutExercises.removeAt(selectedIndex);
                                    } else {
                                      _workoutExercises.add(item.clone());
                                    }

                                    setState(() {
                                      _workoutExercises =
                                          List.of(_workoutExercises);
                                    });
                                  }
                                }
                              : null,
                        );
                      }

                      return ExerciseDivider(text: item);
                    },
                    childCount: _exercisesWithDividers.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Future<void> _init() async {
    try {
      List<Exercise> userExercises = await _firestoreService.getExercises();

      _exercises.addAll(userExercises);
    } catch (e) {
      showAlert(context, content: "Failed to load custom exercises");
    }

    _updateExercisesWithDividers();

    setState(() {
      loading = false;
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

      if (filter.types.isNotEmpty && !filter.types.contains(exercise.type)) {
        return false;
      }

      if (filter.search != "" &&
          !exercise.name.toLowerCase().contains(filter.search.toLowerCase())) {
        return false;
      }

      // hide all from workout list excepti
      if (widget.isReplace) {
        if (_workoutExercises.indexWhere((e) => e.equals(exercise)) > -1 &&
            !exercise.equals(_replaceExercise!)) {
          return false;
        }
      }

      return true;
    }).toList();

    Function eq = const ListEquality().equals;
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

  SliverAppBar _defaultAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.grey[50],
      floating: true,
      pinned: true,
      leading: widget.isSelectable
          ? IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            )
          : null,
      title: const Text(
        'Exercises',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() => hideSearch = false);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => const ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectable)
          IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
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
      backgroundColor: Colors.grey[50],
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
            child: const Icon(
              Icons.close_outlined,
              color: Colors.black,
            ),
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
        icon: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            hideSearch = true;
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
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
