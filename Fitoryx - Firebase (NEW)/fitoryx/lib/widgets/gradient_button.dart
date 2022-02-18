import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final bool isBusy;
  final Function()? onPressed;

  const GradientButton({
    Key? key,
    this.text = "",
    this.isBusy = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.blueAccent[700]!,
                Colors.blueAccent[400]!,
                Colors.blueAccent[200]!,
              ],
              tileMode: TileMode.repeated,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: isBusy
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
