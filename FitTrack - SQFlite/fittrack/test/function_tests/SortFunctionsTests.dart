import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortFunctions', () {
    sortUserWeightsByDateTests();
    sortWorkoutsByDateTests();
    sortFoodByDateTests();
  });
}

void sortUserWeightsByDateTests() {
  test(
    'sortUserWeightsByDate should return List<UserWeight>',
    () {
      DateTime date = DateTime(2021, 3, 2);

      List<UserWeight> userWeights = [
        UserWeight(timeInMillisSinceEpoch: 0),
        UserWeight(timeInMillisSinceEpoch: date.millisecondsSinceEpoch),
      ];

      bool isAscending = true;

      dynamic result = sortUserWeightsByDate(userWeights, isAscending);

      expect(result, isInstanceOf<List<UserWeight>>(),
          reason:
              "Result should be of type 'List<Workout>' but was of type ${result.runtimeType}");
    },
  );

  test(
    'sortUserWeightsByDate should sort List<UserWeight> ascending when isAscending is true',
    () {
      DateTime date = DateTime(2021, 3, 2);

      UserWeight userWeight1 = UserWeight(timeInMillisSinceEpoch: 100);
      UserWeight userWeight2 = UserWeight(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
      );

      List<UserWeight> userWeights = [userWeight1, userWeight2];

      List<UserWeight> expectedResult = [userWeight1, userWeight2];

      bool isAscending = true;

      dynamic result = sortUserWeightsByDate(userWeights, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );

  test(
    'sortUserWeightsByDate should sort List<UserWeight> descending when isAscending is false',
    () {
      DateTime date = DateTime(2021, 3, 2);

      UserWeight userWeight1 = UserWeight(timeInMillisSinceEpoch: 100);
      UserWeight userWeight2 = UserWeight(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
      );

      List<UserWeight> userWeights = [userWeight1, userWeight2];

      List<UserWeight> expectedResult = [userWeight2, userWeight1];

      bool isAscending = false;

      dynamic result = sortUserWeightsByDate(userWeights, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );
}

void sortWorkoutsByDateTests() {
  test(
    'sortWorkoutsByDate should return List<Workout>',
    () {
      DateTime date = DateTime(2021, 3, 2);

      List<Workout> workouts = [
        Workout(timeInMillisSinceEpoch: 0),
        Workout(
          timeInMillisSinceEpoch:
              date.subtract(Duration(days: 1)).millisecondsSinceEpoch,
        ),
      ];
      bool isAscending = true;

      dynamic result = sortWorkoutsByDate(workouts, isAscending);

      expect(result, isInstanceOf<List<Workout>>(),
          reason:
              "Result should be of type 'List<Workout>' but was of type ${result.runtimeType}");
    },
  );

  test(
    'sortWorkoutsByDate should sort List<Workout> ascending when isAscending is true',
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

      dynamic result = sortWorkoutsByDate(workouts, isAscending);

      expect(result, expectedResult,
          reason: "Expected result to be $expectedResult but was $result");
    },
  );

  test(
    'sortWorkoutsByDate should sort List<Workout> descending when isAscending is false',
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

      dynamic result = sortWorkoutsByDate(workouts, isAscending);

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
