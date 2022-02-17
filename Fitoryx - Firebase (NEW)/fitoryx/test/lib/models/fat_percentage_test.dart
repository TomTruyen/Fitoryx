import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitoryx/models/fat_percentage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FatPercentage', () {
    test('toJson should return json from FatPercentage', () {
      var date = DateTime.now();

      var expected = {
        "id": "123",
        "percentage": 10,
        "date": date,
      };

      var fatPercentage = FatPercentage(id: "123", percentage: 10);
      fatPercentage.date = date;

      expect(fatPercentage.toJson(), expected);
    });

    test('fromJson should return FatPercentage from json Map', () {
      var date = DateTime.now();
      var json = {
        "id": "123",
        "percentage": 10,
        "date": Timestamp.fromDate(date),
      };

      var result = FatPercentage.fromJson(json);

      expect(result.id, "123");
      expect(result.percentage, 10);
      expect(result.date, date);
    });
  });
}
