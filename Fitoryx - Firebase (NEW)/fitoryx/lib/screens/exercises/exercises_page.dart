import 'package:fitoryx/data/exercise_list.dart' as default_exercises;
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/screens/exercises/add_exercise_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/exercise_divider.dart';
import 'package:fitoryx/widgets/exercise_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExercisesPages extends StatefulWidget {
  const ExercisesPages({Key? key}) : super(key: key);

  @override
  State<ExercisesPages> createState() => _ExercisesPagesState();
}

class _ExercisesPagesState extends State<ExercisesPages> {
  final _firestoreService = FirestoreService();
  List<Exercise> _exercises = [];
  List<dynamic> _exercisesWithDividers = [];

  @override
  void initState() {
    super.initState();
    _exercises = List.of(default_exercises.exercises);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
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
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () => _navigateAddExercise(),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int i) {
                var item = _exercisesWithDividers[i];

                return item is Exercise
                    ? ExerciseItem(exercise: item)
                    : ExerciseDivider(text: item);
              },
              childCount: _exercisesWithDividers.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    List<Exercise> userExercises = await _firestoreService.getExercises();
    _exercises.addAll(userExercises);

    _updateExercisesWithDividers();
  }

  void _addExercise(Exercise exercise) {
    _exercises.add(exercise);
    _updateExercisesWithDividers();
  }

  void _updateExercisesWithDividers() {
    setState(() {
      _exercisesWithDividers = addListDividers(_exercises);
    });
  }

  void _navigateAddExercise() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddExercisePage(addExercise: _addExercise),
      ),
    );
  }
}
