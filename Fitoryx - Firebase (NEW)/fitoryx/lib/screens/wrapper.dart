import 'dart:math';

import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/screens/exercises/exercises_page.dart';
import 'package:fitoryx/screens/history/history_page.dart';
import 'package:fitoryx/screens/nutrition/nutrition_page.dart';
import 'package:fitoryx/screens/profile/profile_page.dart';
import 'package:fitoryx/screens/workout/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

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
        const ProfilePage(),
        const HistoryPage(),
        const WorkoutPage(),
        const ExercisesPages(),
        const NutritionPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter _filter = Provider.of<ExerciseFilter>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedFontSize: 0.0,
          selectedFontSize: 0.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            // ExercisesPage
            if (index == 2) {
              _filter.clear(includeSearch: true);
            }

            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person_outline, color: Colors.blue[700]),
              icon: const Icon(Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.watch_later_outlined,
                color: Colors.blue[700],
              ),
              icon: const Icon(Icons.watch_later_outlined),
              label: 'History',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.add_outlined, color: Colors.blue[700]),
              icon: const Icon(Icons.add_outlined),
              label: 'Workout',
            ),
            BottomNavigationBarItem(
              activeIcon: Transform.rotate(
                angle: -pi / 4,
                child: Icon(
                  Icons.fitness_center_outlined,
                  color: Colors.blue[700],
                ),
              ),
              icon: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(Icons.fitness_center_outlined),
              ),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              activeIcon:
                  Icon(Icons.restaurant_menu_outlined, color: Colors.blue[700]),
              icon: const Icon(Icons.restaurant_menu_outlined),
              label: 'Nutrition',
            ),
          ],
        ),
      ),
    );
  }
}
