import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/exercises/ExerciseCategory.dart';
import 'package:fitness_app/models/exercises/ExerciseEquipment.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseAddPage extends StatefulWidget {
  @override
  _ExerciseAddPageState createState() => _ExerciseAddPageState();
}

class _ExerciseAddPageState extends State<ExerciseAddPage> {
  final _formKey = GlobalKey<FormState>();

  String exerciseName = '';
  String exerciseCategory = '';
  String exerciseEquipment = '';
  bool isCompound = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context) ?? null;
    final List<ExerciseCategory> dbExerciseCategories =
        Provider.of<List<ExerciseCategory>>(context) ?? [];
    final List<ExerciseEquipment> dbExerciseEquipments =
        Provider.of<List<ExerciseEquipment>>(context) ?? [];

    final List<ExerciseCategory> exerciseCategories = [
      ExerciseCategory(name: 'None'),
      ...dbExerciseCategories
    ];

    if (exerciseCategory == "") {
      exerciseCategory = 'None';
    }

    final List<ExerciseEquipment> exerciseEquipments = [
      ExerciseEquipment(name: 'None'),
      ...dbExerciseEquipments
    ];

    if (exerciseEquipment == "") {
      exerciseEquipment = 'None';
    }

    List<Widget> _getCategoryItems() {
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
              setState(() {
                exerciseCategory = exerciseCategories[i].name;
              });

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

    void _showPopupMenuCategory() async {
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
                      children: _getCategoryItems(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    List<Widget> _getEquipmentItems() {
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
              setState(() {
                exerciseEquipment = exerciseEquipments[i].name;
              });

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

    void _showPopupMenuEquipment() async {
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
                      children: _getEquipmentItems(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: exerciseCategories != null
          ? ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    forceElevated: true,
                    floating: true,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        popContextWhenPossible(context);
                      },
                    ),
                    title: Text('New exercise'),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                fillColor: Colors.grey[300],
                                filled: true,
                                hintText: 'Exercise Name',
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Exercise name is required';
                                }

                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  exerciseName = value;
                                });
                              },
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              height: 50.0,
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Category'),
                                    Text(exerciseCategory),
                                  ],
                                ),
                                onTap: () {
                                  _showPopupMenuCategory();
                                },
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              height: 50.0,
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Equipment'),
                                    Text(exerciseEquipment),
                                  ],
                                ),
                                onTap: () {
                                  _showPopupMenuEquipment();
                                },
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              height: 50.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Compound Exercise'),
                                  Switch(
                                    value: isCompound,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isCompound = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Text("Failed to load categories"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            final loadingSnackbar = SnackBar(
              elevation: 8.0,
              backgroundColor: Colors.orange[400],
              content: Text(
                'Saving...',
                textAlign: TextAlign.center,
              ),
              duration: Duration(minutes: 1),
            );

            ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar);

            dynamic result =
                await DatabaseService(uid: user != null ? user.uid : '')
                    .addExercise(exerciseName, exerciseCategory,
                        exerciseEquipment, isCompound);

            await Future.delayed(
              Duration(milliseconds: 500),
              () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            );

            if (result != null) {
              final successSnackbar = SnackBar(
                duration: Duration(seconds: 1),
                elevation: 8.0,
                backgroundColor: Colors.green[400],
                content: GestureDetector(
                  child: Text(
                    'Saved',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(successSnackbar);

              Future.delayed(
                Duration(milliseconds: 1500),
                () {
                  popContextWhenPossible(context);
                },
              );
            } else {
              final failureSnackbar = SnackBar(
                duration: Duration(seconds: 1),
                elevation: 8.0,
                backgroundColor: Colors.red[400],
                content: GestureDetector(
                  child: Text(
                    'Save Failed',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(failureSnackbar);
            }
          }
        },
      ),
    );
  }
}
