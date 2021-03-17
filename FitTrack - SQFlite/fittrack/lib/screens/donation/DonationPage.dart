import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/screens/donation/popups/AboutMePopup.dart';
import 'package:fittrack/services/InAppPurchases.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: Text(
              'Donation',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Thank you!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            Theme.of(context).textTheme.bodyText2.fontSize *
                                1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Donations are not required, but are appreciated and help me work on this project. Please know that donations don\'t give you any extra features!',
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Want to know more about me?',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize:
                              Theme.of(context).textTheme.bodyText2.fontSize,
                        ),
                      ),
                      onPressed: () async {
                        await showPopupAboutMe(context);
                      },
                    ),
                  ),
                  Spacer(),
                  DonationItem(
                    price: 1,
                    purchaseId: InAppPurchases.donationEuro1,
                  ),
                  DonationItem(
                    price: 2,
                    purchaseId: InAppPurchases.donationEuro2,
                  ),
                  DonationItem(
                    price: 5,
                    purchaseId: InAppPurchases.donationEuro5,
                  ),
                  DonationItem(
                    price: 10,
                    purchaseId: InAppPurchases.donationEuro10,
                  ),
                  DonationItem(
                    price: 25,
                    purchaseId: InAppPurchases.donationEuro25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonationItem extends StatelessWidget {
  final double price;
  final String purchaseId;

  DonationItem({@required this.price, @required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Donation of € ${tryConvertDoubleToInt(price)}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
                ),
              ),
              Text(
                'Donations can only be paid for through Google Pay',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        onTap: () async {
          ProductDetails product =
              globals.inAppPurchases.getProductDetails(purchaseId);

          if (product != null) {
            await globals.inAppPurchases.buyProduct(product);
          } else {
            await showPopupError(
              context,
              "Donation not available",
              "Donations aren't available. Please try again later.",
            );
          }
        },
      ),
    );
  }
}
