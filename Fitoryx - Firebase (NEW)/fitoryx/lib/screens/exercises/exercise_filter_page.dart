import 'package:fitoryx/data/category_list.dart' as default_categories;
import 'package:fitoryx/data/equipment_list.dart' as default_equipment;
import 'package:fitoryx/data/type_list.dart' as default_types;
import 'package:fitoryx/models/exercise_filter.dart';
import 'package:fitoryx/widgets/filter_list.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseFilterPage extends StatelessWidget {
  const ExerciseFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter _filter = Provider.of<ExerciseFilter>(context);

    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey[50],
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                'Filter (${_filter.count})',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FilterList(
                      title: 'Category',
                      items: default_categories.categories,
                      selectedItems: _filter.categories,
                      addItem: _filter.addCategory,
                      removeItem: _filter.removeCategory,
                    ),
                    const SizedBox(height: 20.0),
                    FilterList(
                      title: 'Equipment',
                      items: default_equipment.equipment,
                      selectedItems: _filter.equipments,
                      addItem: _filter.addEquipment,
                      removeItem: _filter.removeEquipment,
                    ),
                    const SizedBox(height: 20.0),
                    FilterList(
                      title: 'Type',
                      items: default_types.types,
                      selectedItems: _filter.types,
                      addItem: _filter.addType,
                      removeItem: _filter.removeType,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        width: MediaQuery.of(context).size.width,
        child: GradientButton(
          text: 'Clear Filters',
          onPressed: () {
            _filter.clear();
          },
        ),
      ),
    );
  }
}
