import 'package:fitoryx/widgets/gradient_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GradientFloatingActionButton', () {
    testWidgets(
      'has FloatingActionButton',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GradientFloatingActionButton(
                onPressed: () {},
              ),
            ),
          ),
        );

        final fabFinder = find.byType(FloatingActionButton);

        expect(fabFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has Container with gradient',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GradientFloatingActionButton(
                onPressed: () {},
              ),
            ),
          ),
        );

        final containerFinder = find.byType(Container);

        expect(containerFinder, findsWidgets);

        final containerList = tester.widgetList(containerFinder);
        expect(
          ((containerList.last as Container).decoration as BoxDecoration)
                  .gradient !=
              null,
          true,
        );
        expect(
          ((containerList.last as Container).decoration as BoxDecoration)
              .gradient is LinearGradient,
          true,
        );
      },
    );
  });
}
