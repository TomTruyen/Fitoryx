import 'package:fitoryx/utils/utils.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final String title;
  final String selectedValue;
  final String defaultValue;
  final List<String> options;
  final Function(String) onSelect;

  const Dropdown({
    Key? key,
    this.title = "",
    this.selectedValue = "",
    this.defaultValue = "None",
    required this.options,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title),
            Text(selectedValue == "" ? "None" : selectedValue)
          ],
        ),
        onTap: () {
          clearFocus(context);
          _showDropdownPopup(context);
        },
      ),
    );
  }

  void _showDropdownPopup(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.width * 0.2,
              maxHeight: MediaQuery.of(context).size.width * 0.8,
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.all(16),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(options[i]),
                  onTap: () {
                    onSelect(options[i]);

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                );
              },
              itemCount: options.length,
            ),
          ),
        );
      },
    );
  }
}
