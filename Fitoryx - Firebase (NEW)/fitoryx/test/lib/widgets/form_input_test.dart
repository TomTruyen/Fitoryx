import 'package:fitoryx/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormInput', () {
    testWidgets(
      'has TextFormField',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FormInput(),
            ),
          ),
        );

        final textFormFieldFinder = find.byType(TextFormField);

        expect(textFormFieldFinder, findsOneWidget);
      },
    );
  });
}
