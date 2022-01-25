import 'package:fitoryx/models/exercise.dart';
import 'package:flutter/material.dart';

void clearFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

List<dynamic> addListDividers(List<Exercise> exercises) {
  List<dynamic> listWithDividers = [];
  String letter = "";

  for (var exercise in exercises) {
    if (exercise.name.characters.first != letter) {
      letter = exercise.name.characters.first;

      listWithDividers.add(letter);
    }

    listWithDividers.add(exercise);
  }

  return listWithDividers;
}
