import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/functions/Functions.dart';

int hasDataBeforeDate(List<dynamic> data, DateTime date) {
  if (data.isEmpty) return -1;

  data = sortByDate(data, false);

  int index = -1;

  for (int i = 0; i < data.length; i++) {
    DateTime dataDate = DateTime.fromMillisecondsSinceEpoch(
      data[i].timeInMillisSinceEpoch,
    );

    if (dataDate.isBefore(date)) {
      index = i;
      break;
    }
  }

  return index;
}

List<dynamic> addEmptyData(List<dynamic> list, DateTime date) {
  if (list is List<UserWeight>) {
    list.add(
      UserWeight(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        weight: 0,
      ),
    );
  }

  if (list is List<Workout>) {
    list.add(
      Workout(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        exercises: [],
      ),
    );
  }

  if (list is List<Food>) {
    list.add(
      Food(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        foodPerHour: [],
      ),
    );
  }

  return list;
}

List<dynamic> insertEmptyData(List<dynamic> list, DateTime date) {
  if (list is List<UserWeight>) {
    list.insert(
      0,
      UserWeight(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        weight: 0,
      ),
    );
  }

  if (list is List<Workout>) {
    list.insert(
      0,
      Workout(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        exercises: [],
      ),
    );
  }

  if (list is List<Food>) {
    list.insert(
      0,
      Food(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        foodPerHour: [],
      ),
    );
  }

  return list;
}

List<dynamic> addPreviousData(List<dynamic> list, DateTime date) {
  list = sortByDate(list, true);

  dynamic clone = list.last;
  clone.timeInMillisSinceEpoch = date.millisecondsSinceEpoch;
  list.add(clone);

  return list;
}

List<dynamic> addDataFromIndex(List<dynamic> list, int index, DateTime date) {
  dynamic clone = list[index].clone();
  clone.timeInMillisSinceEpoch = date.millisecondsSinceEpoch;

  return list;
}

List<dynamic> getDataWithinTimespan(
  List<dynamic> data,
  int timespan,
) {
  if (data == null) data = [];

  DateTime now = DateTime.now();

  if (!hasSameDay(data, now)) {
    if (data.isNotEmpty && data is List<UserWeight>) {
      addPreviousData(data, now);
    } else {
      data = addEmptyData(data, now);
    }
  }

  DateTime latestAllowedDateTime = now.subtract(Duration(days: timespan));
  if (!hasSameDay(data, latestAllowedDateTime)) {
    int index = -1;
    if (data is List<UserWeight>) {
      index = hasDataBeforeDate(data, latestAllowedDateTime);
    }

    if (data is List<UserWeight> && index > -1) {
      addDataFromIndex(data, index, latestAllowedDateTime);
    } else {
      data = insertEmptyData(data, latestAllowedDateTime);
    }
  }

  data = sortByDate(data, true);

  return data;
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
