import 'package:fitoryx/models/popup_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PopupOption', () {
    test('constructor should set values', () {
      var result = PopupOption(text: "Text", value: "Value");

      expect(result.text, "Text");
      expect(result.value, "Value");
    });
  });
}
