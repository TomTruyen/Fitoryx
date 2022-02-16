import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/body_weight.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'constructor should set values',
    () {
      String id = "123";
      double weight = 123;
      UnitType unit = UnitType.metric;

      var result = BodyWeight(id: id, weight: weight, unit: unit);

      expect(result.id, id);
      expect(result.weight, weight);
      expect(result.unit, unit);
    },
  );

  test(
    'changeUnit should convert weights and set new unit',
    () {
      var result = BodyWeight(weight: 100, unit: UnitType.metric);

      result.changeUnit(UnitType.imperial);

      expect(result.weight, 220.50);
      expect(result.unit, UnitType.imperial);

      result.changeUnit(UnitType.metric);

      expect(result.weight, 100);
      expect(result.unit, UnitType.metric);

      // Check for nothing to change when newUnit is the same as old unit
      result.changeUnit(UnitType.metric);

      expect(result.weight, 100);
      expect(result.unit, UnitType.metric);
    },
  );

  test(
    'toJson should convert to json Map',
    () {
      Map<String, dynamic> expected = {
        "id": "123",
        "weight": 123.00,
        "unit": "kg",
        "date": DateTime.now()
      };

      var bodyweight = BodyWeight();
      bodyweight.id = expected["id"];
      bodyweight.weight = expected["weight"];
      bodyweight.unit = UnitType.metric;
      bodyweight.date = expected["date"];

      var result = bodyweight.toJson();

      expect(result, expected);
    },
  );

  test(
    'fromJson should convert json to BodyWeight instance',
    () {
      var date = DateTime.now();

      Map<String, dynamic> json = {
        "id": "123",
        "weight": 123,
        "unit": "kg",
        "date": Timestamp.fromDate(date),
      };

      var result = BodyWeight.fromJson(json);

      expect(result.id, json["id"]);
      expect(result.weight, json["weight"]);
      expect(result.unit, UnitType.metric);
      expect(result.date, date);
    },
  );
}
