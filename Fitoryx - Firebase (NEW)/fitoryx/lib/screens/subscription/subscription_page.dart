import 'package:fitoryx/services/purchase_service.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  List<Package> _packages = [];
  final PageController _controller = PageController();

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            _pricing(),
          ],
        ),
      ),
    );
  }

  void _fetchProducts() async {
    var products = await PurchaseService.fetchProducts();

    if (mounted) {
      setState(() {
        _packages = products
            .map((product) => product.availablePackages)
            .expand((pair) => pair)
            .toList();
      });
    }
  }

  Container _overview() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Fitoryx Pro ⭐',
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
          if (_packages.isEmpty)
            const Center(
              child: Text("No plans found"),
            ),
          for (var package in _packages)
            SubscriptionCard(
              price: package.product.priceString,
              title: package.product.title
                  .replaceAll("(Fitoryx: Fitness & Nutrition Tracker)", ""),
              description: package.product.description,
              onTap: () async {
                await PurchaseService.purchasePackage(package);
              },
            ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              child: Text(
                'MANAGE SUBSCRIPTIONS',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
