import 'package:fitoryx/widgets/popup_menu_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('buildPopupMenuItem', () {
    final mockContext = MockBuildContext();

    testWidgets(
      'should create PopupMenuItem with value and text',
      (WidgetTester tester) async {
        final popupMenuItem = buildPopupMenuItem(mockContext, "Value", "Text");

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: popupMenuItem),
          ),
        );

        final textFinder = find.text("Text");
        expect(textFinder, findsOneWidget);

        final popupMenuItemFinder = find.byType(PopupMenuItem);
        expect(popupMenuItemFinder, findsOneWidget);

        PopupMenuItem item = tester.firstWidget(popupMenuItemFinder);
        expect(item.value, "Value");
      },
    );
  });
}
