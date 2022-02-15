import 'dart:math';

import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/screens/exercises/exercises_page.dart';
import 'package:fitoryx/screens/history/history_page.dart';
import 'package:fitoryx/screens/measurement/measurement_page.dart';
import 'package:fitoryx/screens/profile/profile_page.dart';
import 'package:fitoryx/screens/workout/workout_page.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/purchase_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  late Future<bool> _isLoaded;

  int _selectedIndex = 2;

  List<Widget> _pages = [];

  @override
  void initState() {
    _isLoaded = _firestoreService.fetchAll();

    try {
      PurchaseService.login(_authService.getUser()?.uid);
    } catch (e) {
      showAlert(
        context,
        content:
            "Couldn't get subscriptions. If you have an active Fitoryx Pro subscription then please try to restart the app.",
      );
    }

    super.initState();

    setState(() {
      _pages = [
        const ProfilePage(),
        const HistoryPage(),
        const WorkoutPage(),
        const ExercisesPages(),
        const MeasurementPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter _filter = Provider.of<ExerciseFilter>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: FutureBuilder(
          future: _isLoaded,
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _pages[_selectedIndex],
            );
          },
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
              activeIcon: Icon(
                Icons.person_outline,
                color: Theme.of(context).primaryColor,
              ),
              icon: const Icon(Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.watch_later_outlined,
                color: Theme.of(context).primaryColor,
              ),
              icon: const Icon(Icons.watch_later_outlined),
              label: 'History',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.add_outlined,
                color: Theme.of(context).primaryColor,
              ),
              icon: const Icon(Icons.add_outlined),
              label: 'Workout',
            ),
            BottomNavigationBarItem(
              activeIcon: Transform.rotate(
                angle: -pi / 4,
                child: Icon(
                  Icons.fitness_center_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              icon: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(Icons.fitness_center_outlined),
              ),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.restaurant_menu_outlined,
                color: Theme.of(context).primaryColor,
              ),
              icon: const Icon(Icons.restaurant_menu_outlined),
              label: 'Nutrition',
            ),
          ],
        ),
      ),
    );
  }
}
