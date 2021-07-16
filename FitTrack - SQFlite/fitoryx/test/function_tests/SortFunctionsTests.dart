import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/food/Food.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortFunctions', () {
    sortByDateTests();
    sortFoodByDateTests();
  });
}

void sortByDateTests() {
  test(
    'sortByDate should sort List<dynamic> ascending when isAscending is true',
    () {
      DateTime date = DateTime(2021, 3, 2);

      Workout workout1 = Workout(timeInMillisSinceEpoch: 0);
      Workout workout2 = Workout(
        timeInMillisSinceEpoch:
            date.subtract(Duration(days: 1)).millisecondsSinceEpoch,
      );

      List<Workout> workouts = [workout1, workout2];

      List<Workout> expectedResult = [workout1, workout2];

      bool isAscending = true;

      List<dynamic> result = sortByDate(workouts, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );

  test(
    'sortByDate should sort List<dynamic> descending when isAscending is false',
    () {
      DateTime date = DateTime(2021, 3, 2);

      Workout workout1 = Workout(timeInMillisSinceEpoch: 0);
      Workout workout2 = Workout(
        timeInMillisSinceEpoch:
            date.subtract(Duration(days: 1)).millisecondsSinceEpoch,
      );

      List<Workout> workouts = [workout1, workout2];

      List<Workout> expectedResult = [workout2, workout1];

      bool isAscending = false;

      List<dynamic> result = sortByDate(workouts, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );
}

void sortFoodByDateTests() {
  test(
    'sortFoodByDate should return List<Food>',
    () {
      List<Food> food = [
        Food(date: '02-03-2021'),
        Food(date: '03-03-2021'),
        Food(date: '02-03-2020'),
      ];

      bool isAscending = true;

      dynamic result = sortFoodByDate(food, isAscending);

      expect(result, isInstanceOf<List<Food>>(),
          reason:
              "Result should be of type 'List<Food>' but was of type ${result.runtimeType}");
    },
  );

  test(
    'sortFoodByDate should sort ascending by date when isAcending is true',
    () {
      Food food1 = Food(date: '02-03-2021');
      Food food2 = Food(date: '03-03-2021');
      Food food3 = Food(date: '02-03-2020');

      List<Food> food = [food1, food2, food3];

      List<Food> expectedResult = [food3, food1, food2];

      bool isAscending = true;

      dynamic result = sortFoodByDate(food, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );

  test(
    'sortFoodByDate should sort descending by date when isAcending is false',
    () {
      Food food1 = Food(date: '02-03-2021');
      Food food2 = Food(date: '03-03-2021');
      Food food3 = Food(date: '02-03-2020');

      List<Food> food = [food1, food2, food3];

      List<Food> expectedResult = [food2, food1, food3];

      bool isAscending = false;

      dynamic result = sortFoodByDate(food, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );
}
