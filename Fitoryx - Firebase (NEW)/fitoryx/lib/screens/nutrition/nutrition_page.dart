import 'package:fitoryx/graphs/nutrition_graph.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/screens/nutrition/add_nutrition_page.dart';
import 'package:fitoryx/screens/nutrition/nutrition_history_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/nutrition_card.dart';
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

  List<Nutrition> _nutritions = [];
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
                icon: const Icon(Icons.watch_later_outlined),
                onPressed: () {
                  var historyList = List.of(_nutritions);
                  historyList.removeLast();

                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => NutritionHistoryPage(
                        nutritions: historyList,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => AddNutritionPage(
                        nutrition: _nutrition,
                        updateNutrition: _updateNutrition,
                      ),
                    ),
                  );
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
                          flex: 4,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3.0,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: const Text(
                                        'Last week (calories)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      child: NutritionGraph(
                                        nutritions: _nutritions,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: NutritionCard(
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
                              child: NutritionCard(
                                value: _nutrition.carbs,
                                goal: _settings.carbs,
                                text: 'carbs',
                                macro: true,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 3.0,
                              width: MediaQuery.of(context).size.width / 3.0,
                              child: NutritionCard(
                                value: _nutrition.protein,
                                goal: _settings.protein,
                                text: 'protein',
                                macro: true,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 3.0,
                              width: MediaQuery.of(context).size.width / 3.0,
                              child: NutritionCard(
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
    var nutritions = await _firestoreService.getNutrition();
    var nutrition = await _firestoreService.getNutritionByDay(DateTime.now());
    var settings = await _settingsService.getSettings();

    setState(() {
      _nutritions = nutritions;
      _nutrition = nutrition;
      _settings = settings;
      _loading = false;
    });
  }

  void _updateNutrition(Nutrition nutrition) {
    int index = _nutritions.indexWhere(
      (n) => n.date.isAtSameMomentAs(nutrition.date),
    );

    if (index > -1) {
      _nutritions[index] = nutrition;
    } else {
      _nutritions.add(nutrition);
    }

    setState(() {
      _nutrition = nutrition;
    });
  }
}
