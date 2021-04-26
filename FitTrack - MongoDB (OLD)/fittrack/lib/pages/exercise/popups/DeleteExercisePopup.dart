// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/shared/Snackbars.dart';

Future<void> showPopupDeleteExercise(
    BuildContext context,
    List<dynamic> exercises,
    Exercise exercise,
    Function refreshExercises) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 250.0,
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50],
                border: Border.all(
                  width: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Color.fromRGBO(70, 70, 70, 1),
                    unselectedWidgetColor: Color.fromRGBO(
                      200,
                      200,
                      200,
                      1,
                    ),
                  ),
                  child: Material(
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Delete "${exercise.name}"?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Are you sure you want to delete your exercise?',
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  popContextWhenPossible(context);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                  popContextWhenPossible(context);

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  if (!exercise.isUserCreated) {
                                    popContextWhenPossible(context);
                                  }

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(deletingSnackbar);

                                  bool isDeleted = await Database(
                                          uid: globals.uid)
                                      .deleteExercise(exercises, exercise.id);

                                  if (isDeleted) {
                                    await refreshExercises();

                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(deleteSuccessSnackbar);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(deleteFailedSnackbar);
                                  }
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
            ),
          );
        },
      );
    },
  );
}
