import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String text;

  Loading({this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: text == ""
            ? CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[500]),
                strokeWidth: 2.0,
              )
            : Column(
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
