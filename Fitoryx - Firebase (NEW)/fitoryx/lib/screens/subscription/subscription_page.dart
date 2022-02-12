import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            _overview(context),
            _pricing(),
          ],
        ),
      ),
    );
  }

  Container _overview(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: width,
                height: 150,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned(
                      left: width / 10,
                      bottom: 10,
                      child: Transform.rotate(
                        angle: 90,
                        child: Image.asset(
                          "assets/images/star.png",
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Image.asset(
                        "assets/images/star.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      right: width / 10,
                      bottom: 10,
                      child: Transform.rotate(
                        angle: -90,
                        child: Image.asset(
                          "assets/images/star.png",
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Fitoryx Pro',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Get Fitoryx Pro and unlock all features to get better insights on your progress',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _feature("Create unlimited workouts"),
                _feature("Create unlimited exercises"),
                _feature("Charts, analytics and insights"),
              ],
            ),
          ),
          _pricingButton(),
        ],
      ),
    );
  }

  Container _feature(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle, size: 20),
          const SizedBox(width: 5),
          Text(text)
        ],
      ),
    );
  }

  Container _pricing() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Subscribe',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Subscribe to Fitoryx Pro to get access to all premium features',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
          const Spacer(),
          SubscriptionCard(
            price: "€4.99",
            measurement: "month",
            description: "Start monthly subscription",
            onTap: () {
              print("MONTHLY");
            },
          ),
          SubscriptionCard(
            price: "€12.99",
            measurement: "quarter",
            description: "Start quarterly subscription",
            onTap: () {
              print("QUARTERLY");
            },
          ),
          SubscriptionCard(
            price: "€39.99",
            measurement: "yearly",
            description: "Start yearly subscription",
            onTap: () {
              print("YEARLY");
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              child: Text(
                'MANAGE SUBSCRIPTIONS',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              onPressed: () async {
                const String subscriptions =
                    "http://play.google.com/store/account/subscriptions";

                if (await canLaunch(subscriptions)) {
                  launch(subscriptions);
                }
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  GradientButton _pricingButton() {
    return GradientButton(
      text: "Pricing",
      onPressed: () {
        _controller.animateToPage(
          1,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
