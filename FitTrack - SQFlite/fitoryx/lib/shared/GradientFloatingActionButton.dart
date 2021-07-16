import 'package:flutter/material.dart';

class GradientFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final Function onPressed;

  GradientFloatingActionButton(
      {this.icon = const Icon(Icons.add_outlined), this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Container(
        width: 60,
        height: 60,
        child: icon,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.blueAccent[700],
              Colors.blueAccent[400],
              Colors.blueAccent[200],
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
