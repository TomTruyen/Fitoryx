import 'package:fitoryx/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionCard', () {
    late SubscriptionCard card;

    setUp(() {
      card = SubscriptionCard(
        price: "€9.99",
        title: "Title",
        description: "Description",
        onTap: () => {},
      );
    });

    testWidgets(
      'has Card widget',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: card,
            ),
          ),
        );

        final cardFinder = find.byType(Card);

        expect(cardFinder, findsOneWidget);
      },
    );

    testWidgets(
      'has ListTile with title and description',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: card,
            ),
          ),
        );

        final listTileFinder = find.byType(ListTile);

        expect(listTileFinder, findsOneWidget);

        ListTile tile = tester.firstWidget(listTileFinder);
        expect(tile.title is Text, true);
        expect((tile.title as Text).data, card.title);

        expect(tile.subtitle is Text, true);
        expect((tile.subtitle as Text).data, card.description);
      },
    );

    testWidgets(
      'has Text widget with price',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: card,
            ),
          ),
        );

        final priceFinder = find.text(card.price);

        expect(priceFinder, findsOneWidget);
      },
    );
  });
}
