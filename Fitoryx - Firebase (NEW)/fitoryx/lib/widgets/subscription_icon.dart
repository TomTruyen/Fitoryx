import 'package:fitoryx/screens/subscription/subscription_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionIcon extends StatelessWidget {
  const SubscriptionIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.star_rounded,
        size: 30,
        color: Color.fromRGBO(255, 221, 101, 1),
      ),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => const SubscriptionPage(),
          ),
        );
      },
    );
  }
}
