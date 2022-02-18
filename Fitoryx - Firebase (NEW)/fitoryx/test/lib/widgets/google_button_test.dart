import 'package:fitoryx/widgets/google_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoogleButton', () {
    testWidgets('has ElevatedButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleButton(
              onPressed: () => {},
            ),
          ),
        ),
      );

      final elevatedButtonFinder = find.byType(ElevatedButton);
      expect(elevatedButtonFinder, findsOneWidget);

      ElevatedButton elevatedButton = tester.firstWidget(elevatedButtonFinder);
      expect(elevatedButton.onPressed != null, true);
    });

    testWidgets(
      'has google image asset',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GoogleButton(
                onPressed: () => {},
              ),
            ),
          ),
        );

        final imageFinder = find.byType(Image);

        expect(imageFinder, findsOneWidget);

        Image image = tester.firstWidget(imageFinder);
        expect(
          (image.image as AssetImage).assetName,
          "assets/images/google.png",
        );
      },
    );
  });
}
