import 'package:fitoryx/utils/double_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toDecimalPlaces should round to given decimals spaces', () {
    double value = 10.123456789;

    expect(value.toDecimalPlaces(0), 10);
    expect(value.toDecimalPlaces(1), 10.1);
    expect(value.toDecimalPlaces(2), 10.12);
    expect(value.toDecimalPlaces(3), 10.123);
    expect(value.toDecimalPlaces(4), 10.1235);
    expect(value.toDecimalPlaces(5), 10.12346);
  });

  test('toIntString should return String of double when decimals present', () {
    double value = 10.12345;

    expect(value.toIntString(), "10.12345");
  });

  test('toIntString should return String of int when no decimals', () {
    double value = 10.0;

    expect(value.toIntString(), "10");
  });
}
