import 'package:fitoryx/models/exercise.dart';
import 'package:flutter/material.dart';

void clearFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

List<dynamic> addListDividers(List<Exercise> exercises) {
  // Sort
  exercises
      .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  List<dynamic> listWithDividers = [];
  String letter = "";

  for (var exercise in exercises) {
    if (exercise.name.characters.first.toUpperCase() != letter.toUpperCase()) {
      letter = exercise.name.characters.first.toUpperCase();

      listWithDividers.add(letter);
    }

    listWithDividers.add(exercise);
  }

  return listWithDividers;
}

String? convertDoubleToIntString(double? value) {
  if (value == null || value % 1 != 0) {
    return value?.toString();
  }

  return value.toInt().toString();
}
