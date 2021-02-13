import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  GradientText({
    this.text = "",
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: <Color>[
            Colors.blueAccent[200],
            Colors.lightBlue[200],
          ],
          tileMode: TileMode.repeated,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
