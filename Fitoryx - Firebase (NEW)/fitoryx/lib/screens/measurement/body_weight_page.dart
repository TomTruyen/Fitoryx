import 'package:fitoryx/graphs/measurement_graph.dart';
import 'package:fitoryx/graphs/placeholder_graph.dart';
import 'package:fitoryx/models/body_weight.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/subscription.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/providers/subscription_provider.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/graph_card.dart';
import 'package:fitoryx/widgets/input_dialog.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BodyWeightPage extends StatefulWidget {
  const BodyWeightPage({Key? key}) : super(key: key);

  @override
  State<BodyWeightPage> createState() => _BodyWeightPageState();
}

class _BodyWeightPageState extends State<BodyWeightPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  List<BodyWeight> _bodyweight = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final _subscription =
        Provider.of<SubscriptionProvider>(context).subscription;

    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            title: const Text('Bodyweight'),
            leading: const CloseButton(),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await showInputDialog(
                      context,
                      "Bodyweight",
                      UnitTypeHelper.toValue(_settings.weightUnit),
                      0, (double value) async {
                    try {
                      if (value <= 0) {
                        return;
                      }

                      var bodyweight =
                          BodyWeight(weight: value, unit: _settings.weightUnit);

                      var newBodyWeight =
                          await _firestoreService.saveBodyWeight(bodyweight);

                      setState(() {
                        _bodyweight.insert(0, newBodyWeight);
                      });
                    } catch (e) {
                      showAlert(context, content: "Failed to save bodyweight");
                    }
                  });
                },
              )
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: GraphCard(
                    title:
                        "Weight (${UnitTypeHelper.toValue(_settings.weightUnit)})",
                    height: 225,
                    graph: Container(
                      padding: const EdgeInsets.all(8),
                      child: _subscription is FreeSubscription
                          ? const PlaceholderGraph()
                          : MeasurementGraph(
                              data: _bodyweight.reversed.toList(),
                            ),
                    ),
                  ),
                ),
                const ListDivider(
                  text: 'History',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: _bodyweight.isEmpty
                        ? const Center(child: Text("No history"))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              BodyWeight bodyweight = _bodyweight[index];

                              return ListTile(
                                dense: true,
                                title: Text(
                                  "${DateFormat("dd MMM yyyy").format(
                                    bodyweight.date,
                                  )} ${DateFormat("HH:mm").format(
                                    bodyweight.date,
                                  )}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Text(
                                  "${bodyweight.weight.toIntString()} ${UnitTypeHelper.toValue(_settings.weightUnit)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                            itemCount: _bodyweight.length,
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
    var bodyweight = await _firestoreService.getBodyWeight();

    for (int i = 0; i < bodyweight.length; i++) {
      if (bodyweight[i].unit != settings.weightUnit) {
        bodyweight[i].changeUnit(_settings.weightUnit);
      }
    }

    setState(() {
      _settings = settings;
      _bodyweight = bodyweight;
    });
  }
}
