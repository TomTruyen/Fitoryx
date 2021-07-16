import 'dart:math';

import 'package:Fitoryx/models/exercises/ExerciseFilter.dart';
import 'package:Fitoryx/screens/exercises/ExercisesPage.dart';
import 'package:Fitoryx/screens/food/FoodPage.dart';
import 'package:Fitoryx/screens/history/HistoryPage.dart';
import 'package:Fitoryx/screens/profile/ProfilePage.dart';
import 'package:Fitoryx/screens/workout/WorkoutPage.dart';
import 'package:Fitoryx/services/InAppPurchases.dart';
import 'package:Fitoryx/shared/Globals.dart' as globals;
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              activeIcon: Icon(Icons.person_outline, color: Colors.blue[700]),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              activeIcon:
                  Icon(Icons.watch_later_outlined, color: Colors.blue[700]),
              icon: Icon(Icons.watch_later_outlined),
              label: 'History',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.add_outlined, color: Colors.blue[700]),
              icon: Icon(Icons.add_outlined),
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
                child: Icon(Icons.fitness_center_outlined),
              ),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              activeIcon:
                  Icon(Icons.restaurant_menu_outlined, color: Colors.blue[700]),
              icon: Icon(Icons.restaurant_menu_outlined),
              label: 'Nutrition',
            ),
          ],
        ),
      ),
    );
  }
}
