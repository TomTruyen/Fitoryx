import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  static const _apiKey = "goog_TjlrLhgHyBHGxfHVHyannMdKKcw";

  static Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  static Future<List<Offering>> fetchProducts() async {
    try {
      final products = await Purchases.getOfferings();

      final current = products.current;

      return current == null ? [] : [current];
    } on PlatformException {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
