import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final Widget icon;

  GradientIcon({this.icon = const Icon(Icons.more_vert)});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.blueAccent[200],
            Colors.lightBlue[200],
          ],
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      },
      child: icon,
    );
  }
}
