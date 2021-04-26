// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/pages/exercise/ExerciseFilterPage.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/model/exercise/ExerciseType.dart';

// Filter Categories
List<Widget> buildFilterCategories(
  ExerciseFilter exerciseFilter,
  List<ExerciseCategory> categories,
) {
  List<Widget> filterCategories = [];

  for (int i = 0; i < categories.length; i++) {
    bool selected = false;

    for (int j = 0; j < exerciseFilter.selectedCategories.length; j++) {
      if (categories[i].name.toLowerCase() ==
          exerciseFilter.selectedCategories[j].name.toLowerCase()) {
        selected = true;
        break;
      }
    }

    filterCategories.add(
      InkWell(
        child: FilterWidget(
          muscleGroup: categories[i].name,
          selected: selected,
        ),
        onTap: () {
          if (selected) {
            exerciseFilter.removeSelectedCategory(categories[i]);
          } else {
            exerciseFilter.addSelectedCategory(categories[i]);
          }
        },
      ),
    );
  }

  return filterCategories;
}

// Filter Equipment
List<Widget> buildFilterEquipment(
  ExerciseFilter exerciseFilter,
  List<ExerciseEquipment> equipment,
) {
  List<Widget> filterEquipment = [];

  for (int i = 0; i < equipment.length; i++) {
    bool selected = false;

    for (int j = 0; j < exerciseFilter.selectedEquipment.length; j++) {
      if (equipment[i].name.toLowerCase() ==
          exerciseFilter.selectedEquipment[j].name.toLowerCase()) {
        selected = true;
        break;
      }
    }

    filterEquipment.add(
      InkWell(
        child: FilterWidget(
          muscleGroup: equipment[i].name,
          selected: selected,
        ),
        onTap: () {
          if (selected) {
            exerciseFilter.removeSelectedEquipment(equipment[i]);
          } else {
            exerciseFilter.addSelectedEquipment(equipment[i]);
          }
        },
      ),
    );
  }

  return filterEquipment;
}

// Filter ExerciseType
List<Widget> buildExerciseType(ExerciseFilter exerciseFilter) {
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
