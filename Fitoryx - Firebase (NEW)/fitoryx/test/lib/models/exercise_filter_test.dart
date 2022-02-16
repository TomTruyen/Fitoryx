import 'package:fitoryx/models/exercise_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/// Mocks a callback function on which you can use verify
class MockCallbackFunction extends Mock {
  call();
}

void main() {
  group('ExerciseFilter', () {
    late ExerciseFilter exerciseFilter;
    final notifyListenerCallback =
        MockCallbackFunction(); // callback function mock

    setUp(() {
      exerciseFilter = ExerciseFilter()..addListener(notifyListenerCallback);
      reset(notifyListenerCallback); // resets mock before each test
    });

    test('addCategory should add category and call listeners', () {
      exerciseFilter.addCategory("Category");

      expect(exerciseFilter.categories.length, 1);
      expect(exerciseFilter.categories.contains("Category"), true);
      verify(notifyListenerCallback()).called(1);
    });

    test('removeCategory should remove category and call listeners', () {
      List<String> categories = ["Category1", "Category2"];
      exerciseFilter.categories = categories;

      exerciseFilter.removeCategory("NotFoundCategory");
      exerciseFilter.removeCategory("Category1");

      expect(exerciseFilter.categories.length, 1);
      verify(notifyListenerCallback()).called(1);
    });

    test('addEquipment should add equipment and call listeners', () {
      exerciseFilter.addEquipment("Equipment");

      expect(exerciseFilter.equipments.length, 1);
      expect(exerciseFilter.equipments.contains("Equipment"), true);
      verify(notifyListenerCallback()).called(1);
    });

    test('removeEquipment should remove equipment and call listeners', () {
      List<String> equipments = ["Equipment1", "Equipment2"];
      exerciseFilter.equipments = equipments;

      exerciseFilter.removeEquipment("NotFoundEquipment");
      exerciseFilter.removeEquipment("Equipment1");

      expect(exerciseFilter.equipments.length, 1);
      verify(notifyListenerCallback()).called(1);
    });

    test('addType should add type and call listeners', () {
      exerciseFilter.addType("Type");

      expect(exerciseFilter.types.length, 1);
      expect(exerciseFilter.types.contains("Type"), true);
      verify(notifyListenerCallback()).called(1);
    });

    test('removeType should remove type and call listeners', () {
      List<String> types = ["Type1", "Type2"];
      exerciseFilter.types = types;

      exerciseFilter.removeType("NotFoundType");
      exerciseFilter.removeType("Type1");

      expect(exerciseFilter.types.length, 1);
      verify(notifyListenerCallback()).called(1);
    });

    test('setCount should set count and call listeners', () {
      exerciseFilter.setCount(10);

      expect(exerciseFilter.count, 10);
      verify(notifyListenerCallback()).called(1);
    });

    test('setSearch should set search and call listeners', () {
      exerciseFilter.setSearch("SearchValue");

      expect(exerciseFilter.search, "SearchValue");
      verify(notifyListenerCallback()).called(1);
    });

    test('clear should reset values and call listeners', () {
      exerciseFilter.categories = ["Category1", "Category2"];
      exerciseFilter.equipments = ["Equipment"];
      exerciseFilter.types = ["Type"];

      exerciseFilter.clear();

      expect(exerciseFilter.categories.isEmpty, true);
      expect(exerciseFilter.equipments.isEmpty, true);
      expect(exerciseFilter.types.isEmpty, true);
      verify(notifyListenerCallback()).called(1);
    });

    test('clear should reset values (including search) and call listeners', () {
      exerciseFilter.search = "SearchValue";
      exerciseFilter.categories = ["Category1", "Category2"];
      exerciseFilter.equipments = ["Equipment"];
      exerciseFilter.types = ["Type"];

      exerciseFilter.clear(includeSearch: true);

      expect(exerciseFilter.search, "");
      expect(exerciseFilter.categories.isEmpty, true);
      expect(exerciseFilter.equipments.isEmpty, true);
      expect(exerciseFilter.types.isEmpty, true);
      verify(notifyListenerCallback()).called(1);
    });
  });
}
