import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/widgets/nutrition_history_card.dart';
import 'package:fitoryx/widgets/sort_button.dart';
import 'package:flutter/material.dart';

class NutritionHistoryPage extends StatefulWidget {
  final List<Nutrition> nutritions;

  const NutritionHistoryPage({Key? key, required this.nutritions})
      : super(key: key);

  @override
  State<NutritionHistoryPage> createState() => _NutritionHistoryPageState();
}

class _NutritionHistoryPageState extends State<NutritionHistoryPage> {
  bool isAscending = false;
  List<Nutrition> _nutritions = [];

  @override
  void initState() {
    super.initState();
    _nutritions = widget.nutritions;
    _sortHistory(noToggle: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: const Text('Nutrition History'),
            leading: const CloseButton(),
          ),
          if (_nutritions.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No Nutrition History.'),
              ),
            ),
          if (_nutritions.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: SortButton(
                  isAscending: !isAscending,
                  text: 'Sort by date',
                  onPressed: _sortHistory,
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Nutrition nutrition = _nutritions[index];

                return NutritionHistoryCard(nutrition: nutrition);
              },
              childCount: _nutritions.length,
            ),
          ),
        ],
      ),
    );
  }

  void _sortHistory({bool noToggle = false}) {
    if (!noToggle) {
      isAscending = !isAscending;
    }

    _nutritions.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    if (!isAscending) {
      _nutritions = _nutritions.reversed.toList();
    }

    setState(() {
      _nutritions = _nutritions;
    });
  }
}
