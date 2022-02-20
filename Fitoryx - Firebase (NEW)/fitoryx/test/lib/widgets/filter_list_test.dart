import 'package:fitoryx/widgets/filter_item.dart';
import 'package:fitoryx/widgets/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class MyFunction {
  void call(String param);
}

class AddItemFunction extends Mock implements MyFunction {}

class RemoveItemFunction extends Mock implements MyFunction {}

void main() {
  group('FilterList', () {
    final addItem = AddItemFunction();
    final removeItem = RemoveItemFunction();

    late FilterList filterList;

    setUp(() {
      filterList = FilterList(
        title: "Title",
        items: const ["Item1", "Item2", "Item3"],
        selectedItems: const ["Item1"],
        addItem: addItem,
        removeItem: removeItem,
      );
    });

    testWidgets(
      'has title',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: filterList,
            ),
          ),
        );

        final titleFinder = find.text(filterList.title);
        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has Wrap widget with FilterItem foreach item',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: filterList,
            ),
          ),
        );

        final wrapFinder = find.byType(Wrap);
        expect(wrapFinder, findsOneWidget);

        final filterItemsFinder = find.byType(FilterItem);
        expect(filterItemsFinder, findsNWidgets(filterList.items.length));
      },
    );

    testWidgets(
      'should call AddItem for non-selected FilterItem',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: filterList,
            ),
          ),
        );

        final filterItemsFinder = find.byType(FilterItem);

        for (int i = 0; i < filterList.items.length; i++) {
          var finder = filterItemsFinder.at(i);

          await tester.tap(finder);
          await tester.pumpAndSettle();
        }

        verify(addItem("Item2")).called(1);
        verify(addItem("Item3")).called(1);
      },
    );
  });
}
