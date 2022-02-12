import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({Key? key}) : super(key: key);

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const SliverAppBar(
              floating: true,
              pinned: true,
              leading: CloseButton(),
            ),
          ];
        },
        body: PageView(
          scrollDirection: Axis.vertical,
          controller: _controller,
          children: <Widget>[
            _overview(),
            _information(),
          ],
        ),
      ),
    );
  }

  Column _overview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text("HI"),
      ],
    );
  }

  Column _information() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text("HI 2"),
      ],
    );
  }
}
