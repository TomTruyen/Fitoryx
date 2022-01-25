import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/confirm_alert.dart';
import 'package:flutter/material.dart';

// Selected TextStyle (Name):
/**
             * TextStyle(
                              fontSize: 16.0,
                              color: Colors.blue[700],
                            )
             */

// Selected textStyle category
/**
             * subtitle.copyWith(
                              color: Colors.blue[700],
                            )
             * 
             */

class ExerciseItem extends StatelessWidget {
  final _firestoreService = FirestoreService();
  final Exercise exercise;
  final Function(String?) deleteExercise;

  ExerciseItem({Key? key, required this.exercise, required this.deleteExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _title(),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        exercise.category == "" ? "None" : exercise.category,
        style: Theme.of(context).textTheme.subtitle2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: exercise.userCreated
          ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: () async {
                clearFocus(context);

                showConfirmAlert(context,
                    content:
                        "You will be deleting \"${exercise.name}\". This action can't be reversed!",
                    onConfirm: () async {
                  try {
                    await _firestoreService.deleteExercise(exercise.id);

                    deleteExercise(exercise.id);

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    showAlert(context, content: "Failed to delete exercise");
                  }
                });
              },
            )
          : null,
      onTap: () => {},
    );
  }

  _title() {
    String title = exercise.name;

    if (exercise.equipment != "" &&
        exercise.equipment.toLowerCase() != "none") {
      title = "$title (${exercise.equipment})";
    }

    return title;
  }
}
