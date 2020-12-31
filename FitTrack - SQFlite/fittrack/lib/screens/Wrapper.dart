import 'dart:math';
import 'package:flutter/material.dart';

import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/screens/food/FoodPage.dart';
import 'package:fittrack/screens/history/HistoryPage.dart';
import 'package:fittrack/screens/profile/ProfilePage.dart';
import 'package:fittrack/screens/workout/WorkoutPage.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 2;

  List<Widget> _pages = [
    ProfilePage(),
    HistoryPage(),
    WorkoutPage(),
    ExercisesPage(),
    FoodPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: -pi / 4,
              child: Icon(Icons.fitness_center_outlined),
            ),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Food',
          ),
        ],
      ),
    );
  }
}
