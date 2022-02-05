import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  final String text;
  final TextStyle style;
  final EdgeInsetsGeometry? padding;

  const ListDivider({
    Key? key,
    required this.text,
    this.style = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 30.0,
      padding: padding,
      child: Text(text, style: style),
    );
  }
}
