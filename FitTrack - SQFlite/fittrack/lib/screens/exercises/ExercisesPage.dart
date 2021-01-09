import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/screens/exercises/ExerciseAddPage.dart';
import 'package:fittrack/screens/exercises/popups/DeleteExercisePopup.dart';
import 'package:fittrack/screens/exercises/ExerciseFilterPage.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/shared/ExerciseList.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExercisesPage extends StatefulWidget {
  final bool isSelectActive;
  final bool isReplaceActive;
  final WorkoutChangeNotifier workout;

  ExercisesPage({
    this.isSelectActive = false,
    this.isReplaceActive = false,
    this.workout,
  });

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  // WorkoutCreatePage (widget.selectActive)
  List<Exercise> workoutExercises = [];
  Exercise exerciseToReplace;

  // Variables used to limit the amount of times the filterExercise function gets called
  bool forceFilter = false;
  bool initialLoad = true;
  int isUserCreated;
  String searchValue;
  List<String> selectedCategories;
  List<String> selectedEquipment;

  // Variables
  List<Exercise> userExercises;
  List<dynamic> _filteredExercises;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  Future<void> updateUserExercises() async {
    await globals.sqlDatabase.getUserExercises();

    setState(() {
      forceFilter = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.workout != null && widget.isSelectActive) {
      workoutExercises = List.of(widget.workout.exercises);

      if (widget.isReplaceActive) {
        exerciseToReplace = widget.workout.exerciseToReplace;
      }
    }
  }

  void filterExercises(ExerciseFilter filter) {
    List<dynamic> filtered = [];

    List<Exercise> _exercises = List.of(exercises);

    if (globals.sqlDatabase.userExercises != null &&
        globals.sqlDatabase.userExercises.isNotEmpty) {
      _exercises.addAll(List.of(globals.sqlDatabase.userExercises));
    }

    List<String> selectedCategories = filter.selectedCategories ?? [];
    List<String> selectedEquipment = filter.selectedEquipment ?? [];
    int isUserCreated = filter.isUserCreated ?? 0;
    String searchValue = filter.searchValue ?? "";

    List<Exercise> selectedExercises = [];

    for (int i = 0; i < _exercises.length; i++) {
      bool addExercise = true;

      if (selectedCategories.isNotEmpty && selectedEquipment.isNotEmpty) {
        if (!selectedCategories.contains(_exercises[i].category) ||
            !selectedEquipment.contains(_exercises[i].equipment)) {
          addExercise = false;
        }
      } else if (selectedCategories.isNotEmpty) {
        if (!selectedCategories.contains(_exercises[i].category)) {
          addExercise = false;
        }
      } else if (selectedEquipment.isNotEmpty) {
        if (!selectedEquipment.contains(_exercises[i].equipment)) {
          addExercise = false;
        }
      }

      if (addExercise) {
        if (_exercises[i]
            .name
            .toLowerCase()
            .contains(searchValue.toLowerCase())) {
          if ((isUserCreated == 1 &&
                  isUserCreated == _exercises[i].isUserCreated) ||
              filter.isUserCreated == 0) {
            selectedExercises.add(_exercises[i]);
          }
        }
      }
    }

    if (widget.isReplaceActive && selectedExercises.isNotEmpty) {
      for (int i = 0; i < selectedExercises.length; i++) {
        if ((workoutExercises.contains(selectedExercises[i]) &&
            !selectedExercises[i].compare(exerciseToReplace) &&
            !selectedExercises[i].compare(widget.workout.exerciseToReplace))) {
          selectedExercises.remove(selectedExercises[i]);
        }
      }
    }

    // Sort Exercise by Name, then by Equipment
    selectedExercises.sort((Exercise a, Exercise b) {
      int cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (cmp != 0) return cmp;
      return a.equipment.toLowerCase().compareTo(b.equipment.toLowerCase());
    });

    if (selectedExercises.isNotEmpty) {
      String letter = "";

      selectedExercises.forEach((Exercise exercise) {
        String exerciseLetter = exercise.name.substring(0, 1).toUpperCase();
        if (letter != exerciseLetter) {
          letter = exerciseLetter;

          filtered.add(exerciseLetter);
        }

        filtered.add(exercise);
      });
    }

    setState(() {
      _filteredExercises = filtered;
    });

    Future.delayed(
      Duration(seconds: 0),
      () => filter.updateExerciseCount(selectedExercises.length),
    );
  }

  SliverAppBar defaultAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.grey[50],
      floating: true,
      pinned: true,
      leading: widget.isSelectActive
          ? IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            )
          : null,
      title: Text(
        'Exercises',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              isSearchActive = true;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ExerciseFilterPage(),
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
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (selection) => {
                if (selection == 'create')
                  {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) =>
                            ExerciseAddPage(updateUserExercises),
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
      ],
    );
  }

  SliverAppBar searchAppBar(ExerciseFilter filter) {
    return SliverAppBar(
      backgroundColor: Colors.grey[50],
      floating: true,
      pinned: true,
      title: TextField(
        controller: searchController,
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
          filter.updateSearchValue(query);
        },
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            isSearchActive = false;
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.close_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            searchController.text = "";
            filter.updateSearchValue("");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ExerciseFilterPage(),
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
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (selection) => {
                if (selection == 'create')
                  {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) =>
                            ExerciseAddPage(updateUserExercises),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter filter = Provider.of<ExerciseFilter>(context) ?? null;

    bool filterRequired = false;

    if (filter != null) {
      if (initialLoad) {
        Future.delayed(Duration(seconds: 0), () => filter.clearAllFilters());

        initialLoad = false;
        filterRequired = true;
      }

      if (forceFilter) {
        forceFilter = false;
        filterRequired = true;
      }

      if (searchValue != filter.searchValue) {
        searchValue = filter.searchValue;
        filterRequired = true;
      }

      if (isUserCreated != filter.isUserCreated) {
        isUserCreated = filter.isUserCreated;
        filterRequired = true;
      }

      if (!listEquals(
        selectedCategories,
        filter.selectedCategories,
      )) {
        selectedCategories = List.of(filter.selectedCategories);
        filterRequired = true;
      }

      if (!listEquals(selectedEquipment, filter.selectedEquipment)) {
        selectedEquipment = List.of(filter.selectedEquipment);
        filterRequired = true;
      }

      if (filterRequired) {
        filterExercises(filter);
      }
    }

    return filter == null
        ? Loader()
        : Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                isSearchActive ? searchAppBar(filter) : defaultAppBar(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      if (_filteredExercises[i] is Exercise) {
                        Exercise _exercise = _filteredExercises[i] as Exercise;

                        String name = _exercise.name;

                        if (_exercise.equipment != "") {
                          name += ' (${_exercise.equipment})';
                        }

                        String category = _exercise.category;
                        bool isUserCreated =
                            _exercise.isUserCreated == 0 ? false : true;

                        TextStyle style;

                        if (widget.isReplaceActive) {
                          if (_exercise.compare(exerciseToReplace)) {
                            style =
                                TextStyle(color: Theme.of(context).accentColor);
                          }
                        } else if (workoutExercises.isNotEmpty) {
                          for (int j = 0; j < workoutExercises.length; j++) {
                            if (workoutExercises[j].compare(_exercise)) {
                              style = TextStyle(
                                  color: Theme.of(context).accentColor);
                              break;
                            }
                          }
                        }

                        return ListTile(
                          title: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: style,
                          ),
                          subtitle: Text(
                            category == "" ? "None" : category,
                            overflow: TextOverflow.ellipsis,
                            style: style,
                          ),
                          trailing: !widget.isSelectActive && isUserCreated
                              ? IconButton(
                                  icon: Icon(Icons.delete, color: Colors.black),
                                  onPressed: () async {
                                    await showPopupDeleteExercise(
                                      context,
                                      _filteredExercises[i].id,
                                      name,
                                      updateUserExercises,
                                    );
                                  },
                                )
                              : null,
                          onTap: widget.isSelectActive
                              ? () {
                                  if (widget.isReplaceActive) {
                                    setState(() {
                                      exerciseToReplace = _exercise;
                                      forceFilter = true;
                                    });
                                  } else {
                                    int foundIndex = -1;

                                    for (int j = 0;
                                        j < workoutExercises.length;
                                        j++) {
                                      if (workoutExercises[j]
                                          .compare(_exercise)) {
                                        foundIndex = j;
                                        break;
                                      }
                                    }

                                    if (foundIndex != -1) {
                                      workoutExercises.removeAt(foundIndex);
                                    } else {
                                      workoutExercises.add(_exercise.clone());
                                    }

                                    setState(() {
                                      workoutExercises =
                                          List.of(workoutExercises);
                                    });
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
                            _filteredExercises[i],
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                    childCount: _filteredExercises.length,
                  ),
                ),
              ],
            ),
            floatingActionButton: widget.isReplaceActive &&
                    !exerciseToReplace.compare(widget.workout.exerciseToReplace)
                ? FloatingActionButton(
                    child: Icon(Icons.check),
                    onPressed: () {
                      widget.workout.replaceExercise(exerciseToReplace);
                      tryPopContext(context);
                    },
                  )
                : widget.isSelectActive &&
                        workoutExercises.isNotEmpty &&
                        !widget.isReplaceActive
                    ? FloatingActionButton(
                        child: Icon(Icons.check),
                        onPressed: () {
                          widget.workout.updateExercises(workoutExercises);
                          tryPopContext(context);
                        },
                      )
                    : null,
          );
  }
}
