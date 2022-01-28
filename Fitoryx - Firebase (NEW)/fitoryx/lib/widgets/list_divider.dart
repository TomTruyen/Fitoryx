import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ListDivider({
    Key? key,
    required this.text,
    this.style = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(text, style: style),
    );
  }
}
