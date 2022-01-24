import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final Function() onPressed;

  const GoogleButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        height: 70,
        width: 70,
        child: ElevatedButton(
          child: Image.asset('assets/images/google.png'),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
