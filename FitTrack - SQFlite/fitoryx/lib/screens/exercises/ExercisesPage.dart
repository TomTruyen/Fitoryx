import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/exercises/Exercise.dart';
import 'package:Fitoryx/models/exercises/ExerciseFilter.dart';
import 'package:Fitoryx/models/workout/WorkoutChangeNotifier.dart';
import 'package:Fitoryx/screens/exercises/ExerciseAddPage.dart';
import 'package:Fitoryx/screens/exercises/ExerciseFilterPage.dart';
import 'package:Fitoryx/screens/exercises/popups/DeleteExercisePopup.dart';
import 'package:Fitoryx/shared/ExerciseList.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
import 'package:Fitoryx/shared/GradientFloatingActionButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    await globals.sqlDatabase.fetchUserExercises();

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

  Future<void> filterExercises(
    ExerciseFilter filter,
    List<Exercise> userExercises,
    List<Exercise> workoutExercises,
    bool isReplaceActive,
    Exercise exerciseToReplace,
    Exercise workoutExerciseToReplace,
  ) async {
    Map<String, dynamic> filteredExercisesMap = getFilteredExercises(
      filter,
      exercises,
      userExercises,
      workoutExercises,
      isReplaceActive,
      exerciseToReplace,
      workoutExerciseToReplace,
    );

    List<dynamic> filteredExercises = filteredExercisesMap['exercises'];
    int exerciseLength = filteredExercisesMap['exercisesLength'];

    if (!listEquals(filteredExercises, _filteredExercises)) {
      setState(() {
        _filteredExercises = filteredExercises;
      });

      await Future.delayed(
        Duration(seconds: 0),
        () {
          filter.updateExerciseCount(exerciseLength);
        },
      );
    }
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
        globals.getDonationButton(context),
        if (!widget.isSelectActive)
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Color.fromRGBO(35, 35, 35, 1),
              dividerColor: Color.fromRGBO(70, 70, 70, 1),
            ),
            child: PopupMenuButton(
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
          suffixIcon: GestureDetector(
            child: Icon(
              Icons.close_outlined,
              color: Colors.black,
            ),
            onTap: () {
              searchController.text = "";
              filter.updateSearchValue("");
            },
          ),
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
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            clearFocus(context);

            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ExerciseFilterPage(),
              ),
            );
          },
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
        filterExercises(
          filter,
          globals.sqlDatabase.userExercises,
          workoutExercises,
          widget.isReplaceActive,
          exerciseToReplace,
          widget.workout?.exerciseToReplace,
        );
      }
    }

    return Scaffold(
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
                  TextStyle subtitle = Theme.of(context).textTheme.subtitle2;

                  bool isSelected = false;

                  if (widget.isReplaceActive) {
                    if (_exercise.compare(exerciseToReplace)) {
                      isSelected = true;
                    }
                  } else if (workoutExercises.isNotEmpty) {
                    for (int j = 0; j < workoutExercises.length; j++) {
                      if (workoutExercises[j].compare(_exercise)) {
                        isSelected = true;

                        break;
                      }
                    }
                  }

                  return ListTile(
                    title: Text(
                      name,
                      style: isSelected
                          ? TextStyle(
                              fontSize: 16.0,
                              color: Colors.blue[700],
                            )
                          : style,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      category == "" ? "None" : category,
                      style: isSelected
                          ? subtitle.copyWith(
                              color: Colors.blue[700],
                            )
                          : subtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: !widget.isSelectActive && isUserCreated
                        ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () async {
                              clearFocus(context);

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
                                if (workoutExercises[j].compare(_exercise)) {
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
                                workoutExercises = List.of(workoutExercises);
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
          ? GradientFloatingActionButton(
              icon: Icon(Icons.check),
              onPressed: () {
                widget.workout.replaceExercise(exerciseToReplace);
                tryPopContext(context);
              },
            )
          : widget.isSelectActive &&
                  workoutExercises.isNotEmpty &&
                  !widget.isReplaceActive
              ? GradientFloatingActionButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    widget.workout.updateExercises(workoutExercises);
                    tryPopContext(context);
                  },
                )
              : null,
    );
  }
}
