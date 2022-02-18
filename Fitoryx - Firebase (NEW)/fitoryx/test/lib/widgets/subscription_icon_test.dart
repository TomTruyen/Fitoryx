import 'package:fitoryx/widgets/subscription_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionIcon', () {
    testWidgets(
      'has IconButton with star icon',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SubscriptionIcon(),
            ),
          ),
        );

        final iconButtonFinder = find.byType(IconButton);

        expect(iconButtonFinder, findsOneWidget);

        IconButton iconButton = tester.firstWidget(iconButtonFinder);
        expect((iconButton.icon as Icon).icon, Icons.star_rounded);
      },
    );
  });
}
