import 'dart:math';

import 'package:fitness_app/models/exercises/ExerciseFilter.dart';
import 'package:fitness_app/pages/exercises/ExercisePage.dart';
import 'package:fitness_app/pages/food/FoodPage.dart';
import 'package:fitness_app/pages/profile/ProfilePage.dart';
import 'package:fitness_app/pages/history/HistoryPage.dart';
import 'package:fitness_app/pages/workout/WorkoutPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 2;

  final _pages = <Widget>[
    new ProfilePage(),
    new HistoryPage(),
    new WorkoutPage(),
    new ExercisePage(),
    new FoodPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter exerciseFilter =
        Provider.of<ExerciseFilter>(context, listen: false) ?? null;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          if (index == 3 && exerciseFilter != null) {
            exerciseFilter.clearFilters();
          }

          setState(() {
            _selectedIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: -pi / 4,
              child: Icon(Icons.fitness_center),
            ),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
        ],
      ),
    );
  }
}
