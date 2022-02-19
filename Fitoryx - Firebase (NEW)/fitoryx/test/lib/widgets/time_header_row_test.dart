import 'package:fitoryx/widgets/time_header_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeHeaderRow', () {
    testWidgets(
      'has 2 Text Widgets',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TimeHeaderRow(),
            ),
          ),
        );

        final textFinder = find.byType(Text);

        expect(textFinder, findsNWidgets(2));
      },
    );

    testWidgets(
      'has a widget with "SET" text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TimeHeaderRow(),
            ),
          ),
        );

        final textFinder = find.text("SET");

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has a widget with "TIME" text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TimeHeaderRow(),
            ),
          ),
        );

        final textFinder = find.text("TIME");

        expect(textFinder, findsOneWidget);
      },
    );
  });
}
