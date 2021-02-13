import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  GradientButton({this.text = "", this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent[200],
                  Colors.lightBlueAccent[200],
                ],
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
