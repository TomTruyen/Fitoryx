import 'package:fitoryx/widgets/filter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterItem', () {
    late FilterItem item;

    setUp(() {
      item = FilterItem(
        value: "FilterItem Value",
        selected: false,
        onTap: () {},
      );
    });
    testWidgets(
      'has InkWell with onTap not null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: item,
            ),
          ),
        );

        final inkWellFinder = find.byType(InkWell);

        expect(inkWellFinder, findsOneWidget);

        InkWell inkWell = tester.firstWidget(inkWellFinder);
        expect(inkWell.onTap != null, true);
        expect(inkWell.onTap, item.onTap);
      },
    );

    testWidgets(
      'has gradient style for selected items',
      (WidgetTester tester) async {
        FilterItem item = FilterItem(
          value: "FilterItem Value",
          selected: true,
          onTap: () {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: item,
            ),
          ),
        );

        final containerFinder = find.byType(Container);

        expect(containerFinder, findsOneWidget);

        Container container = tester.firstWidget(containerFinder);
        expect(container.decoration != null, true);
        expect(container.decoration is BoxDecoration, true);
        expect((container.decoration as BoxDecoration).gradient != null, true);
        expect(
          (container.decoration as BoxDecoration).gradient is LinearGradient,
          true,
        );
      },
    );
  });
}
