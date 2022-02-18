import 'package:fitoryx/widgets/subscription_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionFeature', () {
    testWidgets(
      'should display check_circle icon and text',
      (WidgetTester tester) async {
        const text = "Text";

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SubscriptionFeature(text: text),
            ),
          ),
        );

        final iconFinder = find.byType(Icon);
        final textFinder = find.byType(Text);

        expect(iconFinder, findsOneWidget);
        expect(textFinder, findsOneWidget);

        Icon iconWidget = tester.firstWidget(iconFinder);
        Text textWidget = tester.firstWidget(textFinder);

        expect(iconWidget.icon, Icons.check_circle);
        expect(textWidget.data, text);
      },
    );
  });
}
