import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

class FoodHistoryPage extends StatelessWidget {
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
              'Nutrition History',
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
          SliverToBoxAdapter(
            child: Text(
              'Sort Button zoals op workout & food page. SliverList met allemaal cards met datum, kcal, macros. Eventueel nog dividers per maand / jaar hierin',
            ),
          ),
        ],
      ),
    );
  }
}
