import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
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
              'Food',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.watch_later_outlined),
                onPressed: () {
                  // navigate food history page
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // navigate to add page
        },
      ),
    );
  }
}
