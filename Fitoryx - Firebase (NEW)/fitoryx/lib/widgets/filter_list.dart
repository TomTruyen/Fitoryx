import 'package:fitoryx/widgets/filter_item.dart';
import 'package:flutter/material.dart';

class FilterList extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final Function(String) addItem;
  final Function(String) removeItem;

  const FilterList({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.addItem,
    required this.removeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: _buildItems(),
        ),
      ],
    );
  }

  _buildItems() {
    List<FilterItem> filterItems = [];

    for (var item in items) {
      bool selected = selectedItems.contains(item);

      filterItems.add(
        FilterItem(
          value: item,
          selected: selected,
          onTap: () {
            if (selected) {
              removeItem(item);
            } else {
              addItem(item);
            }
          },
        ),
      );
    }

    return filterItems;
  }
}
