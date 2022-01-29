import 'package:fitoryx/models/settings_item.dart';
import 'package:fitoryx/models/settings_type.dart';
import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsGroup({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: _buildItems(context),
        ),
        const Divider(color: Color.fromRGBO(70, 70, 70, 1)),
      ],
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    List<Widget> children = [];

    for (var item in items) {
      switch (item.type) {
        case SettingsType.listTile:
          var tile = ListTile(
              title: Text(item.title),
              subtitle: item.subtitle != null
                  ? Text(
                      item.subtitle!,
                      style: Theme.of(context).textTheme.caption,
                    )
                  : null,
              onTap: item.onTap);

          children.add(tile);
          break;
        case SettingsType.switchTile:
          var tile = SwitchListTile(
            activeColor: Colors.blueAccent[700],
            title: Text(item.title),
            subtitle: item.subtitle != null
                ? Text(
                    item.subtitle!,
                    style: Theme.of(context).textTheme.caption,
                  )
                : null,
            value: item.enabled ?? false,
            onChanged: item.onChanged,
          );

          children.add(tile);
          break;
      }
    }

    return children;
  }
}
