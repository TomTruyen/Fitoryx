import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/nutrition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Nutrition', () {
    test('isEmpty should return true if values are 0', () {
      var nutrition = Nutrition(kcal: 0, carbs: 0, protein: 0, fat: 0);

      expect(nutrition.isEmpty(), true);

      nutrition.kcal = 1;
      expect(nutrition.isEmpty(), false);
    });

    test('toJson should return json Map from Nutrition', () {
      var date = DateTime.now();

      var expected = {
        "id": "123",
        "kcal": 0,
        "carbs": 0,
        "protein": 0,
        "fat": 0,
        "date": date,
      };

      var nutrition = Nutrition(
        id: "123",
        kcal: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
      );

      nutrition.date = date;

      expect(nutrition.toJson(), expected);
    });

    test('fromJson should return Nutrition from json Map', () {
      var date = DateTime.now();

      var json = {
        "id": "123",
        "kcal": 0,
        "carbs": 0,
        "protein": 0,
        "fat": 0,
        "date": Timestamp.fromDate(date),
      };

      var result = Nutrition.fromJson(json);

      expect(result.id, "123");
      expect(result.kcal, 0);
      expect(result.carbs, 0);
      expect(result.protein, 0);
      expect(result.fat, 0);
      expect(result.date, date);
    });
  });
}
