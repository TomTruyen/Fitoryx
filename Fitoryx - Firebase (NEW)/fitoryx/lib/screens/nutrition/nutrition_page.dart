import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/food_card.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({Key? key}) : super(key: key);

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  bool _loading = true;

  final SettingsService _settingsService = SettingsService();
  final FirestoreService _firestoreService = FirestoreService();

  Nutrition _nutrition = Nutrition();
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
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: _loading
                  ? const Loader()
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: FoodCard(
                            value: _nutrition.kcal,
                            goal: _settings.kcal,
                            text: 'kcal',
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 3.0,
                              width: MediaQuery.of(context).size.width / 3.0,
                              child: FoodCard(
                                value: _nutrition.carbs,
                                goal: _settings.carbs,
                                text: 'carbs',
                                macro: true,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 3.0,
                              width: MediaQuery.of(context).size.width / 3.0,
                              child: FoodCard(
                                value: _nutrition.protein,
                                goal: _settings.protein,
                                text: 'protein',
                                macro: true,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 3.0,
                              width: MediaQuery.of(context).size.width / 3.0,
                              child: FoodCard(
                                value: _nutrition.fat,
                                goal: _settings.fat,
                                text: 'fat',
                                macro: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _init() async {
    var nutrition = await _firestoreService.getNutritionByDay(DateTime.now());
    var settings = await _settingsService.getSettings();

    setState(() {
      _nutrition = nutrition;
      _settings = settings;
      _loading = false;
    });
  }
}
