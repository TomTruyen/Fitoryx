import 'package:fitoryx/widgets/macro_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MacroProgress', () {
    late MacroProgress macroProgress;

    setUp(() {
      macroProgress = MacroProgress(
        key: UniqueKey(),
        title: "KCAL",
        value: 100,
        goal: 200,
      );
    });

    testWidgets(
      'has title',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: macroProgress,
            ),
          ),
        );

        final titleFinder = find.text(macroProgress.title);
        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has LinearProgressIndicator',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: macroProgress,
            ),
          ),
        );

        final linearProgressIndicatorFinder = find.byType(
          LinearProgressIndicator,
        );
        expect(linearProgressIndicatorFinder, findsOneWidget);
      },
    );
  });
}
