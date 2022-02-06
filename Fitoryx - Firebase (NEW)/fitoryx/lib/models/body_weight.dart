import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/utils/double_extension.dart';

class BodyWeight {
  String? id;
  double weight;
  UnitType unit;
  DateTime date = DateTime.now();

  BodyWeight({this.id, this.weight = 0, this.unit = UnitType.metric});

  void changeUnit(UnitType newUnit) {
    switch (newUnit) {
      case UnitType.metric:
        // Convert lbs to kg (x / 2.205)
        weight = (weight / 2.205).toDecimalPlaces(2);

        break;
      case UnitType.imperial:
        // Convert kg to lbs (x * 2.205)
        weight = (weight * 2.205).toDecimalPlaces(2);

        break;
    }

    unit = newUnit;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "weight": weight,
      "unit": UnitTypeHelper.toValue(unit),
      "date": date,
    };
  }

  static BodyWeight fromJson(Map<String, dynamic> json) {
    var bodyWeight = BodyWeight(
      id: json['id'],
      weight: json['weight'],
      unit: UnitTypeHelper.fromValue(json['unit']),
    );

    bodyWeight.date = json['date']?.toDate();

    return bodyWeight;
  }
}
