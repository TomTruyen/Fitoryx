import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/CategoryList.dart';
import 'package:fittrack/shared/EquipmentList.dart';
import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExerciseAddPage extends StatefulWidget {
  final Function updateUserExercises;

  ExerciseAddPage(this.updateUserExercises);

  @override
  _ExerciseAddPageState createState() => _ExerciseAddPageState();
}

class _ExerciseAddPageState extends State<ExerciseAddPage> {
  final formKey = GlobalKey<FormState>();

  String exerciseName = "";
  String exerciseCategory = "";
  String exerciseEquipment = "";

  @override
  Widget build(BuildContext context) {
    void showPopupMenu(bool isCategory) async {
      List<Widget> _getItems(String title, List<String> options) {
        List<Widget> items = [];

        items.add(
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            height: 60.0,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
        );

        items.add(
          Divider(),
        );

        for (int i = 0; i < options.length; i++) {
          items.add(
            InkWell(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 30.0,
                child: Text(
                  options[i],
                ),
              ),
              onTap: () {
                setState(() {
                  if (title == 'Categories') {
                    exerciseCategory = options[i];
                  } else {
                    exerciseEquipment = options[i];
                  }
                });

                tryPopContext(context);
              },
            ),
          );
          items.add(
            Divider(),
          );
        }

        return items;
      }

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: 250.0,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
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
                      children: _getItems(
                          isCategory ? 'Categories' : 'Equipment',
                          isCategory ? categories : equipment),
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
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey[50],
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  tryPopContext(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      clearFocus(context);

                      dynamic result = await globals.sqlDatabase.addExercise(
                          exerciseName, exerciseCategory, exerciseEquipment);

                      if (result == null) {
                        showPopupError(
                          context,
                          'Adding exercise failed',
                          'Something went wrong adding the exercise. Please try again.',
                        );
                      } else {
                        await widget.updateUserExercises();

                        tryPopContext(context);
                      }
                    }
                  },
                ),
              ],
              title: Text(
                'New Exercise',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
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
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Exercise name is required';
                          }

                          return null;
                        },
                        onChanged: (String value) {
                          exerciseName = value;
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
                              Text(exerciseCategory == ""
                                  ? "None"
                                  : exerciseCategory),
                            ],
                          ),
                          onTap: () {
                            clearFocus(context);
                            showPopupMenu(true);
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
                              Text(exerciseEquipment == ""
                                  ? "None"
                                  : exerciseEquipment),
                            ],
                          ),
                          onTap: () {
                            clearFocus(context);
                            showPopupMenu(false);
                          },
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
    );
  }
}
