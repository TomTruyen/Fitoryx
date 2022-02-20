import 'package:fitoryx/widgets/sort_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortButton', () {
    testWidgets(
      'has TextButton',
      (WidgetTester tester) async {
        SortButton button = SortButton(
          isAscending: true,
          text: "Text",
          onPressed: () => {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: button,
            ),
          ),
        );

        final textButtonFinder = find.byType(TextButton);

        expect(textButtonFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has text',
      (WidgetTester tester) async {
        SortButton button = SortButton(
          isAscending: false,
          text: "Text",
          onPressed: () => {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: button,
            ),
          ),
        );

        final textFinder = find.text(button.text);

        expect(textFinder, findsOneWidget);
      },
    );
  });
}
