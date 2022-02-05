import 'package:flutter/material.dart';

class ExerciseRecordRow extends StatelessWidget {
  final String title;
  final String? value;

  const ExerciseRecordRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(
            value == null ? '-' : value!,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
