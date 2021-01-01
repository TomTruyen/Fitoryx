import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/screens/exercises/ExerciseFilterPage.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/shared/ExerciseList.dart';
import 'package:fittrack/shared/Loader.dart';

class ExercisesPage extends StatefulWidget {
  final bool isSelectActive;

  ExercisesPage({this.isSelectActive = false});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  // Variables used to limit the amount of times the filterExercise function gets called
  bool filterLoaded = false;
  int isUserCreated;
  String searchValue;
  List<String> selectedCategories;
  List<String> selectedEquipment;

  // Variables
  List<dynamic> _filteredExercises;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  void filterExercises(ExerciseFilter filter) {
    List<dynamic> filtered = [];

    List<Exercise> _exercises = List.of(exercises);
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
        if (_exercises[i].isUserCreated == isUserCreated &&
            _exercises[i]
                .name
                .toLowerCase()
                .contains(searchValue.toLowerCase())) {
          selectedExercises.add(_exercises[i]);
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
              MaterialPageRoute(
                builder: (BuildContext context) => ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectActive)
          IconButton(
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
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
              MaterialPageRoute(
                builder: (BuildContext context) => ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectActive)
          IconButton(
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter filter = Provider.of<ExerciseFilter>(context) ?? null;

    bool filterRequired = false;

    if (filter != null) {
      if (!filterLoaded) {
        filterLoaded = true;
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
        print("FILTER");
        filterExercises(filter);
      }
    }

    return filter == null
        ? Loader()
        : CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              isSearchActive ? searchAppBar(filter) : defaultAppBar(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                    if (_filteredExercises[i] is Exercise) {
                      String name = _filteredExercises[i].name;

                      if (_filteredExercises[i].equipment != "") {
                        name += ' (${_filteredExercises[i].equipment})';
                      }

                      String category = _filteredExercises[i].category;

                      return ListTile(
                        title: Text(name, overflow: TextOverflow.ellipsis),
                        subtitle:
                            Text(category, overflow: TextOverflow.ellipsis),
                        onTap: widget.isSelectActive
                            ? () {
                                print("Tapped Widget Number: $i");
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
          );
  }
}
