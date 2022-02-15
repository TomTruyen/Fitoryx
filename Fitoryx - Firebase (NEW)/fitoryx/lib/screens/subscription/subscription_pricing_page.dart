import 'package:fitoryx/models/subscription.dart';
import 'package:fitoryx/providers/subscription_provider.dart';
import 'package:fitoryx/services/purchase_service.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/manage_subscription_button.dart';
import 'package:fitoryx/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionPricingPage extends StatefulWidget {
  const SubscriptionPricingPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPricingPage> createState() =>
      _SubscriptionPricingPageState();
}

class _SubscriptionPricingPageState extends State<SubscriptionPricingPage> {
  bool _subscribing = false;
  List<Package> _packages = [];

  @override
  void initState() {
    _fetchProducts();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<SubscriptionProvider>(context);
    final _subscription = _provider.subscription;
    final _expiration = _provider.expiration;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _subscribing
              ? const Expanded(
                  child: Loader(),
                )
              : _subscription is FreeSubscription
                  ? _subscriptions()
                  : _subscribed(_expiration)
        ],
      ),
    );
  }

  _subscriptions() {
    return Expanded(
      child: Column(
        children: <Widget>[
          const Spacer(),
          if (_packages.isEmpty)
            const Center(
              child: Text("No subscriptions found"),
            ),
          for (var package in _packages)
            SubscriptionCard(
              price: package.product.priceString,
              title: package.product.title
                  .replaceAll("(Fitoryx: Fitness & Nutrition Tracker)", ""),
              description: package.product.description,
              onTap: () async {
                setState(() => _subscribing = true);
                await PurchaseService.purchasePackage(package);
                setState(() => _subscribing = false);
              },
            ),
          const Spacer(),
          const ManageSubscriptionsButton(),
        ],
      ),
    );
  }

  _subscribed(DateTime? expiration) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "⭐ Fitoryx Pro ⭐",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (expiration != null)
                    Text(
                      "Expiration: ${DateFormat("dd-MM-yyyy HH:mm").format(expiration)}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                ],
              ),
            ),
          ),
          const ManageSubscriptionsButton(),
        ],
      ),
    );
  }
}
