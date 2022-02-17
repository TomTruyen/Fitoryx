import 'package:fitoryx/models/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitType', () {
    test('toValue should return string from enum', () {
      expect(UnitTypeHelper.toValue(UnitType.metric), "kg");
      expect(UnitTypeHelper.toValue(UnitType.imperial), "lbs");
    });

    test('fromValue should return enum from string', () {
      expect(UnitTypeHelper.fromValue("kg"), UnitType.metric);
      expect(UnitTypeHelper.fromValue("lbs"), UnitType.imperial);
      expect(UnitTypeHelper.fromValue("kg"), UnitType.metric);
    });

    test('toSubtitle should return formatted subtitle', () {
      expect(UnitTypeHelper.toSubtitle(UnitType.metric), "Metric (kg)");
      expect(UnitTypeHelper.toSubtitle(UnitType.imperial), "Imperial (lbs)");
    });
  });
}
