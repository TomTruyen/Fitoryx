import 'package:flutter/material.dart';

class FoodSliderCard extends StatelessWidget {
  final String name;
  final int value;
  final Function setValue;
  final int min;
  final int max;
  final bool isSetting;

  FoodSliderCard({
    this.name = "",
    this.value = 0,
    this.setValue,
    this.min = 0,
    this.max = 2500,
    this.isSetting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              fontSize: isSetting ? 12.0 : 14.0,
              color: Colors.grey[700],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: isSetting ? 18.0 : 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                name == 'CALORIES' ? 'KCAL' : 'G',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RawMaterialButton(
                  child: Icon(
                    Icons.remove,
                    size: isSetting ? 18.0 : 20.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (value > min) {
                      setValue(name, value - 1);
                    }
                  },
                  shape: CircleBorder(),
                  elevation: 6.0,
                  fillColor: Theme.of(context).accentColor,
                  constraints: isSetting
                      ? BoxConstraints.tightFor(width: 26.0, height: 26.0)
                      : BoxConstraints.tightFor(width: 30.0, height: 30.0),
                ),
              ),
              Expanded(
                flex: 10,
                child: Slider(
                  min: min.toDouble(),
                  max: max.toDouble(),
                  value: value.toDouble(),
                  onChanged: (double val) {
                    setValue(name, int.parse(val.toStringAsFixed(0)));
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: RawMaterialButton(
                  child: Icon(
                    Icons.add,
                    size: isSetting ? 18.0 : 20.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (value < max) {
                      setValue(name, value + 1);
                    }
                  },
                  shape: CircleBorder(),
                  elevation: 6.0,
                  fillColor: Theme.of(context).accentColor,
                  constraints: isSetting
                      ? BoxConstraints.tightFor(width: 26.0, height: 26.0)
                      : BoxConstraints.tightFor(width: 30.0, height: 30.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
