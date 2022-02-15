import 'package:fitoryx/models/popup_option.dart';
import 'package:fitoryx/widgets/popup_menu_option.dart';
import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  final bool isHeader;
  final List<PopupOption> items;
  final void Function(dynamic) onSelected;

  const PopupMenu({
    Key? key,
    this.isHeader = false,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  List<PopupMenuEntry> _buildItems(BuildContext context) {
    List<PopupMenuEntry> entries = [];

    for (var item in items) {
      entries.add(
        buildPopupMenuItem(context, item.value, item.text),
      );

      if (items.last != item) {
        entries.add(const PopupMenuDivider());
      }
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isHeader ? null : const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(
          cardColor: const Color.fromRGBO(35, 35, 35, 1),
          dividerColor: const Color.fromRGBO(150, 150, 150, 1),
        ),
        child: PopupMenuButton(
          offset: const Offset(0, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          icon: Icon(
            Icons.more_vert,
            color: isHeader ? Colors.black : Theme.of(context).primaryColor,
          ),
          onSelected: onSelected,
          itemBuilder: (BuildContext context) => _buildItems(context),
        ),
      ),
    );
  }
}
