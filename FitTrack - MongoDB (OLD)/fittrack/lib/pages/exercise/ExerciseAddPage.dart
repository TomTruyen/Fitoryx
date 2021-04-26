// Flutter  Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/misc/exercises/ExerciseAddPageFunctions.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Snackbars.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExerciseAddPage extends StatefulWidget {
  final Function refreshExercises;

  ExerciseAddPage(this.refreshExercises);

  @override
  _ExerciseAddPageState createState() => _ExerciseAddPageState();
}

class _ExerciseAddPageState extends State<ExerciseAddPage> {
  final formKey = GlobalKey<FormState>();

  String exerciseName = '';
  String exerciseCategory = 'None';
  String exerciseEquipment = 'None';
  bool isCompound = false;

  final List<ExerciseCategory> exerciseCategories = [
    ExerciseCategory(name: 'None'),
    ...globals.categories
  ];

  final List<ExerciseEquipment> exerciseEquipments = [
    ExerciseEquipment(name: 'None'),
    ...globals.equipment
  ];

  void setExerciseName(String name) {
    setState(() {
      exerciseName = name;
    });
  }

  void setExerciseCategory(String category) {
    setState(() {
      exerciseCategory = category;
    });
  }

  void setExerciseEquipment(String equipment) {
    setState(() {
      exerciseEquipment = equipment;
    });
  }

  void setIsCompound(bool value) {
    setState(() {
      isCompound = value;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget build(BuildContext context) {
    return _ExerciseAddPageView(this);
  }
}

class _ExerciseAddPageView extends StatelessWidget {
  final _ExerciseAddPageState state;

  _ExerciseAddPageView(this.state);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = state.formKey;

    final bool _isCompound = state.isCompound;

    final String _exerciseName = state.exerciseName;
    final String _exerciseCategory = state.exerciseCategory;
    final String _exerciseEquipment = state.exerciseEquipment;

    final List<ExerciseCategory> _exerciseCategories = state.exerciseCategories;
    final List<ExerciseEquipment> _exerciseEquipments =
        state.exerciseEquipments;

    final Function _setExerciseName = state.setExerciseName;
    final Function _setExerciseCategory = state.setExerciseCategory;
    final Function _setExerciseEquipment = state.setExerciseEquipment;
    final Function _setIsCompound = state.setIsCompound;
    final Function _refreshExercises = state.widget.refreshExercises;

    return Scaffold(
      body: ScrollConfiguration(
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
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                          _setExerciseName(value);
                        },
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Category'),
                              Text(_exerciseCategory),
                            ],
                          ),
                          onTap: () {
                            showPopupMenuCategory(
                              context,
                              _exerciseCategories,
                              _setExerciseCategory,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Equipment'),
                              Text(_exerciseEquipment),
                            ],
                          ),
                          onTap: () {
                            showPopupMenuEquipment(
                              context,
                              _exerciseEquipments,
                              _setExerciseEquipment,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Compound Exercise'),
                            Switch(
                              value: _isCompound,
                              onChanged: (bool value) {
                                _setIsCompound(value);
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              savingSnackbar,
            );

            bool isSaved = await Database(uid: globals.uid).addExercise(
              _exerciseName,
              _exerciseCategory,
              _exerciseEquipment,
              _isCompound,
            );

            if (isSaved) {
              await _refreshExercises();

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(saveSuccessSnackbar);

              Future.delayed(Duration(seconds: 1), () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                popContextWhenPossible(context);
              });
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(saveFailSnackbar);

              Future.delayed(Duration(seconds: 1), () {
                popContextWhenPossible(context);
              });
            }
          }
        },
      ),
    );
  }

  // LET OP POPUPS HEBBEN HEEL WAT VARIABELEN NODIG VOORDAT ZE WERKEN
  // maak ook een widget in de exerciseaddpagefunctions classe aan voor de snackbars
}
