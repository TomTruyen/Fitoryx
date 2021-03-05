import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:fittrack/functions/Functions.dart';

List<dynamic> getDataWithinTimespan(
  List<dynamic> data,
  int timespan,
) {
  if (data is List<Workout>) data = List.of(data).cast<Workout>();

  if (data is List<UserWeight>) data = List.of(data).cast<UserWeight>();

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

  if (dateWithinTimespan.isNotEmpty &&
      (dateWithinTimespan.length < 2 ||
          !hasSameDay(
            dateWithinTimespan,
            latestDateTimeAllowed,
          ))) {
    dynamic _clone = dateWithinTimespan[0].clone();
    _clone.timeInMillisSinceEpoch =
        now.subtract(Duration(days: timespan)).millisecondsSinceEpoch;

    dateWithinTimespan.insert(0, _clone);
  }

  return dateWithinTimespan;
}

// List<UserWeight> getUserWeightsWithinTimespan(
//   List<UserWeight> userWeights,
//   int timespan,
// ) {
//   List<UserWeight> userWeightsWithinTimespan = [];

//   DateTime now = DateTime.now();

//   DateTime mostRecentDateTime = DateTime.fromMillisecondsSinceEpoch(
//     userWeights.last?.timeInMillisSinceEpoch ?? now.millisecondsSinceEpoch,
//   );

//   if (!hasSameDayUserWeights(userWeights, mostRecentDateTime)) {
//     UserWeight mostRecentClone = userWeights.last?.clone();

//     if (mostRecentClone != null) {
//       mostRecentClone.timeInMillisSinceEpoch = now.millisecondsSinceEpoch;
//       userWeights.add(mostRecentClone);

//       mostRecentDateTime = now;
//     }
//   }

//   DateTime latestDateTimeAllowed = mostRecentDateTime.subtract(
//     Duration(days: timespan),
//   );

//   for (int i = 0; i < userWeights.length; i++) {
//     if (timespan == -1) {
//       userWeightsWithinTimespan.add(userWeights[i]);
//     } else {
//       DateTime date = DateTime.fromMillisecondsSinceEpoch(
//         userWeights[i].timeInMillisSinceEpoch,
//       );
//       if (date.isAfter(latestDateTimeAllowed) ||
//           isSameDay(date, latestDateTimeAllowed)) {
//         userWeightsWithinTimespan.add(userWeights[i]);
//       }
//     }
//   }

//   if (userWeightsWithinTimespan.isNotEmpty &&
//       (userWeightsWithinTimespan.length < 2 ||
//           !hasSameDayUserWeights(
//             userWeightsWithinTimespan,
//             latestDateTimeAllowed,
//           ))) {
//     UserWeight _clone = userWeightsWithinTimespan[0].clone();
//     _clone.timeInMillisSinceEpoch =
//         now.subtract(Duration(days: timespan)).millisecondsSinceEpoch;

//     userWeightsWithinTimespan.insert(0, _clone);
//   }

//   return userWeightsWithinTimespan;
// }

// List<Workout> getWorkoutHistoryWithinTimespan(
//   List<Workout> workoutHistory,
//   int timespan,
// ) {
//   List<Workout> workoutHistoryWithinTimespan = [];

//   DateTime now = DateTime.now();

//   DateTime mostRecentDateTime = DateTime.fromMillisecondsSinceEpoch(
//     workoutHistory.last?.timeInMillisSinceEpoch ?? now.millisecondsSinceEpoch,
//   );

//   if (!hasSameDayWorkoutHistory(workoutHistory, mostRecentDateTime)) {
//     Workout mostRecentClone = workoutHistory.last?.clone();

//     if (mostRecentClone != null) {
//       mostRecentClone.timeInMillisSinceEpoch = now.millisecondsSinceEpoch;
//       workoutHistory.add(mostRecentClone);

//       mostRecentDateTime = now;
//     }
//   }

//   DateTime latestDateTimeAllowed = mostRecentDateTime.subtract(
//     Duration(days: timespan),
//   );

//   for (int i = 0; i < workoutHistory.length; i++) {
//     if (timespan == -1) {
//       workoutHistoryWithinTimespan.add(workoutHistory[i]);
//     } else {
//       DateTime date = DateTime.fromMillisecondsSinceEpoch(
//         workoutHistory[i].timeInMillisSinceEpoch,
//       );

//       if (date.isAfter(latestDateTimeAllowed) ||
//           isSameDay(date, latestDateTimeAllowed)) {
//         workoutHistoryWithinTimespan.add(workoutHistory[i]);
//       }
//     }
//   }

//   if (workoutHistoryWithinTimespan.isNotEmpty &&
//       (workoutHistoryWithinTimespan.length < 2 ||
//           !hasSameDayWorkoutHistory(
//               workoutHistoryWithinTimespan, latestDateTimeAllowed))) {
//     Workout _clone = workoutHistoryWithinTimespan[0].clone();
//     _clone.timeInMillisSinceEpoch =
//         now.subtract(Duration(days: timespan)).millisecondsSinceEpoch;

//     workoutHistoryWithinTimespan.insert(0, _clone);
//   }

//   return workoutHistoryWithinTimespan;
// }

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
