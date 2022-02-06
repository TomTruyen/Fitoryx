import 'package:fitoryx/graphs/nutrition_calories_graph.dart';
import 'package:fitoryx/graphs/nutrition_macro_graph.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/screens/measurement/add_nutrition_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/graph_card.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/nutrition_history_card.dart';
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
        physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            title: const Text('Nutrition'),
            leading: const CloseButton(),
            actions: <Widget>[
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
            hasScrollBody: true,
            child: _loading
                ? const Loader()
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: 225,
                        child: GraphCard(
                          title: "Daily nutrition",
                          height: 225,
                          graph: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: NutritionCaloriesGraph(
                                  nutrition: _nutrition,
                                  settings: _settings,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: NutritionMacroGraph(
                                  nutrition: _nutrition,
                                  settings: _settings,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const ListDivider(
                        text: 'History',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              Nutrition nutrition = _nutritions[index];

                              return NutritionHistoryCard(nutrition: nutrition);
                            },
                            itemCount: _nutritions.length,
                          ),
                        ),
                      ),
                    ],
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
      _nutritions = nutritions.reversed.toList();
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
