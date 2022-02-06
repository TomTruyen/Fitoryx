import 'package:flutter/material.dart';

class FatPercentagePage extends StatelessWidget {
  const FatPercentagePage({Key? key}) : super(key: key);

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
            title: Text('Fat Percentage'),
            leading: CloseButton(),
          ),
        ],
      ),
    );
  }
}
