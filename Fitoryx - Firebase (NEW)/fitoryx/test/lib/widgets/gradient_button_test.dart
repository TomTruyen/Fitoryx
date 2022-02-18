import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GradientButton', () {
    testWidgets(
      'has CircularProgressIndicator when isBusy',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GradientButton(
                isBusy: true,
                onPressed: null,
              ),
            ),
          ),
        );

        final circularProgressIndicatorFinder = find.byType(
          CircularProgressIndicator,
        );

        expect(circularProgressIndicatorFinder, findsOneWidget);
      },
    );

    testWidgets(
      'displays text when not isBusy',
      (WidgetTester tester) async {
        const text = "Test Text";

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GradientButton(
                text: text,
                isBusy: false,
                onPressed: () {},
              ),
            ),
          ),
        );

        final textFinder = find.text(text);

        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has TextButton with gradient Ink',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GradientButton(
                text: "Test Text",
                isBusy: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        final textButtonFinder = find.byType(TextButton);
        final inkFinder = find.byType(Ink);

        expect(textButtonFinder, findsOneWidget);
        expect(inkFinder, findsOneWidget);

        TextButton textButton = tester.firstWidget(textButtonFinder);
        expect(textButton.onPressed != null, true);

        Ink ink = tester.firstWidget(inkFinder);
        expect((ink.decoration as BoxDecoration).gradient != null, true);
        expect(
          (ink.decoration as BoxDecoration).gradient is LinearGradient,
          true,
        );
      },
    );
  });
}
