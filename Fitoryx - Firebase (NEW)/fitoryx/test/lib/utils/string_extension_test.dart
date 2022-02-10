import 'package:fitoryx/utils/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toInt should return String as int', () {
    expect("0".toInt(), 0);
    expect("123".toInt(), 123);
    expect("500".toInt(), 500);
  });

  test('toInt should return null if String is null', () {
    expect(null.toInt(), null);
  });

  test('toInt should return null if exception occurres', () {
    expect("bad number".toInt(), null);
    expect("123.5".toInt(), null);
  });
}
