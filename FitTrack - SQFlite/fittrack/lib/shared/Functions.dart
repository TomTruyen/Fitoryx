import 'package:flutter/material.dart';

void tryPopContext(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
