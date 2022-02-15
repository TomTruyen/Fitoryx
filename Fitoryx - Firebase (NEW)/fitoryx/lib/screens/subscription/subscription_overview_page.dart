import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/subscription_feature.dart';
import 'package:flutter/material.dart';

class SubscriptionOverviewPage extends StatelessWidget {
  final void Function() onPressed;

  const SubscriptionOverviewPage({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '⭐ Fitoryx Pro',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Get Fitoryx Pro and unlock all features to get better insights on your progress',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SubscriptionFeature(text: "Create unlimited workouts"),
                SubscriptionFeature(text: "Create unlimited exercises"),
                SubscriptionFeature(text: "Charts, analytics and insights"),
              ],
            ),
          ),
          GradientButton(
            text: "Pricing",
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
