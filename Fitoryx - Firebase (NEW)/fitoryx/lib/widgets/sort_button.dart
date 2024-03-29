import 'dart:math';

import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final bool isAscending;
  final String text;
  final Function() onPressed;

  const SortButton({
    Key? key,
    required this.isAscending,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        primary: Theme.of(context).textTheme.bodyText2?.color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform(
            alignment: Alignment.center,
            transform:
                !isAscending ? Matrix4.rotationX(pi) : Matrix4.rotationX(0),
            child: const Icon(Icons.sort),
          ),
          const SizedBox(width: 5.0),
          Text(text),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
