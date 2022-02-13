import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String price;
  final String title;
  final String description;
  final void Function() onTap;

  const SubscriptionCard({
    Key? key,
    required this.price,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
