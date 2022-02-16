import 'package:flutter/material.dart';

class ExerciseFilter extends ChangeNotifier {
  List<String> categories = [];
  List<String> equipments = [];
  List<String> types = [];
  String search = "";
  int count = 0;

  void addCategory(String category) {
    categories.add(category);
    notifyListeners();
  }

  void removeCategory(String category) {
    if (categories.contains(category)) {
      categories.remove(category);
      notifyListeners();
    }
  }

  void addEquipment(String equipment) {
    equipments.add(equipment);
    notifyListeners();
  }

  void removeEquipment(String equipment) {
    if (equipments.contains(equipment)) {
      equipments.remove(equipment);
      notifyListeners();
    }
  }

  void addType(String type) {
    types.add(type);
    notifyListeners();
  }

  void removeType(String type) {
    if (types.contains(type)) {
      types.remove(type);
      notifyListeners();
    }
  }

  void setCount(int count) {
    this.count = count;
    notifyListeners();
  }

  void setSearch(String value) {
    search = value;
    notifyListeners();
  }

  void clear({includeSearch = false}) {
    categories = [];
    equipments = [];
    types = [];

    if (includeSearch) {
      search = "";
    }

    notifyListeners();
  }
}
