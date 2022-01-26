import 'package:flutter/material.dart';

PopupMenuItem buildPopupMenuItem(
  BuildContext context,
  String value,
  String text,
) {
  return PopupMenuItem(
    height: 40.0,
    value: value,
    child: Text(
      text,
      style: Theme.of(context).textTheme.button?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}
