import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageSubscriptionsButton extends StatelessWidget {
  final String link = "http://play.google.com/store/account/subscriptions";

  const ManageSubscriptionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text(
          'MANAGE SUBSCRIPTIONS',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        onPressed: () async {
          if (await canLaunch(link)) {
            launch(link);
          }
        },
      ),
    );
  }
}
