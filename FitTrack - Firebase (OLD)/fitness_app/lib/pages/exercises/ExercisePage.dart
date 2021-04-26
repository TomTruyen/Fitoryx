import 'dart:ui';

import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/exercises/Exercise.dart';
import 'package:fitness_app/models/exercises/ExerciseCategory.dart';
import 'package:fitness_app/models/exercises/ExerciseEquipment.dart';
import 'package:fitness_app/models/exercises/ExerciseFilter.dart';
import 'package:fitness_app/models/exercises/ExerciseType.dart';
import 'package:fitness_app/models/exercises/UserExercise.dart';
import 'package:fitness_app/models/workout/WorkoutChangeNotifier.dart';
import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/models/workout/WorkoutExerciseSet.dart';
import 'package:fitness_app/pages/exercises/ExerciseAddPage.dart';
import 'package:fitness_app/pages/exercises/ExerciseFilterPage.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  final bool selectActive;
  final bool replaceExercise;
  final int replaceIndex;

  ExercisePage({
    this.selectActive = false,
    this.replaceExercise = false,
    this.replaceIndex = -1,
  });

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  // Divider Letter
  String currentLetter;

  // Replace Exercise
  WorkoutExercise exerciseToReplace;
  bool exerciseReplaced = false;

  // Search Variables
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  // Exercises Variables
  List<dynamic> exercises = [];
  List<dynamic> filteredExercises = [];

  // Categories Variables
  List<ExerciseCategory> categories = [];
  List<ExerciseCategory> selectedCategories = [];

  // Equipments Variables
  List<ExerciseEquipment> equipment = [];
  List<ExerciseEquipment> selectedEquipment = [];

  // Types Variabels
  List<ExerciseType> selectedTypes = [];

  bool _exerciseLoaded = false;

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // Sort Exercises By Name
  List<dynamic> _sortExercisesByName(List<dynamic> exerciseList) {
    exerciseList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return exerciseList;
  }

  // Filter Exercises
  void filterExercises(ExerciseFilter exerciseFilter) async {
    // Loop Through Categories 'selectedCategories'
    List<dynamic> categoryList = [];
    if (selectedCategories.length > 0) {
      for (int i = 0; i < exercises.length; i++) {
        for (int j = 0; j < selectedCategories.length; j++) {
          if (exercises[i].category.toLowerCase() ==
              selectedCategories[j].name.toLowerCase()) {
            if (searchQuery != "") {
              if (exercises[i]
                  .name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase())) {
                categoryList.add(exercises[i]);
              }
            } else {
              categoryList.add(exercises[i]);
            }
          }
        }
      }
    }

    // Loop Through Equipments 'selectedEquipments'
    List<dynamic> equipmentList = [];
    if (selectedEquipment.length > 0) {
      for (int i = 0; i < exercises.length; i++) {
        for (int j = 0; j < selectedEquipment.length; j++) {
          if (selectedEquipment[j].name.toLowerCase() != "other") {
            if (exercises[i].equipment.toLowerCase() ==
                selectedEquipment[j].name.toLowerCase()) {
              if (searchQuery != "") {
                if (exercises[i]
                    .name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())) {
                  {
                    equipmentList.add(exercises[i]);
                  }
                }
              } else {
                equipmentList.add(exercises[i]);
              }
            }
          } else {
            if (exercises[i].equipment == "") {
              if (searchQuery != "" &&
                  exercises[i]
                      .name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())) {
                equipmentList.add(exercises[i]);
              } else {
                equipmentList.add(exercises[i]);
              }
            }
          }
        }
      }
    }

    List<dynamic> filtered = [];

    if (selectedCategories.length == 0 &&
        selectedEquipment.length == 0 &&
        searchQuery != "") {
      for (int i = 0; i < exercises.length; i++) {
        if (exercises[i]
            .name
            .toLowerCase()
            .contains(searchQuery.toLowerCase())) {
          filtered.add(exercises[i]);
        }
      }
    }

    if (filtered.length == 0 && searchQuery == "") {
      if (selectedEquipment.length > 0 && selectedCategories.length > 0) {
        filtered = [...equipmentList.where(categoryList.contains)];
      } else if (selectedEquipment.length > 0) {
        filtered = [...equipmentList];
      } else if (selectedCategories.length > 0) {
        filtered = [...categoryList];
      } else {
        filtered = [...exercises];
      }
    }

    filtered = _sortExercisesByName(filtered);

    List<dynamic> _filteredExercises = [];

    for (int i = 0; i < filtered.length; i++) {
      if (selectedTypes.contains(ExerciseType.custom) &&
          !selectedTypes.contains(ExerciseType.preset)) {
        if (filtered[i] is UserExercise) {
          _filteredExercises.add(filtered[i]);
        }
      } else if (!selectedTypes.contains(ExerciseType.custom) &&
          selectedTypes.contains(ExerciseType.preset)) {
        if (filtered[i] is Exercise) {
          _filteredExercises.add(filtered[i]);
        }
      } else {
        _filteredExercises = [...filtered];
        break;
      }
    }

    int letterDividerCount = 0;

    if (_filteredExercises.length > 0) {
      String lastLetter = "";
      for (int i = 0; i < _filteredExercises.length; i++) {
        if (_filteredExercises[i] is Exercise) {
          if ((_filteredExercises[i] as Exercise)
                  .name
                  .substring(0, 1)
                  .toUpperCase() !=
              lastLetter) {
            lastLetter = (_filteredExercises[i] as Exercise)
                .name
                .substring(0, 1)
                .toUpperCase();

            _filteredExercises.insert(i, lastLetter);
            letterDividerCount++;
          }
        } else if (_filteredExercises[i] is UserExercise) {
          if ((_filteredExercises[i] as UserExercise)
                  .name
                  .substring(0, 1)
                  .toUpperCase() !=
              lastLetter) {
            lastLetter = (_filteredExercises[i] as UserExercise)
                .name
                .substring(0, 1)
                .toUpperCase();

            _filteredExercises.insert(i, lastLetter);
            letterDividerCount++;
          }
        }
      }
    }

    setState(() {
      filteredExercises = _filteredExercises;
    });

    // Hack to fix 'setstate() or markneedsbuild()' error
    await Future.delayed(const Duration(milliseconds: 0), () {
      exerciseFilter.updateExerciseCount(
        _filteredExercises.length - letterDividerCount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Providers
    final List<Exercise> dbExercises =
        Provider.of<List<Exercise>>(context) ?? [];
    final List<UserExercise> dbUserExercises =
        Provider.of<List<UserExercise>>(context) ?? [];
    final List<ExerciseCategory> dbExerciseCategories =
        Provider.of<List<ExerciseCategory>>(context) ?? [];
    final List<ExerciseEquipment> dbExerciseEquipment =
        Provider.of<List<ExerciseEquipment>>(context) ?? [];
    final ExerciseFilter exerciseFilter =
        Provider.of<ExerciseFilter>(context) ?? ExerciseFilter();
    final WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;
    final User user = Provider.of<User>(context) ?? null;

    // Popup Delete UserExercise
    Future<void> _showPopupDeleteExercise(
        User user, UserExercise exercise) async {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 250.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.80,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[50],
                    border: Border.all(
                      width: 0,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                  child: SingleChildScrollView(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Color.fromRGBO(70, 70, 70, 1),
                        unselectedWidgetColor: Color.fromRGBO(
                          200,
                          200,
                          200,
                          1,
                        ),
                      ),
                      child: Material(
                        color: Colors.grey[50],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Delete "${exercise.name}"?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Are you sure you want to delete your exercise?',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      popContextWhenPossible(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();

                                      final loadingSnackbar = SnackBar(
                                        elevation: 8.0,
                                        backgroundColor: Colors.orange[400],
                                        content: Text(
                                          'Deleting...',
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(minutes: 1),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(loadingSnackbar);

                                      dynamic result = await DatabaseService(
                                              uid: user != null ? user.uid : "")
                                          .deleteUserExercise(exercise.id);

                                      await Future.delayed(
                                        Duration(milliseconds: 500),
                                        () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      );

                                      if (result != null) {
                                        final successSnackbar = SnackBar(
                                          duration: Duration(seconds: 1),
                                          elevation: 8.0,
                                          backgroundColor: Colors.green[400],
                                          content: GestureDetector(
                                            child: Text(
                                              'Deleted',
                                              textAlign: TextAlign.center,
                                            ),
                                            onTap: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(successSnackbar);
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();
                                        popContextWhenPossible(context);
                                      } else {
                                        final failureSnackbar = SnackBar(
                                          duration: Duration(seconds: 1),
                                          elevation: 8.0,
                                          backgroundColor: Colors.red[400],
                                          content: GestureDetector(
                                            child: Text(
                                              'Deleting Failed',
                                              textAlign: TextAlign.center,
                                            ),
                                            onTap: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(failureSnackbar);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    bool filterRequired = false;

    // Exercise Replace set Values
    if (workout != null && widget.replaceExercise && !exerciseReplaced) {
      exerciseToReplace = workout.exercises[widget.replaceIndex];
    }

    // Check SelectedCategories from ExerciseFilter
    if (exerciseFilter.selectedCategories != null &&
        !listEquals(selectedCategories, exerciseFilter.selectedCategories)) {
      selectedCategories = [...exerciseFilter.selectedCategories];
      filterRequired = true;
    }

    // Check SelectedEquipment from ExerciseFilter
    if (exerciseFilter.selectedEquipment != null &&
        !listEquals(selectedEquipment, exerciseFilter.selectedEquipment)) {
      selectedEquipment = [...exerciseFilter.selectedEquipment];
      filterRequired = true;
    }

    // Check SelectedTypes from ExerciseFilter
    if (exerciseFilter.selectedTypes != null &&
        !listEquals(selectedTypes, exerciseFilter.selectedTypes)) {
      selectedTypes = [...exerciseFilter.selectedTypes];
      filterRequired = true;
    }

    // Check if SearchQuery has a value
    if (exerciseFilter.searchQuery != searchQuery) {
      searchQuery = exerciseFilter.searchQuery;
      filterRequired = true;
    }

    // Exercises
    if (dbExercises.length > 0) {
      List<dynamic> allExercises = _sortExercisesByName([...dbExercises]);

      if (dbUserExercises.length > 0) {
        allExercises =
            _sortExercisesByName([...dbExercises, ...dbUserExercises]);
      }

      if (allExercises.length != exercises.length) {
        exercises = allExercises;
        if (filteredExercises.length == 0) {
          filteredExercises = allExercises;
        }

        filterRequired = true;
      }

      if (allExercises.length > 0 && !_exerciseLoaded) {
        if (exerciseFilter.searchQuery != "" ||
            exerciseFilter.selectedCategories.length > 0 ||
            exerciseFilter.selectedEquipment.length > 0) {
          exerciseFilter.searchQuery = "";
          exerciseFilter.selectedCategories = [];
          exerciseFilter.selectedEquipment = [];
        }

        Future.delayed(
          Duration(milliseconds: 500),
          () => {
            setState(() {
              _exerciseLoaded = true;
            })
          },
        );
      }
    }

    // ExerciseCategories
    if (dbExerciseCategories.length > 0) {
      categories = dbExerciseCategories;
    }

    // ExerciseEquipment
    if (dbExerciseEquipment.length > 0) {
      equipment = dbExerciseEquipment;
    }

    if (filterRequired) {
      filterExercises(exerciseFilter);
    }

    // Search Field Widget
    Widget _buildSearchField() {
      return TextField(
        controller: _searchQueryController,
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
        _searchQueryController.clear();
      });
    }

    // Hide Search
    void _stopSearching() {
      _clearSearchQuery();

      setState(() {
        _isSearching = false;
      });
    }

    // Show Search
    void _startSearch() {
      ModalRoute.of(context)
          .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

      setState(() {
        _isSearching = true;
      });
    }

    // Appbar Actions Widgets
    List<Widget> _buildActions() {
      if (_isSearching) {
        return <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (_searchQueryController == null ||
                  _searchQueryController.text.isEmpty) {
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
                  builder: (context) => ExerciseFilterPage(
                    categories: categories,
                    equipment: equipment,
                  ),
                ),
              );
            },
          ),
          if (!widget.selectActive)
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseAddPage(),
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
                builder: (context) => ExerciseFilterPage(
                  categories: categories,
                  equipment: equipment,
                ),
              ),
            );
          },
        ),
        if (!widget.selectActive)
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
                        builder: (context) => ExerciseAddPage(),
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

    return Scaffold(
      body: _exerciseLoaded
          ? ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight:
                        _isSearching || widget.selectActive ? 50.0 : 120.0,
                    forceElevated:
                        _isSearching || widget.selectActive ? true : false,
                    floating: false,
                    pinned: true,
                    flexibleSpace: !_isSearching && !widget.selectActive
                        ? FlexibleSpaceBar(
                            titlePadding: EdgeInsets.all(16.0),
                            title: Text('Exercises'),
                          )
                        : null,
                    leading: widget.selectActive
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              workout.setBackupAsExercises();
                              if (widget.replaceExercise &&
                                  exerciseToReplace != null) {
                                workout.exercises[widget.replaceIndex] =
                                    exerciseToReplace;
                              }

                              popContextWhenPossible(context);
                            },
                          )
                        : null,
                    title: _isSearching
                        ? _buildSearchField()
                        : widget.selectActive
                            ? Text('Exercises')
                            : null,
                    actions: _buildActions(),
                  ),
                  SliverList(
                    delegate: (SliverChildBuilderDelegate(
                      (context, index) {
                        if (filteredExercises[index] is Exercise ||
                            filteredExercises[index] is UserExercise) {
                          if (filteredExercises[index] is Exercise) {
                            filteredExercises[index] =
                                filteredExercises[index] as Exercise;
                          } else {
                            filteredExercises[index] =
                                filteredExercises[index] as UserExercise;
                          }

                          int foundIndex = -1;

                          for (int i = 0; i < workout.exercises.length; i++) {
                            if (filteredExercises[index] is Exercise) {
                              if (workout.exercises[i].name.toLowerCase() ==
                                      (filteredExercises[index] as Exercise)
                                          .name
                                          .toLowerCase() &&
                                  workout.exercises[i].category.toLowerCase() ==
                                      (filteredExercises[index] as Exercise)
                                          .category
                                          .toLowerCase() &&
                                  workout.exercises[i].equipment
                                          .toLowerCase() ==
                                      (filteredExercises[index] as Exercise)
                                          .equipment
                                          .toLowerCase()) {
                                foundIndex = i;
                                break;
                              }
                            } else if (filteredExercises[index]
                                is UserExercise) {
                              if (workout.exercises[i].name.toLowerCase() ==
                                      (filteredExercises[index] as UserExercise)
                                          .name
                                          .toLowerCase() &&
                                  workout.exercises[i].category.toLowerCase() ==
                                      (filteredExercises[index] as UserExercise)
                                          .category
                                          .toLowerCase() &&
                                  workout.exercises[i].equipment
                                          .toLowerCase() ==
                                      (filteredExercises[index] as UserExercise)
                                          .equipment
                                          .toLowerCase()) {
                                foundIndex = i;
                                break;
                              }
                            }
                          }

                          if (widget.replaceExercise) {
                            return ListTile(
                              title: Text(
                                filteredExercises[index].equipment == ""
                                    ? filteredExercises[index].name
                                    : "${filteredExercises[index].name} (${filteredExercises[index].equipment})",
                                overflow: TextOverflow.ellipsis,
                                style: widget.selectActive && foundIndex != -1
                                    ? Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          color: Theme.of(context).accentColor,
                                        )
                                    : Theme.of(context).textTheme.subtitle1,
                              ),
                              subtitle: Text(
                                filteredExercises[index].category,
                                style: widget.selectActive && foundIndex != -1
                                    ? Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Theme.of(context).accentColor,
                                        )
                                    : Theme.of(context).textTheme.caption,
                              ),
                              trailing: !widget.selectActive &&
                                      !widget.replaceExercise &&
                                      filteredExercises[index] is UserExercise
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        _showPopupDeleteExercise(
                                          user,
                                          filteredExercises[index],
                                        );
                                      },
                                    )
                                  : null,
                              onTap: () {
                                if (widget.selectActive &&
                                    widget.replaceExercise) {
                                  workout.setExercise(
                                    WorkoutExercise(
                                      name: filteredExercises[index].name,
                                      category:
                                          filteredExercises[index].category,
                                      equipment:
                                          filteredExercises[index].equipment,
                                      sets: [WorkoutExerciseSet()],
                                    ),
                                    widget.replaceIndex,
                                  );

                                  if (!exerciseReplaced) {
                                    exerciseReplaced = true;
                                  }
                                }
                              },
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                filteredExercises[index].equipment == ""
                                    ? filteredExercises[index].name
                                    : "${filteredExercises[index].name} (${filteredExercises[index].equipment})",
                                overflow: TextOverflow.ellipsis,
                                style: widget.selectActive && foundIndex != -1
                                    ? Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          color: Theme.of(context).accentColor,
                                        )
                                    : Theme.of(context).textTheme.subtitle1,
                              ),
                              subtitle: Text(
                                filteredExercises[index].category,
                                style: widget.selectActive && foundIndex != -1
                                    ? Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Theme.of(context).accentColor,
                                        )
                                    : Theme.of(context).textTheme.caption,
                              ),
                              trailing: !widget.selectActive &&
                                      !widget.replaceExercise &&
                                      filteredExercises[index] is UserExercise
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        _showPopupDeleteExercise(
                                          user,
                                          filteredExercises[index],
                                        );
                                      },
                                    )
                                  : null,
                              onTap: widget.selectActive
                                  ? () {
                                      if (widget.selectActive &&
                                          workout != null) {
                                        if (foundIndex == -1) {
                                          workout.addExercise(
                                            WorkoutExercise(
                                              name:
                                                  filteredExercises[index].name,
                                              category: filteredExercises[index]
                                                  .category,
                                              equipment:
                                                  filteredExercises[index]
                                                      .equipment,
                                              sets: [WorkoutExerciseSet()],
                                            ),
                                          );
                                        } else {
                                          workout.removeExercise(
                                              workout.exercises[foundIndex]);
                                        }
                                      }
                                    }
                                  : null,
                            );
                          }
                        } else {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 30.0,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              filteredExercises[index],
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      },
                      childCount: filteredExercises.length,
                    )),
                  ),
                ],
              ),
            )
          : Loading(),
      floatingActionButton: (widget.selectActive &&
                  workout.exercises.length > 0 &&
                  !widget.replaceExercise) ||
              exerciseReplaced
          ? FloatingActionButton(
              child: Icon(
                Icons.check,
              ),
              onPressed: () {
                popContextWhenPossible(context);
              },
            )
          : null,
    );
  }
}
