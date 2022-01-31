import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/utils/double_extension.dart';
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

List<Exercise> convertUnitType(List<Exercise> exercises, UnitType newUnit) {
  switch (newUnit) {
    case UnitType.metric:
      // Convert lbs to kg (x / 2.205)
      for (var exercise in exercises) {
        for (var set in exercise.sets) {
          set.weight = ((set.weight ?? 0) / 2.205).toDecimalPlaces(2);
        }
      }
      break;
    case UnitType.imperial:
      // Convert kg to lbs (x * 2.205)
      for (var exercise in exercises) {
        for (var set in exercise.sets) {
          set.weight = ((set.weight ?? 0) * 2.205).toDecimalPlaces(2);
        }
      }
      break;
  }

  return exercises;
}
