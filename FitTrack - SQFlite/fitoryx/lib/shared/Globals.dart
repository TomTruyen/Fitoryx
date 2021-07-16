import 'package:Fitoryx/screens/donation/DonationPage.dart';
import 'package:Fitoryx/services/InAppPurchases.dart';
import 'package:Fitoryx/services/SQLDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SQLDatabase sqlDatabase;
InAppPurchases inAppPurchases;

IconButton getDonationButton(BuildContext context) {
  return IconButton(
    icon: Icon(
      Icons.favorite,
      color: Colors.red,
    ),
    onPressed: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => DonationPage(),
        ),
      );
    },
  );
}

enum PageEnum {
  // globals.PageEnum.workout.index to get the index value for the 'changePage' function
  profile,
  history,
  workout,
  exercises,
  food,
}
