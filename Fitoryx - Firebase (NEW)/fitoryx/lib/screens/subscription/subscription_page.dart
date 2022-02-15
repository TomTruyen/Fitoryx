import 'package:fitoryx/screens/subscription/subscription_overview_page.dart';
import 'package:fitoryx/screens/subscription/subscription_pricing_page.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
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
            SubscriptionOverviewPage(
              onPressed: () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
            const SubscriptionPricingPage(),
          ],
        ),
      ),
    );
  }
}
