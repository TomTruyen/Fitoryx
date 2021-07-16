import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String text;

  Loader({this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.grey[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[500]),
              strokeWidth: 2.0,
            ),
            if (text != null)
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(text),
              ),
          ],
        ),
      ),
    );
  }
}
