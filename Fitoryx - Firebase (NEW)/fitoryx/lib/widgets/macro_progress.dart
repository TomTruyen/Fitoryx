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
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
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
                        text: "/${goal}g",
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              value: goal != null ? (value / goal!).abs() : 1, // percent filled
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              backgroundColor: Colors.blue[200],
            ),
          ),
        )
      ],
    );
  }
}
