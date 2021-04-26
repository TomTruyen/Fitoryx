import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/pages/home/Home.dart';
import 'package:fitness_app/pages/home/authenticate/Authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
