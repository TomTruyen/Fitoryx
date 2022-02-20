import 'package:fitoryx/models/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final bool selected;
  final bool isSelectable;
  final Function()? onTap;
  final Function()? onDelete;

  const ExerciseItem({
    Key? key,
    required this.exercise,
    this.selected = false,
    this.isSelectable = false,
    this.onTap,
    this.onDelete,
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
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.black),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
