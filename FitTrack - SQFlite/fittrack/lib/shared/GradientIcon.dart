import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final Widget icon;

  GradientIcon({this.icon = const Icon(Icons.more_vert)});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: <Color>[
            Colors.blueAccent[200],
            Colors.lightBlueAccent[200],
          ],
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      },
      child: icon,
    );
  }
}
