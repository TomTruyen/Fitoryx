import 'package:flutter/cupertino.dart';

class ExerciseFilter extends ChangeNotifier {
  String searchValue;
  int exerciseCount;
  List<String> selectedCategories = [];
  List<String> selectedEquipment = [];
  bool isUserCreated;

  ExerciseFilter({
    this.searchValue = "",
    this.exerciseCount = 0,
    this.isUserCreated = false,
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
    isUserCreated = !isUserCreated;
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
    selectedCategories = [];
    selectedEquipment = [];
    isUserCreated = false;
    notifyListeners();
  }
}
