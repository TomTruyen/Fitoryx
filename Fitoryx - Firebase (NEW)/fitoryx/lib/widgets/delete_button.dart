import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function() onTap;

  const DeleteButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.delete,
        color: Colors.black,
      ),
      onTap: onTap,
    );
  }
}
