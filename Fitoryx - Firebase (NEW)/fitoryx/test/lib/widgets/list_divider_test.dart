import 'package:fitoryx/widgets/list_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListDivider', () {
    testWidgets(
      'displays given text in Text widget and add given padding to Container',
      (WidgetTester tester) async {
        String dividerText = "Test Text";
        EdgeInsetsGeometry dividerPadding = const EdgeInsets.all(8);

        await tester.pumpWidget(ListDivider(
          text: dividerText,
          padding: dividerPadding,
        ));

        final textFinder = find.widgetWithText(Text, dividerText);
        final containerFinder = find.byType(Container);

        expect(textFinder, findsOneWidget);
        expect(containerFinder, findsOneWidget);

        Container container = tester.firstWidget(containerFinder);
        expect(container.padding, dividerPadding);
      },
    );
  });
}
