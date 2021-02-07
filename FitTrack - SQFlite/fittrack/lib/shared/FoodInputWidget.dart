import 'package:flutter/material.dart';

class FoodInputWidget extends StatelessWidget {
  final Function updateValue;
  final String name;
  final EdgeInsets padding;
  final String initialValue;

  FoodInputWidget({
    @required this.updateValue,
    @required this.name,
    this.padding,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding != null
          ? padding
          : EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue != null ? initialValue : '0',
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: Colors.grey[300],
          filled: true,
          hintText: '0.0',
          hintStyle: TextStyle(color: Colors.black54),
          suffixText: name.toUpperCase(),
        ),
        onChanged: (String value) {
          updateValue(double.parse(value), name);
        },
      ),
    );
  }
}
