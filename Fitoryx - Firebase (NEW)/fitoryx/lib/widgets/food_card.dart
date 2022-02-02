import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final int? value;
  final int? goal;
  final String text;
  final bool macro;

  const FoodCard(
      {Key? key, this.value, this.goal, required this.text, this.macro = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: macro
          ? const EdgeInsets.all(4)
          : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: value?.toString(),
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyText2!.fontSize! *
                              (macro ? 1.2 : 1.5),
                    ),
                  ),
                  const TextSpan(text: ''),
                  TextSpan(
                    text: macro ? "/${goal}g" : "/$goal",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: macro
                          ? Theme.of(context).textTheme.bodyText2!.fontSize! *
                              0.8
                          : Theme.of(context).textTheme.bodyText2?.fontSize,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize! * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
