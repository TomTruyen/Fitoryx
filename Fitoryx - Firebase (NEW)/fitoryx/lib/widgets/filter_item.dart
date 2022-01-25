import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  final String value;
  final bool selected;
  final Function() onTap;

  const FilterItem({
    Key? key,
    required this.value,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: selected ? _selectedStyle() : _defaultStyle(),
        child: Text(
          value,
          style: TextStyle(
            color: !selected ? Colors.blue[700] : Colors.white,
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! * 0.8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: onTap,
    );
  }

  BoxDecoration _selectedStyle() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.blueAccent[700]!,
          Colors.blueAccent[400]!,
          Colors.blueAccent[200]!,
        ],
        tileMode: TileMode.repeated,
      ),
      border: Border.all(color: Colors.transparent),
      borderRadius: const BorderRadius.all(
        Radius.circular(12.0),
      ),
    );
  }

  BoxDecoration _defaultStyle() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.blueAccent[400]!),
      borderRadius: const BorderRadius.all(
        Radius.circular(12.0),
      ),
    );
  }
}
