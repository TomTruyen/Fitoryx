// Dart Packages
import 'dart:isolate';

// Flutter Packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:provider/provider.dart';

// My Packages
import 'package:fittrack/pages/exercise/popups/DeleteExercisePopup.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';
import 'package:fittrack/model/workout/WorkoutExerciseSet.dart';
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/pages/exercise/ExerciseAddPage.dart';
import 'package:fittrack/misc/exercises/ExercisePageFunctions.dart';
import 'package:fittrack/pages/exercise/ExerciseFilterPage.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExercisePage extends StatefulWidget {
  final bool isSelectActive;
  final bool isReplaceExercise;
  final int exerciseIndexToReplace;

  ExercisePage({
    this.isSelectActive = false,
    this.isReplaceExercise = false,
    this.exerciseIndexToReplace = -1,
  });

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  // Exercises
  List<dynamic> exercises;
  List<ExerciseCategory> categories;
  List<ExerciseEquipment> equipment;

  ExerciseFilter exerciseFilter;
  bool exerciseFilterLoaded = false;

  // Workout
  WorkoutChangeNotifier workout;

  bool exerciseReplaced = false;
  WorkoutExercise exerciseToReplace;
  bool exerciseReplaceRemoveWorkoutExercisesFiltered = false;

  // Appbar (Search)
  bool isSearching = false;
  TextEditingController searchQueryController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      exercises = globals.exercises ?? [];
      categories = globals.categories ?? [];
      equipment = globals.equipment ?? [];
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateExercises(List<dynamic> _exercises) {
    setState(() {
      exercises = _exercises;
    });
  }

  static void _loadExercises(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<Exercise> exercises = await Database(uid: _uid).getExercises() ?? [];

    _sendPort.send(exercises);
  }

  Future<bool> refreshExercises() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadExercises,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<Exercise> _exercises = data as List<Exercise>;

      globals.exercises = _exercises;

      filterExercises(exerciseFilter, updateExercises, exerciseToReplace,
          widget.isReplaceExercise, workout);

      receivePort.close();
      isolate.kill();
      isolate = null;
    });

    bool isCompleted = false;

    await Future.doWhile(() async {
      return await Future.delayed(Duration(milliseconds: 500), () {
        return isolate != null;
      });
    });

    return isCompleted;
  }

  void updateExerciseReplaced(value) {
    setState(() {
      exerciseReplaced = value;
    });
  }

  Widget build(BuildContext context) {
    exerciseFilter = Provider.of<ExerciseFilter>(context) ?? ExerciseFilter();
    workout = Provider.of<WorkoutChangeNotifier>(context) ?? null;

    bool filterRequired = false;

    if (workout != null &&
        widget.isReplaceExercise &&
        !exerciseReplaced &&
        !exerciseReplaceRemoveWorkoutExercisesFiltered) {
      exerciseToReplace = workout.exercises[widget.exerciseIndexToReplace];
      exerciseReplaceRemoveWorkoutExercisesFiltered = true;
      filterRequired = true;
    }

    if (exerciseFilter != null) {
      if (!exerciseFilterLoaded) {
        exerciseFilterLoaded = true;
        filterRequired = true;
      }

      if (globals.exerciseFilter == null ||
          globals.exerciseFilter != exerciseFilter) {
        globals.exerciseFilter = exerciseFilter;
      }
      // Check SelectedCategories from ExerciseFilter
      if (!listEquals(
        globals.selectedCategories,
        exerciseFilter.selectedCategories,
      )) {
        globals.selectedCategories = [...exerciseFilter.selectedCategories];
        filterRequired = true;
      }

      // Check SelectedEquipment from ExerciseFilter
      if (!listEquals(
        globals.selectedEquipment,
        exerciseFilter.selectedEquipment,
      )) {
        globals.selectedEquipment = [...exerciseFilter.selectedEquipment];
        filterRequired = true;
      }

      // Check SelectedTypes from ExerciseFilter
      if (!listEquals(
        globals.selectedTypes,
        exerciseFilter.selectedTypes,
      )) {
        globals.selectedTypes = [...exerciseFilter.selectedTypes];
        filterRequired = true;
      }

      // Check if SearchQuery has a value
      if (exerciseFilter.searchQuery != searchQuery) {
        searchQuery = exerciseFilter.searchQuery;
        filterRequired = true;
      }

      if (exerciseFilter.exerciseCount == null) {
        filterRequired = true;
      }
    }

    if (filterRequired && exercises != null) {
      filterExercises(
        exerciseFilter,
        updateExercises,
        exerciseToReplace,
        widget.isReplaceExercise,
        workout,
      );
    }

    return _ExercisePageView(this);
  }

  // Search Field Widget
  Widget buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        fillColor: Colors.grey[300],
        filled: true,
        hintText: 'Search exercises...',
        hintStyle: TextStyle(color: Colors.black54),
      ),
      onChanged: (query) {
        exerciseFilter.updateSearchQuery(query);
      },
    );
  }

  // Clear Search
  void _clearSearchQuery() {
    exerciseFilter.updateSearchQuery("");
    setState(() {
      searchQueryController.clear();
    });
  }

  // Hide Search
  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      isSearching = false;
    });
  }

  // Show Search
  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      isSearching = true;
    });
  }

  // Appbar Actions Widgets
  List<Widget> buildActions() {
    if (isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (searchQueryController == null ||
                searchQueryController.text.isEmpty) {
              popContextWhenPossible(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectActive)
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseAddPage(refreshExercises),
                ),
              );
            },
          ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseFilterPage(),
            ),
          );
        },
      ),
      if (!widget.isSelectActive)
        Theme(
          data: Theme.of(context).copyWith(
            cardColor: Color.fromRGBO(35, 35, 35, 1),
            dividerColor: Color.fromRGBO(70, 70, 70, 1),
          ),
          child: PopupMenuButton(
            offset: Offset(0.0, 80.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            icon: Icon(Icons.more_vert),
            onSelected: (selection) => {
              if (selection == 'create')
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseAddPage(refreshExercises),
                    ),
                  )
                },
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem>[
              PopupMenuItem(
                height: 40.0,
                value: 'create',
                child: Text(
                  'Create exercise',
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
    ];
  }
}

class _ExercisePageView extends StatelessWidget {
  final _ExercisePageState state;

  _ExercisePageView(this.state);

  @override
  Widget build(BuildContext context) {
    final bool _isSearching = state.isSearching;
    final bool _isSelectActive = state.widget.isSelectActive;
    final bool _isReplaceExercise = state.widget.isReplaceExercise;
    bool _exerciseReplaced = state.exerciseReplaced;

    final int _exerciseIndexToReplace = state.widget.exerciseIndexToReplace;

    final List<dynamic> _exercises = state.exercises;

    final WorkoutChangeNotifier _workout = state.workout;
    final WorkoutExercise _exerciseToReplace = state.exerciseToReplace;

    final Function _buildSearchField = state.buildSearchField;
    final Function _buildActions = state.buildActions;
    final Function _refreshExercises = state.refreshExercises;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: RefreshIndicator(
          displacement: 120.0,
          onRefresh: () async {
            return await _refreshExercises();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _isSearching || _isSelectActive ? 50.0 : 120.0,
                forceElevated: _isSearching || _isSelectActive ? true : false,
                floating: false,
                pinned: true,
                flexibleSpace: !_isSearching && !_isSelectActive
                    ? FlexibleSpaceBar(
                        titlePadding: EdgeInsets.all(16.0),
                        title: Text('Exercises'),
                      )
                    : null,
                leading: _isSelectActive
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _workout.setBackupAsExercises();
                          if (_isReplaceExercise &&
                              _exerciseToReplace != null) {
                            _workout.exercises[_exerciseIndexToReplace] =
                                _exerciseToReplace;
                          }

                          popContextWhenPossible(context);
                        },
                      )
                    : null,
                title: _isSearching
                    ? _buildSearchField()
                    : _isSelectActive
                        ? Text('Exercises')
                        : null,
                actions: _buildActions(),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.0)),
              SliverList(
                delegate: (SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (_exercises[index] is Exercise) {
                      _exercises[index] = _exercises[index] as Exercise;

                      int foundIndex = -1;

                      for (int i = 0; i < _workout.exercises.length; i++) {
                        if (_exercises[index] is Exercise) {
                          Exercise exercise = _exercises[index] as Exercise;

                          if (_workout.exercises[i].exerciseId == exercise.id) {
                            foundIndex = i;
                            break;
                          }
                        }
                      }

                      return ListTile(
                        title: Text(
                          _exercises[index].equipment == ""
                              ? _exercises[index].name
                              : "${_exercises[index].name} (${_exercises[index].equipment})",
                          overflow: TextOverflow.ellipsis,
                          style: _isSelectActive && foundIndex != -1
                              ? Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Theme.of(context).accentColor,
                                  )
                              : Theme.of(context).textTheme.subtitle1,
                        ),
                        subtitle: Text(
                          _exercises[index].category,
                          style: _isSelectActive && foundIndex != -1
                              ? Theme.of(context).textTheme.caption.copyWith(
                                    color: Theme.of(context).accentColor,
                                  )
                              : Theme.of(context).textTheme.caption,
                        ),
                        trailing: !_isSelectActive &&
                                !_isReplaceExercise &&
                                (_exercises[index] as Exercise).isUserCreated
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey[900],
                                ),
                                onPressed: () {
                                  showPopupDeleteExercise(
                                    context,
                                    _exercises,
                                    _exercises[index],
                                    _refreshExercises,
                                  );
                                },
                              )
                            : null,
                        onTap: _isSelectActive
                            ? () {
                                Exercise exercise =
                                    _exercises[index] as Exercise;

                                if (_isReplaceExercise) {
                                  WorkoutExercise _exercise = WorkoutExercise(
                                    exerciseId: exercise.id,
                                    name: exercise.name,
                                    category: exercise.category,
                                    equipment: exercise.equipment,
                                    sets: [WorkoutExerciseSet()],
                                    restEnabled:
                                        globals.settings.isRestTimerEnabled,
                                  );

                                  _workout.setExercise(
                                    _exercise,
                                    _exerciseIndexToReplace,
                                  );

                                  if (!_exerciseReplaced) {
                                    state.updateExerciseReplaced(true);
                                  }
                                } else {
                                  if (foundIndex == -1) {
                                    _workout.addExercise(
                                      WorkoutExercise(
                                        exerciseId: exercise.id,
                                        name: exercise.name,
                                        category: exercise.category,
                                        equipment: exercise.equipment,
                                        sets: [WorkoutExerciseSet()],
                                        restEnabled:
                                            globals.settings.isRestTimerEnabled,
                                      ),
                                    );
                                  } else {
                                    _workout.removeExercise(
                                      _workout.exercises[foundIndex],
                                    );
                                  }
                                }
                              }
                            : null,
                      );
                    } else {
                      return Container(
                        alignment: Alignment.centerLeft,
                        height: 30.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          _exercises[index],
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  },
                  childCount: _exercises.length,
                )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (_isSelectActive &&
                  _workout.exercises.length > 0 &&
                  !_isReplaceExercise) ||
              _exerciseReplaced
          ? FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                popContextWhenPossible(context);
              },
            )
          : null,
    );
  }
}
