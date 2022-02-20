import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/exercise_type.dart';
import 'package:fitoryx/widgets/exercise_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseItem', () {
    testWidgets(
      'has ListTile with title and subtitle',
      (WidgetTester tester) async {
        ExerciseItem item = ExerciseItem(
          exercise: Exercise(
            name: "Name",
            equipment: "Equipment",
            category: "Category",
            type: ExerciseType.weight,
            userCreated: true,
          ),
          selected: false,
          onDelete: () => {},
          onTap: () => {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: item,
            ),
          ),
        );

        final listTileFinder = find.byType(ListTile);

        expect(listTileFinder, findsOneWidget);

        ListTile tile = tester.firstWidget(listTileFinder);

        expect(tile.title is Text, true);
        expect((tile.title as Text).data, item.exercise.getTitle());

        expect(tile.subtitle is Text, true);
        expect((tile.subtitle as Text).data, item.exercise.category);
      },
    );

    testWidgets(
      'has non null TextStyle for title',
      (WidgetTester tester) async {
        ExerciseItem item = ExerciseItem(
          exercise: Exercise(
            name: "Name",
            equipment: "Equipment",
            category: "Category",
            type: ExerciseType.weight,
            userCreated: true,
          ),
          selected: true,
          onDelete: () => {},
          onTap: () => {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: item,
            ),
          ),
        );

        final listTileFinder = find.byType(ListTile);

        ListTile tile = tester.firstWidget(listTileFinder);

        expect(tile.title is Text, true);
        expect((tile.title as Text).style != null, true);
      },
    );
  });
}
