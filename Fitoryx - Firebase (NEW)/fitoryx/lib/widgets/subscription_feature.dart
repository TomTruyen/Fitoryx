import 'package:flutter/material.dart';

class SubscriptionFeature extends StatelessWidget {
  final String text;

  const SubscriptionFeature({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle, size: 20),
          const SizedBox(width: 5),
          Text(text)
        ],
      ),
    );
  }
}
