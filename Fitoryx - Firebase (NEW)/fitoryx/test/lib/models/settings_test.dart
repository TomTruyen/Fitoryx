import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Settings', () {
    test('constructor should set values', () {
      var result = Settings(
        weightUnit: UnitType.imperial,
        kcal: 50,
        carbs: 5,
        protein: 5,
        fat: 5,
        rest: 60,
        restEnabled: true,
        vibrateEnabled: false,
      );

      expect(result.weightUnit, UnitType.imperial);
      expect(result.kcal, 50);
      expect(result.carbs, 5);
      expect(result.protein, 5);
      expect(result.fat, 5);
      expect(result.rest, 60);
      expect(result.restEnabled, true);
      expect(result.vibrateEnabled, false);
    });
  });
}
