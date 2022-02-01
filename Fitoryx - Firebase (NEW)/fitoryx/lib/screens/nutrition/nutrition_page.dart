import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/food_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({Key? key}) : super(key: key);

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: const Text('Nutrition'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   CupertinoPageRoute(
                  //     fullscreenDialog: true,
                  //     builder: (context) => FoodAddPage(updateFood: updateFood),
                  //   ),
                  // );
                },
              ),
            ],
          ),
          // SliverFillRemaining(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(vertical: 8.0),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.max,
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: <Widget>[
          //         Expanded(
          //           flex: 3,
          //           child: FoodCard(
          //             value: 
          //             goal: _settings.kcal,
          //             text: 'kcal',
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _init() async {
    var settings = await _settingsService.getSettings();

    _settings = settings;
  }
}
