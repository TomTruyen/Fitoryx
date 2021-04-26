import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/exercises/ExerciseCategory.dart';
import 'package:fitness_app/models/exercises/ExerciseEquipment.dart';
import 'package:fitness_app/models/exercises/ExerciseFilter.dart';
import 'package:fitness_app/models/exercises/ExerciseType.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseFilterPage extends StatefulWidget {
  final List<ExerciseCategory> categories;
  final List<ExerciseEquipment> equipment;

  ExerciseFilterPage({this.categories, this.equipment});

  @override
  _ExerciseFilterPageState createState() => _ExerciseFilterPageState();
}

class _ExerciseFilterPageState extends State<ExerciseFilterPage> {
  // Filter Category Items
  List<Widget> _buildFilterCategories(ExerciseFilter exerciseFilter) {
    List<Widget> filterCategories = [];

    for (int i = 0; i < widget.categories.length; i++) {
      bool selected = false;

      for (int j = 0; j < exerciseFilter.selectedCategories.length; j++) {
        if (widget.categories[i].name.toLowerCase() ==
            exerciseFilter.selectedCategories[j].name.toLowerCase()) {
          selected = true;
          break;
        }
      }

      filterCategories.add(
        InkWell(
          child: FilterWidget(
            muscleGroup: widget.categories[i].name,
            selected: selected,
          ),
          onTap: () {
            if (selected) {
              exerciseFilter.removeSelectedCategory(widget.categories[i]);
            } else {
              exerciseFilter.addSelectedCategory(widget.categories[i]);
            }
          },
        ),
      );
    }

    return filterCategories;
  }

  // Filter Equipment Categories
  List<Widget> _buildFilterEquipment(ExerciseFilter exerciseFilter) {
    List<Widget> filterEquipment = [];

    for (int i = 0; i < widget.equipment.length; i++) {
      filterEquipment.add(
        InkWell(
          child: FilterWidget(
            muscleGroup: widget.equipment[i].name,
            selected:
                exerciseFilter.selectedEquipment.contains(widget.equipment[i]),
          ),
          onTap: () {
            if (exerciseFilter.selectedEquipment
                .contains(widget.equipment[i])) {
              exerciseFilter.removeSelectedEquipment(widget.equipment[i]);
            } else {
              exerciseFilter.addSelectedEquipment(widget.equipment[i]);
            }
          },
        ),
      );
    }

    return filterEquipment;
  }

  List<Widget> _buildExerciseType(ExerciseFilter exerciseFilter) {
    List<Widget> exerciseTypes = [];

    ExerciseType.values.forEach(
      (type) {
        exerciseTypes.add(
          InkWell(
            child: FilterWidget(
              muscleGroup: type == ExerciseType.custom ? 'Custom' : 'Default',
              selected: exerciseFilter.selectedTypes.contains(type),
            ),
            onTap: () {
              if (exerciseFilter.selectedTypes.contains(type)) {
                exerciseFilter.removeExerciseType(type);
              } else {
                exerciseFilter.addExerciseType(type);
              }
            },
          ),
        );
      },
    );

    return exerciseTypes;
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter exerciseFilter = Provider.of<ExerciseFilter>(context);
    final int selectedExerciseCounter = exerciseFilter.exerciseCount;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  popContextWhenPossible(context);
                },
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Filter ($selectedExerciseCounter)',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 20.0),
                    Text('Category'),
                    SizedBox(height: 20.0),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 15.0,
                      children: _buildFilterCategories(exerciseFilter),
                    ),
                    SizedBox(height: 20.0),
                    Text('Equipment'),
                    SizedBox(height: 20.0),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 15.0,
                      children: _buildFilterEquipment(exerciseFilter),
                    ),
                    SizedBox(height: 20.0),
                    Text('Exercise Type'),
                    SizedBox(height: 20.0),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 15.0,
                      children: _buildExerciseType(exerciseFilter),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                width: 1,
                color: Theme.of(context).accentColor,
              ),
            ),
            padding: EdgeInsets.all(14.0),
            backgroundColor: Theme.of(context).accentColor,
          ),
          child: Text(
            'Clear Filters',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            exerciseFilter.clearFilters();
          },
        ),
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  final String muscleGroup;
  final bool selected;

  FilterWidget({this.muscleGroup, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      height: 35.0,
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).accentColor : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 1.0,
        ),
      ),
      child: Text(
        muscleGroup,
        style: TextStyle(
            color: selected ? Colors.white : Theme.of(context).accentColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
