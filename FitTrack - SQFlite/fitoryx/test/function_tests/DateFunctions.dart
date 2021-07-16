import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/workout/Workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateFunctions', () {
    getFormattedDateTimeFromMillisecondsSinceEpochTests();
    getFormattedDateFromDateTimeTests();
    convertDateTimeToStringTests();
    convertDateTimeToStringWithoutYearTests();
    convertDateTimeToDateTests();
    isSameDayTests();
    hasSameDayTests();
  });
}

void getFormattedDateTimeFromMillisecondsSinceEpochTests() {
  test(
    'getFormattedDateTimeFromMillisecondsSinceEpoch should return String',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);
      int milliseconds = date.millisecondsSinceEpoch;

      dynamic result =
          getFormattedDateTimeFromMillisecondsSinceEpoch(milliseconds);

      expect(result, isInstanceOf<String>(),
          reason:
              "Result was expected to be of type 'String' but was of type ${result.runtimeType}");
    },
  );

  test(
    'getFormattedDateTimeFromMillisecondsSinceEpoch should return formatted String from milliseconds',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      DateFormat dateFormat = new DateFormat('EEEE, d MMMM y, H:mm');
      String expectedResult = dateFormat.format(date);

      int milliseconds = date.millisecondsSinceEpoch;

      dynamic result =
          getFormattedDateTimeFromMillisecondsSinceEpoch(milliseconds);

      expect(result, expectedResult,
          reason:
              "Result was expected to equal '$expectedResult' but was '$result'");
    },
  );
}

void getFormattedDateFromDateTimeTests() {
  test(
    'getFormattedDateFromDateTime should return String',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      dynamic result = getFormattedDateFromDateTime(date);

      expect(result, isInstanceOf<String>(),
          reason:
              "Result was expected to be of type 'String' but was of type ${result.runtimeType}");
    },
  );

  test(
    'getFormattedDateFromDateTime should return formatted String from DateTime',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      DateFormat dateFormat = new DateFormat('EEEE, d MMMM y');
      String expectedResult = dateFormat.format(date);

      dynamic result = getFormattedDateFromDateTime(date);

      expect(result, expectedResult,
          reason:
              "Result was expected to equal '$expectedResult' but was '$result'");
    },
  );
}

void convertDateTimeToStringTests() {
  test(
    'convertDateTimeToString should return String',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      dynamic result = convertDateTimeToString(date);

      expect(result, isInstanceOf<String>(),
          reason:
              "Result was expected to be of type 'String' but was of type ${result.runtimeType}");
    },
  );

  test(
    'convertDateTimeToString should return a formatted String of format: d-m-y from DateTime',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      String expectedResult = "01-03-2020";

      dynamic result = convertDateTimeToString(date);

      expect(result, expectedResult,
          reason:
              "Result was expected to equal '$expectedResult' but was '$result'");
    },
  );
}

void convertDateTimeToStringWithoutYearTests() {
  test(
    'convertDateTimeToStringWithoutYear should return String',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      dynamic result = convertDateTimeToStringWithoutYear(date);

      expect(result, isInstanceOf<String>(),
          reason:
              "Result was expected to be of type 'String' but was of type ${result.runtimeType}");
    },
  );

  test(
    'convertDateTimeToStringWithoutYear should return a formatted String of format: d-m from DateTime',
    () {
      DateTime date = DateTime(2020, 3, 1, 16, 11, 0, 0);

      String expectedResult = "01-03";

      dynamic result = convertDateTimeToStringWithoutYear(date);

      expect(result, expectedResult,
          reason:
              "Result was expected to equal '$expectedResult' but was '$result'");
    },
  );
}

void convertDateTimeToDateTests() {
  test(
    'convertDateTimeToDate should return DateTime',
    () {
      DateTime dateTime = DateTime(2020, 3, 1, 16, 11, 0, 0);

      dynamic result = convertDateTimeToDate(dateTime);

      expect(result, isInstanceOf<DateTime>(),
          reason:
              "Result was expected to be of type 'DateTime' but was of type ${result.runtimeType}");
    },
  );

  test(
    'convertDateTimeToDate should convert DateTime to a DateTime with time on 00:00:00',
    () {
      DateTime dateTime = DateTime(2020, 3, 1, 16, 11, 0, 0);

      DateTime expectedResult = DateTime(2020, 3, 1, 0, 0, 0, 0);

      dynamic result = convertDateTimeToDate(dateTime);

      expect(result, expectedResult,
          reason:
              "Result was expected to equal '$expectedResult' but was '$result'");
    },
  );
}

void isSameDayTests() {
  test(
    'isSameDay should return bool',
    () {
      DateTime date1 = DateTime(2020, 3, 1, 0, 0, 0, 0);
      DateTime date2 = DateTime(2020, 3, 2, 0, 0, 0, 0);

      dynamic result = isSameDay(date1, date2);

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was of type ${result.runtimeType}");
    },
  );

  test(
    'isSameDay should return false when not the same day',
    () {
      DateTime date1 = DateTime(2020, 3, 1, 0, 0, 0, 0);
      DateTime date2 = DateTime(2020, 3, 2, 0, 0, 0, 0);

      dynamic result = isSameDay(date1, date2);

      expect(result, false,
          reason: "Result was expected to equal 'false' but was '$result'");
    },
  );

  test(
    'isSameDay should return true when the same day',
    () {
      DateTime date1 = DateTime(2020, 3, 1, 0, 0, 0, 0);
      DateTime date2 = DateTime(2020, 3, 1, 12, 0, 0, 0);

      dynamic result = isSameDay(date1, date2);

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was of type ${result.runtimeType}");

      expect(result, true,
          reason: "Result was expected to equal 'false' but was '$result'");
    },
  );
}

void hasSameDayTests() {
  test(
    'hasSameDay should return bool',
    () {
      DateTime date = DateTime(2020, 3, 1, 0, 0, 0, 0);

      List<Workout> workoutHistoryList = [
        Workout(timeInMillisSinceEpoch: 0),
        Workout(
          timeInMillisSinceEpoch:
              date.subtract(Duration(days: 1)).millisecondsSinceEpoch,
        ),
      ];

      dynamic result = hasSameDay(workoutHistoryList, date);

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was of type ${result.runtimeType}");
    },
  );

  test(
    'hasSameDay should return false if date is not found in List<dynamic>',
    () {
      DateTime date = DateTime(2020, 3, 1, 0, 0, 0, 0);

      List<Workout> workoutHistoryList = [
        Workout(timeInMillisSinceEpoch: 0),
        Workout(
          timeInMillisSinceEpoch:
              date.subtract(Duration(days: 1)).millisecondsSinceEpoch,
        ),
      ];

      dynamic result = hasSameDay(workoutHistoryList, date);

      expect(result, false,
          reason: "Result was expected to equal 'false' but was '$result'");
    },
  );

  test(
    'hasSameDay should return true if date is found in List<dynamic>',
    () {
      DateTime date = DateTime(2020, 3, 1, 0, 0, 0, 0);

      List<Workout> workoutHistoryList = [
        Workout(timeInMillisSinceEpoch: 0),
        Workout(timeInMillisSinceEpoch: date.millisecondsSinceEpoch),
      ];

      dynamic result = hasSameDay(workoutHistoryList, date);

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was of type ${result.runtimeType}");

      expect(result, true,
          reason: "Result was expected to equal 'false' but was '$result'");
    },
  );
}
