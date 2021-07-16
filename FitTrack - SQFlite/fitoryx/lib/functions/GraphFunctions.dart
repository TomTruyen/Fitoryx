import 'package:Fitoryx/functions/Functions.dart';
import 'package:Fitoryx/models/food/Food.dart';
import 'package:Fitoryx/models/settings/BodyFat.dart';
import 'package:Fitoryx/models/settings/UserWeight.dart';
import 'package:Fitoryx/models/workout/Workout.dart';

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

bool hasDataAfterToday(List<dynamic> data) {
  if (data.isEmpty) return false;

  DateTime now = DateTime.now();

  bool found = false;

  for (int i = 0; i < data.length; i++) {
    DateTime dataDate = DateTime.fromMillisecondsSinceEpoch(
      data[i].timeInMillisSinceEpoch,
    );

    if (dataDate.isAfter(now)) {
      found = true;
      break;
    }
  }

  return found;
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

  if (list is List<BodyFat>) {
    list.add(
      BodyFat(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        percentage: 0,
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

  if (list is List<BodyFat>) {
    list.insert(
      0,
      BodyFat(
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        percentage: 0,
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

List<dynamic> insertEmptyDataDayBefore(List<dynamic> list) {
  if (list.isEmpty) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    list = addEmptyData(list, now);
    list = addEmptyData(list, yesterday);

    return list;
  }

  DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(
    list.last?.timeInMillisSinceEpoch,
  );
  DateTime dateBeforeLastDate = lastDate.subtract(Duration(days: 1));
  list = insertEmptyData(list, dateBeforeLastDate);

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
    if (data.isNotEmpty && data is List<UserWeight> || data is List<BodyFat>) {
      addPreviousData(data, now);
    } else {
      data = addEmptyData(data, now);
    }
  }

  DateTime latestAllowedDateTime = now.subtract(Duration(days: timespan));
  if (!hasSameDay(data, latestAllowedDateTime)) {
    int index = -1;
    if (data is List<UserWeight> || data is List<BodyFat>) {
      index = hasDataBeforeDate(data, latestAllowedDateTime);
    }

    if ((data is List<UserWeight> || data is List<BodyFat>) && index > -1) {
      addDataFromIndex(data, index, latestAllowedDateTime);
    } else {
      data = insertEmptyData(data, latestAllowedDateTime);
    }
  }

  //  2 = MINIMUM POINTS REQUIRED TO SHOW GRAPH, IF LESS THAN 2 ==> ADD EMPTY ONE BEFORE
  if (data.length < 2) {
    data = insertEmptyDataDayBefore(data);
  }

  data = sortByDate(data, true);

  // Check if last date is today, if it is after today then remove it
  while (hasDataAfterToday(data)) {
    data.removeLast();
  }

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
