import 'package:fitness_app/models/exercises/ExerciseCategory.dart';
import 'package:fitness_app/models/exercises/ExerciseEquipment.dart';
import 'package:flutter/cupertino.dart';

import 'ExerciseType.dart';

class ExerciseFilter extends ChangeNotifier {
  String searchQuery = "";
  int exerciseCount;
  List<ExerciseCategory> selectedCategories = [];
  List<ExerciseEquipment> selectedEquipment = [];
  List<ExerciseType> selectedTypes = [];

  // Handle Search Bar Change
  void updateSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  // Exercise Count (Filter)
  void updateExerciseCount(int count) {
    exerciseCount = count;
    notifyListeners();
  }

  // Clear Filters
  void clearFilters() {
    selectedCategories = [];
    selectedEquipment = [];
    selectedTypes = [];
    notifyListeners();
  }

  // Selected Categories
  void addSelectedCategory(ExerciseCategory category) {
    selectedCategories.add(category);
    notifyListeners();
  }

  void removeSelectedCategory(ExerciseCategory category) {
    // Have to do it this way, to fix random issue when selecting a muscle group before showing list
    for (int i = 0; i < selectedCategories.length; i++) {
      if (selectedCategories[i].name.toLowerCase() ==
          category.name.toLowerCase()) {
        selectedCategories.removeAt(i);
        break;
      }
    }

    notifyListeners();
  }

  // Selected Equipment
  void addSelectedEquipment(ExerciseEquipment equipment) {
    selectedEquipment.add(equipment);
    notifyListeners();
  }

  void removeSelectedEquipment(ExerciseEquipment equipment) {
    selectedEquipment.remove(equipment);
    notifyListeners();
  }

  // Selected ExerciseType
  void addExerciseType(ExerciseType type) {
    selectedTypes.add(type);
    notifyListeners();
  }

  void removeExerciseType(ExerciseType type) {
    selectedTypes.remove(type);
    notifyListeners();
  }
}
