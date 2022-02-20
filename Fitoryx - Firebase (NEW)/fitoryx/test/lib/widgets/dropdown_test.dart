import 'package:fitoryx/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dropdown', () {
    late Dropdown dropdown;
    List<String> options = ["Option1", "Option2", "Option3"];

    setUp(() {
      dropdown = Dropdown(
        title: "Title",
        selectedValue: "",
        options: options,
        onSelect: (String value) => {},
      );
    });

    testWidgets(
      'has InkWell with onTap not null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: dropdown,
            ),
          ),
        );

        final inkWellFinder = find.byType(InkWell);

        expect(inkWellFinder, findsOneWidget);

        InkWell inkWell = tester.firstWidget(inkWellFinder);
        expect(inkWell.onTap != null, true);
      },
    );

    testWidgets(
      'has dialog with ListTile which closes the dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: dropdown,
            ),
          ),
        );

        final inkWellFinder = find.byType(InkWell);
        expect(inkWellFinder, findsOneWidget);

        await tester.tap(inkWellFinder);
        await tester.pumpAndSettle();

        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);

        final listTileList = find.byType(ListTile);
        expect(listTileList, findsNWidgets(options.length));

        final firstListTile = listTileList.first;
        await tester.tap(firstListTile);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'has title and selectedValue',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: dropdown,
            ),
          ),
        );

        final titleFinder = find.text(dropdown.title);
        final selectedFinder = find.text(dropdown.selectedValue);

        expect(titleFinder, findsOneWidget);
        expect(selectedFinder, findsOneWidget);
      },
    );
  });
}
