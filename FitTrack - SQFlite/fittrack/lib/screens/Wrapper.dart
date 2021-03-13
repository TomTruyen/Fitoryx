import 'dart:math';

import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/screens/food/FoodPage.dart';
import 'package:fittrack/screens/history/HistoryPage.dart';
import 'package:fittrack/screens/profile/ProfilePage.dart';
import 'package:fittrack/screens/workout/WorkoutPage.dart';
import 'package:fittrack/services/InAppPurchases.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:fittrack/shared/GradientIcon.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    getSharedPreferences();

    globals.inAppPurchases = InAppPurchases();
    globals.inAppPurchases.initialize();

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

  @override
  void dispose() {
    super.dispose();
    globals.inAppPurchases?.dispose();
  }

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownReview = prefs.getBool('reviewShown');
    if (hasShownReview == false || hasShownReview == null) {
      int amountOfTimeAppWasOpened = prefs.getInt('amountOpened');
      if (amountOfTimeAppWasOpened == null) {
        prefs.setInt('amountOpened', 1);
      } else if (amountOfTimeAppWasOpened < 5) {
        prefs.setInt('amountOpened', amountOfTimeAppWasOpened + 1);
      } else if (amountOfTimeAppWasOpened == 5) {
        final InAppReview inAppReview = InAppReview.instance;

        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();

          prefs.setBool('reviewShown', true);
        }
      }
    }
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
            activeIcon: GradientIcon(
              icon: Icon(Icons.person_outline),
            ),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            activeIcon: GradientIcon(
              icon: Icon(Icons.watch_later_outlined),
            ),
            icon: Icon(Icons.watch_later_outlined),
            label: 'History',
          ),
          BottomNavigationBarItem(
            activeIcon: GradientIcon(
              icon: Icon(Icons.add_outlined),
            ),
            icon: Icon(Icons.add_outlined),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            activeIcon: GradientIcon(
              icon: Transform.rotate(
                angle: -pi / 4,
                child: Icon(Icons.fitness_center_outlined),
              ),
            ),
            icon: Transform.rotate(
              angle: -pi / 4,
              child: Icon(Icons.fitness_center_outlined),
            ),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            activeIcon: GradientIcon(
              icon: Icon(Icons.restaurant_menu_outlined),
            ),
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Nutrition',
          ),
        ],
      ),
    );
  }
}
