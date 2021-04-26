import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String imageURL;

  SocialSignInButton({@required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      height: 75.0,
      width: 75.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            spreadRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Image(
        image: AssetImage(imageURL),
        width: 50.0,
      ),
    );
  }
}
