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
              body: FormInput(
                key: UniqueKey(),
              ),
            ),
          ),
        );

        final textFormFieldFinder = find.byType(TextFormField);

        expect(textFormFieldFinder, findsOneWidget);
      },
    );

    testWidgets(
      'with isDense sets contentPadding to all(6)',
      (WidgetTester tester) async {
        final formInput = FormInput(
          isDense: true,
          key: UniqueKey(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: formInput,
            ),
          ),
        );

        expect(formInput.contentPadding?.horizontal, 2 * 6.0);
        expect(formInput.contentPadding?.vertical, 2 * 6.0);
      },
    );
  });
}
