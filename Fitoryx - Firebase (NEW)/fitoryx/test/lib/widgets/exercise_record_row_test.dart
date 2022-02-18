import 'package:fitoryx/widgets/exercise_record_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Loader', () {
    testWidgets(
      'displays title in Row',
      (WidgetTester tester) async {
        const title = "Title";

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ExerciseRecordRow(title: title, value: ""),
            ),
          ),
        );

        final titleFinder = find.text(title);

        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      'displays value in Row when not null',
      (WidgetTester tester) async {
        const value = "Value";

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ExerciseRecordRow(title: "", value: value),
            ),
          ),
        );

        final valueFinder = find.text(value);

        expect(valueFinder, findsOneWidget);
      },
    );

    testWidgets(
      'displays "-" in Row when value is null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ExerciseRecordRow(title: "", value: null),
            ),
          ),
        );

        final valueFinder = find.byType(Text);

        expect(valueFinder, findsNWidgets(2));

        final textWidgets = tester.widgetList(valueFinder);
        expect((textWidgets.last as Text).data, "-");
      },
    );
  });
}
