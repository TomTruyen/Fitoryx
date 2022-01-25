import 'package:fitoryx/data/exercise_list.dart' as default_exercises;
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/exercise_divider.dart';
import 'package:fitoryx/widgets/exercise_item.dart';
import 'package:flutter/material.dart';

class ExercisesPages extends StatefulWidget {
  const ExercisesPages({Key? key}) : super(key: key);

  @override
  State<ExercisesPages> createState() => _ExercisesPagesState();
}

class _ExercisesPagesState extends State<ExercisesPages> {
  List<dynamic> _exercisesWithDividers = [];

  @override
  void initState() {
    super.initState();
    _exercisesWithDividers = addListDividers(default_exercises.exercises);
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
}
