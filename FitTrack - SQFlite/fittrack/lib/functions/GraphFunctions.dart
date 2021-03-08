import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/food/FoodPerHour.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/functions/Functions.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

int _getIndexOfLastValueBeforeTimespan(List<dynamic> data, int timespan) {
  if (data == null || data.isEmpty) return -1;

  int index = -1;

  data = sortByDate(data, false);

  DateTime mostRecentDateTime = DateTime.fromMillisecondsSinceEpoch(
    data.first?.timeInMillisSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
  );

  for (int i = 0; i < data.length; i++) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      data[i].timeInMillisSinceEpoch,
    );

    if (date.isBefore(mostRecentDateTime) ||
        isSameDay(date, mostRecentDateTime)) {
      index = i;
      break;
    }
  }

  return index;
}

List<dynamic> _fillDataWorkout(List<Workout> workoutHistory, int timespan) {
  const MIN_LENGTH = 2;

  if (workoutHistory.isEmpty) {
    DateTime now = DateTime.now();

    workoutHistory = [
      Workout(
        weightUnit: globals.sqlDatabase.settings.weightUnit ?? 'kg',
        timeInMillisSinceEpoch: now.millisecondsSinceEpoch,
      ),
      Workout(
        weightUnit: globals.sqlDatabase.settings.weightUnit ?? 'kg',
        timeInMillisSinceEpoch: now
            .subtract(
              Duration(days: timespan),
            )
            .millisecondsSinceEpoch,
      ),
    ];
  } else if (workoutHistory.length < MIN_LENGTH) {
    Workout _clone = workoutHistory[0].clone();
    _clone.exercises = [];
    _clone.timeInMillisSinceEpoch = DateTime.now()
        .subtract(Duration(days: timespan))
        .millisecondsSinceEpoch;

    workoutHistory.insert(0, _clone);
  }

  return workoutHistory;
}

List<dynamic> _fillDataUserWeight(List<UserWeight> userWeights, int timespan) {
  const MIN_LENGTH = 2;

  if (userWeights.isEmpty) {
    DateTime now = DateTime.now();

    userWeights = [
      UserWeight(
        weightUnit: globals.sqlDatabase.settings.weightUnit ?? 'kg',
        timeInMillisSinceEpoch: now.millisecondsSinceEpoch,
      ),
      UserWeight(
        weightUnit: globals.sqlDatabase.settings.weightUnit ?? 'kg',
        timeInMillisSinceEpoch: now
            .subtract(
              Duration(days: timespan),
            )
            .millisecondsSinceEpoch,
      ),
    ];
  } else if (userWeights.length < MIN_LENGTH) {
    double weight = 0;
    String weightUnit = userWeights[0].weightUnit;
    int timeInMilliseconds = DateTime.now()
        .subtract(Duration(days: timespan))
        .millisecondsSinceEpoch;

    userWeights.insert(
      0,
      UserWeight(
        weight: weight,
        weightUnit: weightUnit,
        timeInMillisSinceEpoch: timeInMilliseconds,
      ),
    );
  }

  return userWeights;
}

List<dynamic> _fillDataFood(List<Food> food, int timespan) {
  const MIN_LENGTH = 2;

  if (food.isEmpty) {
    DateTime now = DateTime.now();

    food = [
      Food(
        foodPerHour: [],
        timeInMillisSinceEpoch: now.millisecondsSinceEpoch,
      ),
      Food(
        foodPerHour: [],
        timeInMillisSinceEpoch: now
            .subtract(
              Duration(days: timespan),
            )
            .millisecondsSinceEpoch,
      ),
    ];
  } else if (food.length < MIN_LENGTH) {
    List<FoodPerHour> foodPerHour = [];
    int timeInMilliseconds = DateTime.now()
        .subtract(Duration(days: timespan))
        .millisecondsSinceEpoch;

    food.insert(
      0,
      Food(
        foodPerHour: foodPerHour,
        timeInMillisSinceEpoch: timeInMilliseconds,
      ),
    );
  }

  return food;
}

List<dynamic> getDataWithinTimespan(
  List<dynamic> data,
  int timespan,
) {
  List<dynamic> _originalData = List.of(data);

  if (data is List<Workout>) {
    data = List.of(data).cast<Workout>();
    data = _fillDataWorkout(data, timespan).cast<Workout>();
    data = sortByDate(data, true).cast<Workout>();
  }

  if (data is List<UserWeight>) {
    data = List.of(data).cast<UserWeight>();
    data = _fillDataUserWeight(data, timespan).cast<UserWeight>();
    data = sortByDate(data, true).cast<UserWeight>();
  }

  if (data is List<Food>) {
    data = List.of(data).cast<Food>();
    data = _fillDataFood(data, timespan).cast<Food>();
    data = sortByDate(data, true).cast<Food>();
  }

  List<dynamic> dateWithinTimespan = [];

  DateTime now = DateTime.now();

  DateTime mostRecentDateTime = DateTime.fromMillisecondsSinceEpoch(
    data.last?.timeInMillisSinceEpoch ?? now.millisecondsSinceEpoch,
  );

  if (!hasSameDay(data, mostRecentDateTime)) {
    dynamic mostRecentClone = data.last?.clone();

    if (mostRecentClone != null) {
      mostRecentClone.timeInMillisSinceEpoch = now.millisecondsSinceEpoch;
      data.add(mostRecentClone);

      mostRecentDateTime = now;
    }
  }

  DateTime latestDateTimeAllowed = mostRecentDateTime.subtract(
    Duration(days: timespan),
  );

  for (int i = 0; i < data.length; i++) {
    if (timespan == -1) {
      dateWithinTimespan.add(data[i]);
    } else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        data[i].timeInMillisSinceEpoch,
      );
      if (date.isAfter(latestDateTimeAllowed) ||
          isSameDay(date, latestDateTimeAllowed)) {
        dateWithinTimespan.add(data[i]);
      }
    }
  }

  dynamic mostRecentData = dateWithinTimespan[0];

  int index = _getIndexOfLastValueBeforeTimespan(data, timespan);

  int milliseconds =
      now.subtract(Duration(days: timespan)).millisecondsSinceEpoch;

  if (index > -1) {
    dynamic clone = data[index].clone();
    clone.timeInMillisSinceEpoch = milliseconds;
    dateWithinTimespan.insert(0, clone);
  } else {
    if (_originalData is List<Workout>) {
      dateWithinTimespan.insert(
        0,
        Workout(
          timeInMillisSinceEpoch: milliseconds,
          exercises: [],
        ),
      );
    }

    if (_originalData is List<UserWeight>) {
      dateWithinTimespan.insert(
        0,
        UserWeight(
          timeInMillisSinceEpoch: milliseconds,
          weightUnit: dateWithinTimespan[0].weightUnit,
        ),
      );
    }

    if (_originalData is List<Food>) {
      dateWithinTimespan.insert(
        0,
        Food(
          timeInMillisSinceEpoch: milliseconds,
          foodPerHour: [],
        ),
      );
    }
  }

  if (!isSameDay(mostRecentDateTime, now)) {
    dynamic clone = mostRecentData.clone();
    clone.timeInMillisSinceEpoch = now.millisecondsSinceEpoch;
    dateWithinTimespan.add(clone);
  }

  // Fix when the first 2 values are the same date
  DateTime firstDate = DateTime.fromMillisecondsSinceEpoch(
      dateWithinTimespan[0].timeInMillisSinceEpoch);
  DateTime secondDate = DateTime.fromMillisecondsSinceEpoch(
      dateWithinTimespan[1].timeInMillisSinceEpoch);

  if (isSameDay(firstDate, secondDate)) dateWithinTimespan.removeAt(0);

  return dateWithinTimespan;
}

String getTitle(double value, List<String> _datesList) {
  int _value = value.toInt();

  if (value < 0) value = 0;
  if (_value > _datesList.length - 1) _value = _datesList.length - 1;

  return _datesList[_value];
}

String getTitleWithoutYear(double value, List<String> _datesList) {
  int _value = value.toInt();

  if (value < 0) value = 0;
  if (_value > _datesList.length - 1) _value = _datesList.length - 1;

  String _date = _datesList[_value];
  List<String> _splittedDate = _date.split('-');
  _splittedDate.removeLast();

  return _splittedDate.join('-');
}
