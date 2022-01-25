import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/utils/utils.dart';
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
  final Exercise exercise;

  const ExerciseItem({Key? key, required this.exercise}) : super(key: key);

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

                // SHOW CONFIRM DELETE POPUP
                print("DELETE POPUP HERE");
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
