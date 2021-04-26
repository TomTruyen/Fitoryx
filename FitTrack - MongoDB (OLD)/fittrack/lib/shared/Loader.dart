import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[500]),
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

class LoaderWithMessage extends StatelessWidget {
  final String text;

  LoaderWithMessage({this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[500]),
              strokeWidth: 2.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
