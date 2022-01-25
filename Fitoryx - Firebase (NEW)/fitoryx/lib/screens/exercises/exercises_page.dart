import 'package:fitoryx/data/exercise_list.dart' as default_exercises;
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/screens/exercises/add_exercise_page.dart';
import 'package:fitoryx/screens/exercises/exercise_filter_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/exercise_divider.dart';
import 'package:fitoryx/widgets/exercise_item.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisesPages extends StatefulWidget {
  const ExercisesPages({Key? key}) : super(key: key);

  @override
  State<ExercisesPages> createState() => _ExercisesPagesState();
}

class _ExercisesPagesState extends State<ExercisesPages> {
  final _firestoreService = FirestoreService();
  bool hideSearch = true;
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> _filtered = [];
  List<Exercise> _exercises = [];
  List<dynamic> _exercisesWithDividers = [];

  @override
  void initState() {
    super.initState();
    _exercises = List.of(default_exercises.exercises);
    // _init();
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
          FutureBuilder<bool>(
            future: _init(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      var item = _exercisesWithDividers[i];

                      return item is Exercise
                          ? ExerciseItem(
                              exercise: item,
                              deleteExercise: _deleteExercise,
                            )
                          : ExerciseDivider(text: item);
                    },
                    childCount: _exercisesWithDividers.length,
                  ),
                );
              }

              return const SliverFillRemaining(child: Loader());
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _init() async {
    List<Exercise> userExercises = await _firestoreService.getExercises();
    _exercises.addAll(userExercises);

    _updateExercisesWithDividers();

    return true;
  }

  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(exercise);
    });
  }

  void _deleteExercise(String? id) {
    if (id != null) {
      setState(() {
        _exercises.removeWhere((exercise) => exercise.id == id);
      });
    }
  }

  void _filterExercises(ExerciseFilter filter) {
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

      return true;
    }).toList();

    _updateExercisesWithDividers();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      filter.setCount(_filtered.length);
    });
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
}
