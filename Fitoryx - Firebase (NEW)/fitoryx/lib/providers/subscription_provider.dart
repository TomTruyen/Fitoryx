import 'package:fitoryx/models/subscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionProvider() {
    init();
  }

  Subscription _subscription = FreeSubscription();
  Subscription get subscription => _subscription;

  Future init() async {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    final purchaserInfo = await Purchases.getPurchaserInfo();

    final entitlements = purchaserInfo.entitlements.active.values.toList();

    _subscription =
        entitlements.isEmpty ? FreeSubscription() : ProSubscription();

    notifyListeners();
  }
}
