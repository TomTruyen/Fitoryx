import 'package:flutter/material.dart';

class MacroProgress extends StatelessWidget {
  final String title;
  final int value;
  final int? goal;

  const MacroProgress({
    Key? key,
    required this.title,
    required this.value,
    this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (goal != null)
                      TextSpan(
                        text: "/$goal",
                        style: const TextStyle(fontSize: 12),
                      ),
                    const TextSpan(
                      text: "g",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value:
                    goal != null ? (value / goal!).abs() : 1, // percent filled
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
                backgroundColor: Colors.blue[200],
              ),
            ),
          )
        ],
      ),
    );
  }
}
