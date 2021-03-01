import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';

List<UserWeight> sortUserWeightsByDate(
  List<UserWeight> userWeights,
  bool isAscending,
) {
  List<UserWeight> sortedUserWeights = List.of(userWeights);

  sortedUserWeights.sort((UserWeight a, UserWeight b) {
    if (!isAscending)
      return a.timeInMilliseconds.compareTo(b.timeInMilliseconds);

    return -a.timeInMilliseconds.compareTo(b.timeInMilliseconds);
  });

  return sortedUserWeights;
}

List<Workout> sortWorkoutHistoryByDate(
  List<Workout> workoutHistory,
  bool isAscending,
) {
  List<Workout> sortedWorkoutHistory = List.of(workoutHistory);

  sortedWorkoutHistory.sort((Workout a, Workout b) {
    if (!isAscending)
      return a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);

    return -a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);
  });

  return sortedWorkoutHistory;
}
