import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:intl/intl.dart';

String getFormattedDateTimeFromMilliseconds(int milliseconds) {
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

bool hasSameDayUserWeights(List<UserWeight> userWeights, DateTime date) {
  if (userWeights == null || userWeights.isEmpty) {
    return false;
  }

  for (int i = 0; i < userWeights.length; i++) {
    DateTime userWeightDate =
        DateTime.fromMillisecondsSinceEpoch(userWeights[i].timeInMilliseconds);

    if (isSameDay(userWeightDate, date)) {
      return true;
    }
  }

  return false;
}

bool hasSameDayWorkoutHistory(List<Workout> workoutHistory, DateTime date) {
  if (workoutHistory == null || workoutHistory.isEmpty) {
    return false;
  }

  for (int i = 0; i < workoutHistory.length; i++) {
    DateTime workoutHistoryDate = DateTime.fromMillisecondsSinceEpoch(
        workoutHistory[i].timeInMillisSinceEpoch);

    if (isSameDay(workoutHistoryDate, date)) {
      return true;
    }
  }

  return false;
}
