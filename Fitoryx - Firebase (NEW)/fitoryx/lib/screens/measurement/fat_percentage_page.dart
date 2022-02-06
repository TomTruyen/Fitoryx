import 'package:fitoryx/graphs/measurement_graph.dart';
import 'package:fitoryx/models/fat_percentage.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/double_extension.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/graph_card.dart';
import 'package:fitoryx/widgets/input_dialog.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FatPercentagePage extends StatefulWidget {
  const FatPercentagePage({Key? key}) : super(key: key);

  @override
  State<FatPercentagePage> createState() => _FatPercentagePageState();
}

class _FatPercentagePageState extends State<FatPercentagePage> {
  final FirestoreService _firestoreService = FirestoreService();

  List<FatPercentage> _percentage = [];

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
            title: const Text('Fat Percentage'),
            leading: const CloseButton(),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await showInputDialog(context, "Fat percentage", "%", 0,
                      (double value) async {
                    try {
                      if (value > 100) value = 100;

                      var percentage = FatPercentage(percentage: value);

                      var newPercentage =
                          await _firestoreService.saveFatPercentage(percentage);

                      setState(() {
                        _percentage.insert(0, newPercentage);
                      });
                    } catch (e) {
                      showAlert(
                        context,
                        content: "Failed to save fat percentage",
                      );
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
                    title: "Fat percentage",
                    height: 225,
                    graph: Container(
                      padding: const EdgeInsets.all(8),
                      child: MeasurementGraph(
                        data: _percentage.reversed.toList(),
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
                    child: _percentage.isEmpty
                        ? const Center(child: Text("No history"))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              FatPercentage fat = _percentage[index];

                              return ListTile(
                                dense: true,
                                title: Text(
                                  "${DateFormat("dd MMM yyyy").format(
                                    fat.date,
                                  )} ${DateFormat("HH:mm").format(
                                    fat.date,
                                  )}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Text(
                                  "${fat.percentage.toIntString()}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                            itemCount: _percentage.length,
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
    var percentage = await _firestoreService.getFatPercentage();

    setState(() {
      _percentage = percentage;
    });
  }
}
