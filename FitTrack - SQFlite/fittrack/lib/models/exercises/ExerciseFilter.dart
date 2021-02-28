import 'package:flutter/material.dart';

class ExerciseFilter extends ChangeNotifier {
  String searchValue;
  int exerciseCount;
  List<String> selectedCategories = [];
  List<String> selectedEquipment = [];
  int isUserCreated;

  ExerciseFilter({
    this.searchValue = "",
    this.exerciseCount = 0,
    this.isUserCreated = 0,
  });

  void updateSearchValue(String value) {
    searchValue = value;
    notifyListeners();
  }

  void updateExerciseCount(int value) {
    exerciseCount = value;
    notifyListeners();
  }

  void toggleUserCreated() {
    isUserCreated = isUserCreated == 0 ? 1 : 0;
    notifyListeners();
  }

  void addCategory(String category) {
    selectedCategories.add(category);
    notifyListeners();
  }

  void removeCategory(String category) {
    int index = selectedCategories.indexOf(category);

    if (index > -1) {
      selectedCategories.removeAt(index);

      notifyListeners();
    }
  }

  void addEquipment(String equipment) {
    selectedEquipment.add(equipment);
    notifyListeners();
  }

  void removeEquipment(String equipment) {
    int index = selectedEquipment.indexOf(equipment);

    if (index > -1) {
      selectedEquipment.removeAt(index);

      notifyListeners();
    }
  }

  void clearAllFilters() {
    searchValue = null;
    selectedCategories = [];
    selectedEquipment = [];
    isUserCreated = 0;
    notifyListeners();
  }

  ExerciseFilter clone() {
    ExerciseFilter clone = new ExerciseFilter();
    clone.searchValue = searchValue;
    clone.isUserCreated = isUserCreated;
    clone.selectedCategories = selectedCategories;
    clone.selectedEquipment = selectedEquipment;
    clone.exerciseCount = exerciseCount;

    return clone;
  }
}
