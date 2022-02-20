import 'package:fitoryx/widgets/manage_subscription_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ManageSubscriptionsButton', () {
    testWidgets(
      'has TextButton',
      (WidgetTester tester) async {
        ManageSubscriptionsButton button = ManageSubscriptionsButton(
          key: UniqueKey(),
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

        await tester.tap(textButtonFinder);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'has "MANAGE SUBSCRIPTIONS" text',
      (WidgetTester tester) async {
        ManageSubscriptionsButton button = ManageSubscriptionsButton(
          key: UniqueKey(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: button,
            ),
          ),
        );

        final textFinder = find.text("MANAGE SUBSCRIPTIONS");

        expect(textFinder, findsOneWidget);
      },
    );
  });
}
