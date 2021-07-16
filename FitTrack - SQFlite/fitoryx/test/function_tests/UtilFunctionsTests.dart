import 'package:Fitoryx/functions/Functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'UtilFunctions',
    () {
      recalculateWeightTests();
      requiresDateDividerTests();
      getFoodGoalStringTests();
    },
  );
}

void recalculateWeightTests() {
  test(
    'recalculateWeight should return double',
    () {
      double value = 20;
      String newWeightUnit = "kg";

      dynamic result = recalculateWeight(value, newWeightUnit);

      expect(result, isInstanceOf<double>(),
          reason:
              "Result should be of type 'double' but was of type ${result.runtimeType}");
    },
  );

  test(
    'recalculateWeight should return recalculated weight in kg when converting from lbs',
    () {
      double value = 45;
      String newWeightUnit = "kg";

      double expectedResult = 20.4;

      dynamic result = recalculateWeight(value, newWeightUnit);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );

  test(
    'recalculateWeight should return recalculated weight in lbs when converting from kg',
    () {
      double value = 20.4;
      String newWeightUnit = "lbs";

      double expectedResult = 45;

      dynamic result = recalculateWeight(value, newWeightUnit);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );
}

void requiresDateDividerTests() {
  test(
    'requiresDateDivider should return bool',
    () {
      DateTime date = DateTime(2021, 3, 2);
      int currentMonth = 3;
      int currentYear = 2021;

      dynamic result = requiresDateDivider(date, currentMonth, currentYear);

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result should be of type 'bool' but was of type ${result.runtimeType}");
    },
  );

  test(
    'requiresDateDivider should return false when month and year are the same as date month and year',
    () {
      DateTime date = DateTime(2021, 3, 2);
      int currentMonth = 3;
      int currentYear = 2021;

      dynamic result = requiresDateDivider(date, currentMonth, currentYear);

      expect(result, false, reason: "Result was 'true' but expected 'false'");
    },
  );

  test(
    'requiresDateDivider should return true when month and year are the not same as date month and year',
    () {
      DateTime date = DateTime(2021, 3, 2);
      int currentMonth = 2;
      int currentYear = 2021;

      dynamic result = requiresDateDivider(date, currentMonth, currentYear);

      expect(result, true, reason: "Result was 'false' but expected 'true'");
    },
  );
}

void getFoodGoalStringTests() {
  test(
    'getFoodGoalStringTests should return String',
    () {
      double value = 100;
      double goal = 300;
      String measurement = "g";

      dynamic result = getFoodGoalString(value, goal, measurement);

      expect(result, isInstanceOf<String>(),
          reason:
              "Result should be of type 'String' but was of type ${result.runtimeType}");
    },
  );

  test(
    'getFoodGoalStringTests should return string without goal when goal is null',
    () {
      double value = 100;
      String measurement = "g";

      String expectedResult = "100g";

      dynamic result = getFoodGoalString(value, null, measurement);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );

  test(
    'getFoodGoalStringTests should return string with goal when goal is not null',
    () {
      double value = 100;
      double goal = 300;
      String measurement = "g";

      String expectedResult = "100 / 300g";

      dynamic result = getFoodGoalString(value, goal, measurement);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );
}
