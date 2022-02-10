import 'package:fitoryx/utils/int_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('withZeroPadding should pad zeros to the left of int', () {
    expect(1.withZeroPadding(amount: 1), "1");
    expect(1.withZeroPadding(amount: 2), "01");
    expect(1.withZeroPadding(amount: 5), "00001");
  });

  test('toMinutesAndSeconds should return String int as minutes and seconds',
      () {
    expect(30.toMinutesAndSeconds(), "30s");
    expect(60.toMinutesAndSeconds(), "1m");
    expect(90.toMinutesAndSeconds(), "1m 30s");
  });

  test('ordinal should return ordinal string of int', () {
    expect(1.ordinal(), "1st");
    expect(11.ordinal(), "11th");
    expect(21.ordinal(), "21st");
    expect(2.ordinal(), "2nd");
    expect(12.ordinal(), "12th");
    expect(22.ordinal(), "22nd");
    expect(3.ordinal(), "3rd");
    expect(13.ordinal(), "13th");
    expect(23.ordinal(), "23rd");
    expect(50.ordinal(), "50th");
  });
}
