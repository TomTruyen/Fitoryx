import 'package:fitoryx/models/unit_type.dart';
import 'package:flutter/material.dart';

class WeightHeaderRow extends StatelessWidget {
  final UnitType unit;

  const WeightHeaderRow({Key? key, this.unit = UnitType.metric})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          flex: 1,
          child: Text(
            'SET',
            style: TextStyle(fontSize: 11.0),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            UnitTypeHelper.toValue(unit).toUpperCase(),
            style: const TextStyle(fontSize: 11.0),
            textAlign: TextAlign.center,
          ),
        ),
        const Expanded(
          flex: 3,
          child: Text(
            "REPS",
            style: TextStyle(fontSize: 11.0),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(flex: 1)
      ],
    );
  }
}
