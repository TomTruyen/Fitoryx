import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/food/FoodPerHour.dart';
import 'package:Fitoryx/models/settings/GraphToShow.dart';
import 'package:Fitoryx/models/settings/UserWeight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConvertFunctions', () {
    tryConvertDoubleToIntTests();
    convertFoodPerHourListToJsonListTests();
    convertUserWeightListToJsonListTests();
    convertGraphToShowListToJsonListTests();
  });
}

void tryConvertDoubleToIntTests() {
  test(
    'tryConvertDoubleToInt should convert double to int if no decimals',
    () {
      double inputInt = 10.0;
      double inputInt2 = 8;
      double inputDouble = 8.52;

      dynamic resultInputInt = tryConvertDoubleToInt(inputInt);
      dynamic resultInputInt2 = tryConvertDoubleToInt(inputInt2);
      dynamic resultInputDouble = tryConvertDoubleToInt(inputDouble);

      expect(resultInputInt, isInstanceOf<int>(),
          reason:
              "Result should be of type 'int' but was of type ${resultInputInt.runtimeType}");

      expect(resultInputInt2, isInstanceOf<int>(),
          reason:
              "Result should be of type 'int' but was of type ${resultInputInt.runtimeType}");

      expect(resultInputDouble, isInstanceOf<double>(),
          reason:
              "Result should be of type 'double' but was of type ${resultInputInt.runtimeType}");
    },
  );
}

void convertFoodPerHourListToJsonListTests() {
  test(
    'convertFoodPerHourListToJsonList should return List<Map<String, dynamic>>',
    () {
      List<FoodPerHour> foodPerHourList = [
        FoodPerHour(kcal: 250, carbs: 125, protein: 62.5, fat: 25, hour: 5),
        FoodPerHour(kcal: 500, carbs: 250, protein: 125, fat: 50, hour: 10),
        FoodPerHour(kcal: 1000, carbs: 500, protein: 250, fat: 100, hour: 20),
      ];

      dynamic foodPerHourJsonList =
          convertFoodPerHourListToJsonList(foodPerHourList);

      expect(foodPerHourJsonList, isInstanceOf<List<Map<String, dynamic>>>(),
          reason:
              "Result should be of type 'List<Map<String, dynamic>> but was of type ${foodPerHourJsonList.runtimeType}");
    },
  );

  test(
    'convertFoodPerHourListToJsonList should convert List<FoodPerHour> to List<Map<String, dynamic>>',
    () {
      List<FoodPerHour> foodPerHourList = [
        FoodPerHour(kcal: 250, carbs: 125, protein: 62.5, fat: 25, hour: 5),
        FoodPerHour(kcal: 500, carbs: 250, protein: 125, fat: 50, hour: 10),
        FoodPerHour(kcal: 1000, carbs: 500, protein: 250, fat: 100, hour: 20),
      ];

      List<Map<String, dynamic>> expectedJsonList = [
        {
          'kcal': 250,
          'carbs': 125,
          'protein': 62.5,
          'fat': 25,
          'hour': 5,
        },
        {
          'kcal': 500,
          'carbs': 250,
          'protein': 125,
          'fat': 50,
          'hour': 10,
        },
        {
          'kcal': 1000,
          'carbs': 500,
          'protein': 250,
          'fat': 100,
          'hour': 20,
        },
      ];

      dynamic foodPerHourJsonList =
          convertFoodPerHourListToJsonList(foodPerHourList);

      expect(foodPerHourJsonList, hasLength(foodPerHourList.length),
          reason:
              "Result was expected to have ${foodPerHourList.length} values in List but has ${foodPerHourJsonList.length}");

      expect(foodPerHourJsonList, expectedJsonList,
          reason:
              "Result was expected to equal $expectedJsonList but was $foodPerHourJsonList");
    },
  );
}

void convertUserWeightListToJsonListTests() {
  test(
    'convertUserWeightListToJsonList should return List<Map<String, dynamic>>',
    () {
      List<UserWeight> userWeightList = [
        UserWeight(weight: 50, weightUnit: 'kg'),
        UserWeight(weight: 100, weightUnit: 'kg'),
        UserWeight(
          weight: 200,
          weightUnit: 'lbs',
          timeInMillisSinceEpoch: 1000,
        ),
      ];

      dynamic userWeightListJsonList =
          convertUserWeightListToJsonList(userWeightList);

      expect(userWeightListJsonList, isInstanceOf<List<Map<String, dynamic>>>(),
          reason:
              "Result should be of type 'List<Map<String, dynamic>> but was of type ${userWeightListJsonList.runtimeType}");
    },
  );

  test(
    'convertUserWeightListToJsonList should convert List<UserWeight> to List<Map<String, dynamic>>',
    () {
      List<UserWeight> userWeightList = [
        UserWeight(weight: 50, weightUnit: 'kg'),
        UserWeight(weight: 100, weightUnit: 'kg'),
        UserWeight(
          weight: 200,
          weightUnit: 'lbs',
          timeInMillisSinceEpoch: 1000,
        ),
      ];

      List<Map<String, dynamic>> expectedJsonList = [
        {
          'weight': 50,
          'weightUnit': 'kg',
          'timeInMilliseconds': 0,
        },
        {
          'weight': 100,
          'weightUnit': 'kg',
          'timeInMilliseconds': 0,
        },
        {
          'weight': 200,
          'weightUnit': 'lbs',
          'timeInMilliseconds': 1000,
        },
      ];

      dynamic userWeightListJsonList =
          convertUserWeightListToJsonList(userWeightList);

      expect(userWeightListJsonList, hasLength(userWeightList.length),
          reason:
              "Result was expected to have ${userWeightList.length} values in List but has ${userWeightListJsonList.length}");

      expect(userWeightListJsonList, expectedJsonList,
          reason:
              "Result was expected to equal $expectedJsonList but was $userWeightListJsonList");
    },
  );
}

void convertGraphToShowListToJsonListTests() {
  test(
    'convertGraphToShowListToJsonList should return List<Map<String, dynamic>>',
    () {
      List<GraphToShow> graphsToShowList = [
        GraphToShow(title: 'workoutsPerWeek', show: true),
        GraphToShow(title: 'userWeight', show: false),
        GraphToShow(title: 'totalVolume', show: true),
      ];

      dynamic graphsToShowJsonList =
          convertGraphToShowListToJsonList(graphsToShowList);

      expect(graphsToShowJsonList, isInstanceOf<List<Map<String, dynamic>>>(),
          reason:
              "Result should be of type 'List<Map<String, dynamic>>' but was of type ${graphsToShowJsonList.runtimeType}");
    },
  );

  test(
      'convertGraphToShowListToJsonList should convert List<GraphToShow> to List<Map<String, dynamic>>',
      () {
    List<GraphToShow> graphsToShowList = [
      GraphToShow(title: 'workoutsPerWeek', show: true),
      GraphToShow(title: 'userWeight', show: false),
      GraphToShow(title: 'totalVolume', show: true),
    ];

    List<Map<String, dynamic>> expectedJsonList = [
      {
        'title': 'workoutsPerWeek',
        'show': true,
      },
      {
        'title': 'userWeight',
        'show': false,
      },
      {
        'title': 'totalVolume',
        'show': true,
      },
    ];

    dynamic graphsToShowJsonList =
        convertGraphToShowListToJsonList(graphsToShowList);

    expect(graphsToShowJsonList, hasLength(graphsToShowList.length),
        reason:
            "Result was expected to have ${graphsToShowList.length} values in List but has ${graphsToShowJsonList.length}");

    expect(graphsToShowJsonList, expectedJsonList,
        reason:
            "Result was expected to equal $expectedJsonList but was $graphsToShowJsonList");
  });
}
