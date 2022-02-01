import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final int? value;
  final int? goal;
  final String text;
  final bool macro;

  const FoodCard(
      {Key? key, this.value, this.goal, required this.text, this.macro = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: macro
          ? const EdgeInsets.all(4)
          : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _title(),
            style: TextStyle(
              fontSize: macro
                  ? Theme.of(context).textTheme.bodyText2?.fontSize
                  : Theme.of(context).textTheme.bodyText2!.fontSize! * 1.5,
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              _goal(),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  String _title() {
    if (macro) {
      return "${value}g";
    }

    return value.toString();
  }

  String _goal() {
    if (goal == null || goal == 0) {
      return text.toUpperCase();
    }

    return "of $goal $text".toUpperCase();
  }
}
