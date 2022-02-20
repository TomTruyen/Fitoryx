import 'package:fitoryx/widgets/exercise_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Loader', () {
    testWidgets(
      'displays empty string when sets en name is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExerciseRow(
                key: UniqueKey(),
                sets: "",
                name: "",
                equipment: "",
              ),
            ),
          ),
        );

        final textFinder = find.text("");

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'displays "sets x name" when equipment is empty',
      (WidgetTester tester) async {
        const sets = "10";
        const name = "ExerciseName";

        const expected = "10 x ExerciseName";

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExerciseRow(
                key: UniqueKey(),
                sets: sets,
                name: name,
                equipment: "",
              ),
            ),
          ),
        );

        final textFinder = find.text(expected);

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'displays "sets x name (equipment)" when all values not empty',
      (WidgetTester tester) async {
        const sets = "10";
        const name = "ExerciseName";
        const equipment = "Equipment";

        const expected = "10 x ExerciseName (Equipment)";

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExerciseRow(
                key: UniqueKey(),
                sets: sets,
                name: name,
                equipment: equipment,
              ),
            ),
          ),
        );

        final textFinder = find.text(expected);

        expect(textFinder, findsOneWidget);
      },
    );
  });
}
