import 'package:fitoryx/utils/datetime_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('today should set DateTime to midnight', () {
    // 01-01-2022 22:11:00
    final date = DateTime(2022, 01, 01, 22, 11, 0);
    // 01-01-2022 00:00:00
    final expected = DateTime(2022, 01, 01);

    var result = date.today();

    expect(result, expected);
  });

  test('startOfWeek should get monday of the week', () {
    // 01-01-2022 22:11:00 (Saturday)
    final date = DateTime(2022, 01, 01, 22, 11, 0);
    // 27-12-2021 22:11:00 (Monday)
    final expected = DateTime(2021, 12, 27, 22, 11, 0);

    var result = date.startOfWeek();

    expect(result, expected);
    expect(result.weekday, DateTime.monday);
  });
}
