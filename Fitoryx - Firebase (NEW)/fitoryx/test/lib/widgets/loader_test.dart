import 'package:fitoryx/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Loader', () {
    testWidgets(
      'has CircularProgressIndiciator in Center of screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(const Loader());

        final centerFinder = find.byType(Center);
        final circularProgressIndicatorFinder = find.byType(
          CircularProgressIndicator,
        );

        expect(centerFinder, findsOneWidget);
        expect(circularProgressIndicatorFinder, findsOneWidget);
      },
    );
  });
}
