import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:intl/intl.dart';

String getFormattedDateTimeFromMillisecondsSinceEpoch(int milliseconds) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
  DateFormat dateFormat = new DateFormat('EEEE, d MMMM y, H:mm');

  return dateFormat.format(date);
}

String getFormattedDateFromDateTime(DateTime date) {
  DateFormat dateFormat = new DateFormat('EEEE, d MMMM y');

  return dateFormat.format(date);
}

String convertDateTimeToString(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();

  return "$day-$month-$year";
}

String convertDateTimeToStringWithoutYear(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');

  return "$day-$month";
}

DateTime convertDateTimeToDate(DateTime dateTime) {
  DateTime date = new DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    0,
    0,
    0,
    0,
    0,
  );

  return date;
}

bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  if (dateTime1.day == dateTime2.day &&
      dateTime1.month == dateTime2.month &&
      dateTime1.year == dateTime2.year) {
    return true;
  }

  return false;
}

bool hasSameDay(List<dynamic> list, DateTime date) {
  if (list == null || list.isEmpty) {
    return false;
  }

  if (list is List<Workout>) list = List.of(list).cast<Workout>();
  if (list is List<UserWeight>) list = List.of(list).cast<UserWeight>();

  for (int i = 0; i < list.length; i++) {
    DateTime userWeightDate = DateTime.fromMillisecondsSinceEpoch(
      list[i].timeInMillisSinceEpoch,
    );

    if (isSameDay(userWeightDate, date)) {
      return true;
    }
  }

  return false;
}
