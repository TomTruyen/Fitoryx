import 'package:flutter/material.dart';

class ExerciseRow extends StatelessWidget {
  final String sets;
  final String name;
  final String equipment;

  const ExerciseRow({
    Key? key,
    this.sets = "",
    this.name = "",
    this.equipment = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      child: Text(
        _text(),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  String _text() {
    if (sets.isEmpty && name.isEmpty) {
      return "";
    }

    String text = "$sets x $name";

    if (equipment != "") {
      text += " ($equipment)";
    }

    return text;
  }
}
