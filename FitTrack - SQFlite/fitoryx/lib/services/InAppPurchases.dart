import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchases {
  static String donationEuro1 = "Fitoryx_donation_1_euro";
  static String donationEuro2 = "Fitoryx_donation_2_euro";
  static String donationEuro5 = "Fitoryx_donation_5_euro";
  static String donationEuro10 = "Fitoryx_donation_10_euro";
  static String donationEuro25 = "Fitoryx_donation_25_euro";

  static List<String> purchaseIds = [
    donationEuro1,
    donationEuro2,
    donationEuro5,
    donationEuro10,
    donationEuro25,
  ];

  bool isPurchaseApiAvailable = true;

  InAppPurchaseConnection connection = InAppPurchaseConnection.instance;

  List<ProductDetails> products = [];

  List<PurchaseDetails> purchases = [];

  StreamSubscription subscription;

  Future<void> initialize() async {
    isPurchaseApiAvailable = await connection.isAvailable();

    if (isPurchaseApiAvailable) {
      await getProducts();
      await getPurchases();

      subscription = connection.purchaseUpdatedStream.listen((
        List<PurchaseDetails> data,
      ) {
        if (data.isNotEmpty) {
          data.forEach((PurchaseDetails purchase) async {
            if (purchase.status == PurchaseStatus.purchased ||
                (Platform.isIOS && purchase.status == PurchaseStatus.error)) {
              await connection.completePurchase(purchase);
            }
          });

          purchases.addAll(data);
        }
      });
    }
  }

  void dispose() {
    subscription?.cancel();
  }

  ProductDetails getProductDetails(productId) {
    return products.firstWhere(
      (product) => product.id == productId,
      orElse: () => null,
    );
  }

  Future<void> getProducts() async {
    Set<String> ids = Set.from(purchaseIds);

    ProductDetailsResponse response = await connection.queryProductDetails(ids);

    products = response?.productDetails ?? [];
  }

  Future<void> getPurchases() async {
    QueryPurchaseDetailsResponse response =
        await connection.queryPastPurchases();

    if (response?.pastPurchases != null && response.pastPurchases.isNotEmpty) {
      for (PurchaseDetails purchase in response.pastPurchases) {
        final pending = Platform.isIOS
            ? purchase.pendingCompletePurchase
            : !purchase.billingClientPurchase.isAcknowledged;

        if (pending) {
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
      }
    }

    purchases = response?.pastPurchases ?? [];
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere(
      (purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    await connection.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: true);
  }
}
