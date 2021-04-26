// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/misc/Functions.dart';

List<Widget> _getCategoryItems(
    BuildContext context,
    List<ExerciseCategory> exerciseCategories,
    Function updateExerciseCategory) {
  List<Widget> categories = [];

  categories.add(
    Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      height: 60.0,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Text(
        'Categories',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    ),
  );

  categories.add(
    Divider(),
  );

  for (int i = 0; i < exerciseCategories.length; i++) {
    categories.add(
      InkWell(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 30.0,
          child: Text(
            exerciseCategories[i].name,
          ),
        ),
        onTap: () {
          updateExerciseCategory(exerciseCategories[i].name);

          popContextWhenPossible(context);
        },
      ),
    );
    categories.add(
      Divider(),
    );
  }

  return categories;
}

List<Widget> _getEquipmentItems(
  BuildContext context,
  List<ExerciseEquipment> exerciseEquipments,
  Function updateExerciseEquipment,
) {
  List<Widget> equipment = [];

  equipment.add(
    Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      height: 60.0,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Text(
        'Equipment',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    ),
  );

  equipment.add(
    Divider(),
  );

  for (int i = 0; i < exerciseEquipments.length; i++) {
    equipment.add(
      InkWell(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 30.0,
          child: Text(
            exerciseEquipments[i].name,
          ),
        ),
        onTap: () {
          updateExerciseEquipment(exerciseEquipments[i].name);

          popContextWhenPossible(context);
        },
      ),
    );
    equipment.add(
      Divider(),
    );
  }

  return equipment;
}

void showPopupMenuCategory(
    BuildContext context,
    List<ExerciseCategory> exerciseCategories,
    Function updateExerciseCategory) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Color.fromRGBO(255, 255, 255, 0.01),
    builder: (BuildContext context) {
      return Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 150.0,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.grey[50],
            border: Border.all(
              width: 0,
            ),
          ),
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Color.fromRGBO(100, 100, 100, 1),
              ),
              child: Material(
                color: Colors.grey[50],
                child: Column(
                  children: _getCategoryItems(
                    context,
                    exerciseCategories,
                    updateExerciseCategory,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showPopupMenuEquipment(
  BuildContext context,
  List<ExerciseEquipment> exerciseEquipments,
  Function updateExerciseEquipment,
) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Color.fromRGBO(255, 255, 255, 0.01),
    builder: (BuildContext context) {
      return Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 150.0,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.grey[50],
            border: Border.all(
              width: 0,
            ),
          ),
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Color.fromRGBO(100, 100, 100, 1),
              ),
              child: Material(
                color: Colors.grey[50],
                child: Column(
                  children: _getEquipmentItems(
                    context,
                    exerciseEquipments,
                    updateExerciseEquipment,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
