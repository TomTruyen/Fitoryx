import 'package:fitoryx/screens/measurement/body_weight_page.dart';
import 'package:fitoryx/screens/measurement/fat_percentage_page.dart';
import 'package:fitoryx/screens/measurement/nutrition_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeasurementPage extends StatelessWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          const SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            title: Text('Measurements'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  title: const Text('Nutrition'),
                  subtitle: Text(
                    'Track calories and macro\'s',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const NutritionPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Bodyweight'),
                  subtitle: Text(
                    'Track your weight',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const BodyWeightPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Fat percentage'),
                  subtitle: Text(
                    'Track your fat percentage',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const FatPercentagePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
