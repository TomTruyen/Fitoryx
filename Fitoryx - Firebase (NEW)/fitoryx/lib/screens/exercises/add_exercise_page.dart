import 'package:fitoryx/data/category_list.dart' as default_categories;
import 'package:fitoryx/data/equipment_list.dart' as default_equipment;
import 'package:fitoryx/data/type_list.dart' as default_types;
import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/dropdown.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:flutter/material.dart';

class AddExercisePage extends StatefulWidget {
  final Function(Exercise) addExercise;

  const AddExercisePage({Key? key, required this.addExercise})
      : super(key: key);

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _firestoreService = FirestoreService();
  final _addExerciseFormKey = GlobalKey<FormState>();
  final Exercise _exercise = Exercise();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              leading: const CloseButton(),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    if (_addExerciseFormKey.currentState != null &&
                        _addExerciseFormKey.currentState!.validate()) {
                      try {
                        Exercise exercise =
                            await _firestoreService.saveExercise(
                          _exercise,
                        );

                        widget.addExercise(exercise);

                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        showAlert(
                          context,
                          content: "Failed to add exercise. Please try again.",
                        );
                      }
                    }
                  },
                ),
              ],
              title: const Text('New Exercise'),
            ),
            SliverFillRemaining(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _addExerciseFormKey,
                  child: Column(
                    children: <Widget>[
                      FormInput(
                        hintText: 'Name',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Exercise name is required';
                          }

                          return null;
                        },
                        onChanged: (String value) {
                          _exercise.name = value.trim();
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Dropdown(
                        title: 'Category',
                        selectedValue: _exercise.category,
                        options: default_categories.categories,
                        onSelect: (String category) {
                          setState(() => _exercise.category = category);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Dropdown(
                        title: 'Equipment',
                        selectedValue: _exercise.equipment,
                        options: default_equipment.equipment,
                        onSelect: (String equipment) {
                          setState(() => _exercise.equipment = equipment);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Dropdown(
                        title: 'Type',
                        selectedValue:
                            ExerciseTypeHelper.toValue(_exercise.type),
                        options: default_types.types,
                        onSelect: (String type) {
                          setState(
                            () => _exercise.type =
                                ExerciseTypeHelper.fromValue(type),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
