import 'package:flutter/material.dart';

class TimeHeaderRow extends StatelessWidget {
  const TimeHeaderRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            'SET',
            style: TextStyle(fontSize: 11.0),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            'TIME',
            style: TextStyle(fontSize: 11.0),
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 1)
      ],
    );
  }
}
