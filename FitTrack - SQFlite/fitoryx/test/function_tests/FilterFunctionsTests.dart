import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/exercises/Exercise.dart';
import 'package:Fitoryx/models/exercises/ExerciseFilter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterFunctions', () {
    getFilteredExercisesTests();
  });
}

void getFilteredExercisesTests() {
  List<Exercise> exercises = [
    Exercise(name: 'Ab Wheel', category: 'Core'),
    Exercise(
      name: 'Arnold Press',
      category: 'Shoulders',
      equipment: 'Dumbbell',
    ),
    Exercise(
      name: 'Around The World',
      category: 'Chest',
      equipment: 'Dumbbell',
    ),
  ];

  List<Exercise> userExercises = [
    Exercise(
      name: 'Bench Press',
      category: 'Chest',
      equipment: 'Cable',
      isUserCreated: 1,
    ),
  ];

  ExerciseFilter filter = ExerciseFilter();

  test(
    'getFilteredExercises should return Map<String, dynamic>',
    () {
      dynamic result =
          getFilteredExercises(filter, exercises, [], [], false, null, null);

      expect(result, isInstanceOf<Map<String, dynamic>>(),
          reason:
              "Result was expected to be of type 'Map<String, dynamic>' but was of type ${result.runtimeType}");
    },
  );

  test(
    'getFilteredExercises should return map with key \'exercises\'',
    () {
      Map<String, dynamic> result =
          getFilteredExercises(filter, exercises, [], [], false, null, null);

      expect(result.containsKey('exercises'), true,
          reason:
              "Result was expected to have a key 'exercises' but was not found");
    },
  );

  test(
    'getFilteredExercises should return map with key \'exercisesLength\'',
    () {
      Map<String, dynamic> result =
          getFilteredExercises(filter, exercises, [], [], false, null, null);

      expect(result.containsKey('exercisesLength'), true,
          reason:
              "Result was expected to have a key 'exercisesLength' but was not found");
    },
  );

  test(
    'getFilteredExercises should return correct exercisesLength',
    () {
      Map<String, dynamic> result =
          getFilteredExercises(filter, exercises, [], [], false, null, null);

      expect(result['exercisesLength'], exercises.length,
          reason:
              "ExercisesLength was expected to be ${exercises.length} but is ${result['exercisesLength']}");
    },
  );

  test(
    'getFilteredExercises should filter using searchValue',
    () {
      ExerciseFilter exerciseFilterFullNameValue = ExerciseFilter();
      exerciseFilterFullNameValue.searchValue = "ab wheel";

      ExerciseFilter exerciseFilterPartNameValue = ExerciseFilter();
      exerciseFilterPartNameValue.searchValue = "press";

      List<dynamic> expectedResultFullName = [
        "A", //dividers are also returned in this list
        Exercise(name: 'Ab Wheel', category: 'Core')
      ];

      List<dynamic> expectedResultPartName = [
        "A", //dividers are also in this list
        Exercise(
          name: 'Arnold Press',
          category: 'Shoulders',
          equipment: 'Dumbbell',
        )
      ];

      Map<String, dynamic> resultFullName = getFilteredExercises(
          exerciseFilterFullNameValue, exercises, [], [], false, null, null);

      Map<String, dynamic> resultPartName = getFilteredExercises(
          exerciseFilterPartNameValue, exercises, [], [], false, null, null);

      expect(resultFullName['exercises'].length, expectedResultFullName.length,
          reason:
              'Expected exercises length to equal ${expectedResultFullName.length} but was ${resultFullName['exercises'].length}');

      expect(resultPartName['exercises'].length, expectedResultPartName.length,
          reason:
              'Expected exercises length to equal ${expectedResultPartName.length} but was ${resultPartName['exercises'].length}');
    },
  );

  test(
    'getFilteredExercises should filter using selectedCategories',
    () {
      ExerciseFilter exerciseFilter = ExerciseFilter();
      exerciseFilter.selectedCategories = ['Core', 'Shoulders'];

      List<dynamic> expectedResult = [
        "A", //dividers are also returned in this list
        Exercise(name: 'Ab Wheel', category: 'Core'),
        Exercise(
          name: 'Arnold Press',
          category: 'Shoulders',
          equipment: 'Dumbbell',
        ),
      ];

      Map<String, dynamic> result = getFilteredExercises(
          exerciseFilter, exercises, [], [], false, null, null);

      expect(result['exercises'].length, expectedResult.length,
          reason:
              'Expected exercises length to equal ${expectedResult.length} but was ${result['exercises'].length}');
    },
  );

  test(
    'getFilteredExercises should filter using selectedEquipment',
    () {
      ExerciseFilter exerciseFilter = ExerciseFilter();
      exerciseFilter.selectedEquipment = ['Dumbbell'];

      List<dynamic> expectedResult = [
        "A", //dividers are also returned in this list
        Exercise(
          name: 'Arnold Press',
          category: 'Shoulders',
          equipment: 'Dumbbell',
        ),
        Exercise(
          name: 'Around The World',
          category: 'Chest',
          equipment: 'Dumbbell',
        ),
      ];

      Map<String, dynamic> result = getFilteredExercises(
          exerciseFilter, exercises, [], [], false, null, null);

      expect(result['exercises'].length, expectedResult.length,
          reason:
              'Expected exercises length to equal ${expectedResult.length} but was ${result['exercises'].length}');
    },
  );

  test(
    'getFilteredExercises should filter using isUserCreated',
    () {
      ExerciseFilter exerciseFilter = ExerciseFilter();
      exerciseFilter.isUserCreated = 1;

      List<dynamic> expectedResult = [
        "B", //dividers are also returned in this list
        Exercise(
          name: 'Bench Press',
          category: 'Chest',
          equipment: 'Cable',
          isUserCreated: 1,
        ),
      ];

      Map<String, dynamic> result = getFilteredExercises(
        exerciseFilter,
        exercises,
        userExercises,
        [],
        false,
        null,
        null,
      );

      expect(result['exercises'].length, expectedResult.length,
          reason:
              'Expected exercises length to equal ${expectedResult.length} but was ${result['exercises'].length}');
    },
  );

  test(
    'getFilteredExercises should filter correctly',
    () {
      ExerciseFilter exerciseFilter = ExerciseFilter();
      exerciseFilter.searchValue = "a";
      exerciseFilter.selectedCategories = ["Shoulders"];
      exerciseFilter.selectedEquipment = ["Dumbbell"];
      exerciseFilter.isUserCreated = 0;

      List<dynamic> expectedResult = [
        "A",
        Exercise(
          name: 'Arnold Press',
          category: 'Shoulders',
          equipment: 'Dumbbell',
        ),
      ];

      Map<String, dynamic> result = getFilteredExercises(
        exerciseFilter,
        exercises,
        userExercises,
        [],
        false,
        null,
        null,
      );

      expect(result['exercises'].length, expectedResult.length,
          reason:
              'Expected exercises length to equal ${expectedResult.length} but was ${result['exercises'].length}');
    },
  );
}
