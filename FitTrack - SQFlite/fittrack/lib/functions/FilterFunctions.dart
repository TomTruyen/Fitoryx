import 'package:fittrack/models/exercises/Exercise.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/shared/ExerciseList.dart';

Map<String, dynamic> getFilteredExercises(
  ExerciseFilter filter,
  List<Exercise> userExercises,
  List<Exercise> workoutExercises,
  bool isReplaceActive,
  Exercise exerciseToReplace,
  Exercise workoutExerciseToReplace,
) {
  List<dynamic> filtered = [];

  List<Exercise> _exercises = List.of(exercises);

  if (userExercises != null && userExercises.isNotEmpty) {
    _exercises.addAll(List.of(userExercises));
  }

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
      if (_exercises[i]
          .name
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        if ((isUserCreated == 1 &&
                isUserCreated == _exercises[i].isUserCreated) ||
            filter.isUserCreated == 0) {
          selectedExercises.add(_exercises[i]);
        }
      }
    }
  }

  if (isReplaceActive && selectedExercises.isNotEmpty) {
    for (int i = 0; i < selectedExercises.length; i++) {
      if ((workoutExercises.contains(selectedExercises[i]) &&
          !selectedExercises[i].compare(exerciseToReplace) &&
          !selectedExercises[i].compare(workoutExerciseToReplace))) {
        selectedExercises.remove(selectedExercises[i]);
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

  return {
    'exercises': filtered,
    'exercisesLength': selectedExercises.length,
  };
}
