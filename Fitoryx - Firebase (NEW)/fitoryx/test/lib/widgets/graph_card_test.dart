import 'package:fitoryx/widgets/graph_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GraphCard', () {
    late GraphCard card;

    setUp(() {
      card = GraphCard(
        key: UniqueKey(),
        title: "GraphTitle",
        graph: const SizedBox(child: Text("Graph Widget")),
        popup: null,
      );
    });
    testWidgets(
      'has Card',
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
  });
}
