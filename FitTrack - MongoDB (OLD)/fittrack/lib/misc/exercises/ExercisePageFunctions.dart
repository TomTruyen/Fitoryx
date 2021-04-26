// My Packages
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/model/exercise/ExerciseType.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

// Check workouts, remove all exercises from list that are in workout (except for the one we are going to replace), do this only on isReplaceExercsie
void filterExercises(
  ExerciseFilter exerciseFilter,
  Function updateExerciseState,
  WorkoutExercise exerciseToReplace,
  bool isReplaceExercise,
  WorkoutChangeNotifier workout,
) async {
  List<Exercise> exercises = globals.exercises ?? [];
  List<ExerciseCategory> selectedCategories = globals.selectedCategories ?? [];
  List<ExerciseEquipment> selectedEquipment = globals.selectedEquipment ?? [];
  List<ExerciseType> selectedTypes = globals.selectedTypes ?? [];

  List<dynamic> categoryList = [];

  if (selectedCategories.length > 0) {
    for (int i = 0; i < exercises.length; i++) {
      for (int j = 0; j < selectedCategories.length; j++) {
        if (exercises[i].category.toLowerCase() ==
            selectedCategories[j].name.toLowerCase()) {
          if (exerciseFilter.searchQuery != "") {
            if (exercises[i]
                .name
                .toLowerCase()
                .contains(exerciseFilter.searchQuery.toLowerCase())) {
              categoryList.add(exercises[i]);
            }
          } else {
            categoryList.add(exercises[i]);
          }
        }
      }
    }
  }

  List<dynamic> equipmentList = [];
  if (selectedEquipment.length > 0) {
    for (int i = 0; i < exercises.length; i++) {
      for (int j = 0; j < selectedEquipment.length; j++) {
        if (selectedEquipment[j].name.toLowerCase() != "other") {
          if (exercises[i].equipment.toLowerCase() ==
              selectedEquipment[j].name.toLowerCase()) {
            if (exerciseFilter.searchQuery != "") {
              if (exercises[i]
                  .name
                  .toLowerCase()
                  .contains(exerciseFilter.searchQuery.toLowerCase())) {
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
            if (exerciseFilter.searchQuery != "" &&
                exercises[i]
                    .name
                    .toLowerCase()
                    .contains(exerciseFilter.searchQuery.toLowerCase())) {
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
      exerciseFilter.searchQuery != "") {
    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i]
          .name
          .toLowerCase()
          .contains(exerciseFilter.searchQuery.toLowerCase())) {
        filtered.add(exercises[i]);
      }
    }
  }

  if (filtered.length == 0) {
    if (selectedEquipment.length > 0 && selectedCategories.length > 0) {
      filtered = [...equipmentList.where(categoryList.contains)];
    } else if (selectedEquipment.length > 0) {
      filtered = [...equipmentList];
    } else if (selectedCategories.length > 0) {
      filtered = [...categoryList];
    } else if (exerciseFilter.searchQuery == "") {
      filtered = [...exercises];
    }
  }

  filtered = _sortExercisesByName(filtered);

  List<dynamic> _filteredExercises = [];

  for (int i = 0; i < filtered.length; i++) {
    if (selectedTypes.contains(ExerciseType.custom) &&
        !selectedTypes.contains(ExerciseType.preset)) {
      if ((filtered[i] as Exercise).isUserCreated) {
        _filteredExercises.add(filtered[i]);
      }
    } else if (!selectedTypes.contains(ExerciseType.custom) &&
        selectedTypes.contains(ExerciseType.preset)) {
      if (!(filtered[i] as Exercise).isUserCreated) {
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
      }
    }
  }

  if (isReplaceExercise && workout != null) {
    for (int i = 0; i < _filteredExercises.length; i++) {
      for (int j = 0; j < workout.exercises.length; j++) {
        if (_filteredExercises[i] is Exercise &&
            (_filteredExercises[i] as Exercise).id ==
                workout.exercises[j].exerciseId) {
          if ((_filteredExercises[i] as Exercise).id !=
              exerciseToReplace.exerciseId) {
            _filteredExercises.removeAt(i);
          }
        }
      }
    }
  }

  updateExerciseState(_filteredExercises);

  await Future.delayed(const Duration(seconds: 0), () {
    exerciseFilter.updateExerciseCount(
      _filteredExercises.length - letterDividerCount,
    );
  });
}

// Sort Exercises By Name
List<dynamic> _sortExercisesByName(List<dynamic> exerciseList) {
  exerciseList
      .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return exerciseList;
}
