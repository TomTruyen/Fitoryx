import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/widgets/weight_header_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeightHeaderRow', () {
    testWidgets(
      'has 3 Text Widgets',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeightHeaderRow(
                key: UniqueKey(),
              ),
            ),
          ),
        );

        final textFinder = find.byType(Text);

        expect(textFinder, findsNWidgets(3));
      },
    );

    testWidgets(
      'has a widget with "SET" text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeightHeaderRow(
                key: UniqueKey(),
              ),
            ),
          ),
        );

        final textFinder = find.text("SET");

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has a widget with "REPS" text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeightHeaderRow(
                key: UniqueKey(),
              ),
            ),
          ),
        );

        final textFinder = find.text("REPS");

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has a widget with "KG" text when unit is "metric"',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeightHeaderRow(
                key: UniqueKey(),
                unit: UnitType.metric,
              ),
            ),
          ),
        );

        final textFinder = find.text('KG');

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has a widget with "LBS" text when unit is "imperial"',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeightHeaderRow(
                key: UniqueKey(),
                unit: UnitType.imperial,
              ),
            ),
          ),
        );

        final textFinder = find.text('LBS');

        expect(textFinder, findsOneWidget);
      },
    );
  });
}
