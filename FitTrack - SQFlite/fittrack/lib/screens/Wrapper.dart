import 'dart:math';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/screens/food/FoodPage.dart';
import 'package:fittrack/screens/history/HistoryPage.dart';
import 'package:fittrack/screens/profile/ProfilePage.dart';
import 'package:fittrack/screens/workout/WorkoutPage.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 2;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _pages = [
        ProfilePage(),
        HistoryPage(changePage: changePage),
        WorkoutPage(),
        ExercisesPage(),
        FoodPage()
      ];
    });
  }

  void changePage(int _newPageIndex) {
    if (_newPageIndex < _pages.length) {
      setState(() {
        _selectedIndex = _newPageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter filter = Provider.of<ExerciseFilter>(context) ?? null;

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
          if (index == globals.PageEnum.exercises.index) {
            filter?.clearAllFilters();
          }

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
