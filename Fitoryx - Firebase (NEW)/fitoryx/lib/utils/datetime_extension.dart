extension DateTimeExtension on DateTime {
  DateTime today() {
    return DateTime(year, month, day);
  }

  DateTime startOfWeek() {
    return subtract(Duration(days: weekday - 1));
  }
}
