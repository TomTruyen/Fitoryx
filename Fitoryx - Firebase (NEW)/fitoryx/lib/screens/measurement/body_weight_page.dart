import 'package:flutter/material.dart';

class BodyWeightPage extends StatelessWidget {
  const BodyWeightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            title: Text('Bodyweight'),
            leading: CloseButton(),
          ),
        ],
      ),
    );
  }
}
