import 'package:fitoryx/graphs/nutrition_graph.dart';
import 'package:fitoryx/graphs/volume_graph.dart';
import 'package:fitoryx/graphs/workouts_per_week_graph.dart';
import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/models/popup_option.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/screens/settings/settings_page.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/utils/graph_type_extension.dart';
import 'package:fitoryx/widgets/amount_picker_dialog.dart';
import 'package:fitoryx/widgets/graph_card.dart';
import 'package:fitoryx/widgets/graphs_dialog.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:fitoryx/widgets/popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final SettingsService _settingsService = SettingsService();

  Settings _settings = Settings();
  List<WorkoutHistory> _history = [];
  List<Nutrition> _nutrition = [];

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
            floating: true,
            pinned: true,
            title: const Text('Profile'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _authService.getUser()?.email ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${_history.length} workouts",
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const ListDivider(
                    text: 'Dashboard',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      primary: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.remove_red_eye),
                        SizedBox(width: 5.0),
                        Text('Toggle graphs'),
                      ],
                    ),
                    onPressed: () async {
                      _settings.graphs =
                          await showGraphsDialog(context, _settings.graphs);

                      await _settingsService.setGraphs(_settings.graphs);

                      _updateSettings();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_settings.graphs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 56,
                  ),
                  child: const Text('No graphs to show'),
                ),
              ),
            ),
          if (_settings.graphs.isNotEmpty)
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (_settings.graphs.has(GraphType.workouts))
                    GraphCard(
                      title: 'Workouts per week',
                      graph: WorkoutsPerWeekGraph(
                        history: _history,
                        goal: _settings.goals.workoutGoal,
                      ),
                      popup: PopupMenu(
                        isHeader: true,
                        items: <PopupOption>[
                          PopupOption(text: 'Edit goal', value: 'goal')
                        ],
                        onSelected: (selection) async {
                          switch (selection) {
                            case 'goal':
                              _settings.goals.workoutGoal =
                                  await showAmountPicker(
                                context,
                                title: 'Edit goal',
                                goal: _settings.goals.workoutGoal,
                                amount: 7,
                              );

                              _updateGoals();
                          }
                        },
                      ),
                    ),
                  if (_settings.graphs.has(GraphType.calories))
                    GraphCard(
                      title: 'Calories this week',
                      graph: Container(
                        padding: const EdgeInsets.all(8),
                        child: NutritionGraph(
                          nutritions: _nutrition,
                        ),
                      ),
                    ),
                  if (_settings.graphs.has(GraphType.volume))
                    GraphCard(
                      title: 'Volume this week',
                      graph: Container(
                        padding: const EdgeInsets.all(8),
                        child: VolumeGraph(
                          workouts: _history,
                          settings: _settings,
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
    var settings = await _settingsService.getSettings();
    var history = await _firestoreService.getHistory();
    var nutrition = await _firestoreService.getNutrition();

    setState(() {
      _settings = settings;
      _history = history;
      _nutrition = nutrition;
    });
  }

  void _updateGoals() async {
    await _settingsService.setGraphGoals(_settings.goals);
    _updateSettings();
  }

  void _updateSettings() async {
    setState(() {
      _settings = _settings;
    });
  }
}
