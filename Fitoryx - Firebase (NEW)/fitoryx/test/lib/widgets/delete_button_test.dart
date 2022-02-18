import 'package:fitoryx/widgets/delete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeleteButton', () {
    testWidgets(
      'has GestureDetector and delete Icon',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DeleteButton(onTap: () {}),
            ),
          ),
        );

        final gestureDetectorFinder = find.byType(GestureDetector);
        final deleteIconFinder = find.byType(Icon);

        expect(gestureDetectorFinder, findsOneWidget);
        expect(deleteIconFinder, findsOneWidget);

        GestureDetector gestureDetector = tester.firstWidget(
          gestureDetectorFinder,
        );
        expect(gestureDetector.onTap != null, true);

        Icon deleteIcon = tester.firstWidget(deleteIconFinder);
        expect(deleteIcon.icon, Icons.delete);
      },
    );
  });
}
