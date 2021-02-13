import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;

  GradientText({
    this.text = "",
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.blueAccent[700],
            Colors.blueAccent[400],
            Colors.blueAccent[200],
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
        textAlign: textAlign,
        overflow: overflow,
      ),
    );
  }
}
