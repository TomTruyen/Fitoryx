import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/confirm_alert.dart';
import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  final _firestoreService = FirestoreService();
  final Exercise exercise;
  final bool selected;
  final bool isSelectable;
  final Function()? onTap;
  final Function(String?) deleteExercise;

  ExerciseItem({
    Key? key,
    required this.exercise,
    this.selected = false,
    this.isSelectable = false,
    this.onTap,
    required this.deleteExercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        exercise.getTitle(),
        style: selected
            ? TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              )
            : null,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        exercise.category == "" ? "None" : exercise.category,
        style: selected
            ? Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: Theme.of(context).primaryColor,
                )
            : Theme.of(context).textTheme.subtitle2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: exercise.userCreated && !isSelectable
          ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: () async {
                clearFocus(context);

                showConfirmAlert(
                  context,
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
                  },
                );
              },
            )
          : null,
      onTap: onTap,
    );
  }
}
