import 'package:fittrack/models/food/Food.dart';
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

List<Workout> sortWorkoutsByDate(List<Workout> _workouts, bool orderAscending) {
  List<Workout> sortedWorkouts = List.of(_workouts);

  sortedWorkouts.sort((Workout a, Workout b) {
    if (orderAscending) {
      return a.timeInMillisSinceEpoch < b.timeInMillisSinceEpoch
          ? -1
          : a.timeInMillisSinceEpoch > b.timeInMillisSinceEpoch
              ? 1
              : 0;
    } else {
      return a.timeInMillisSinceEpoch < b.timeInMillisSinceEpoch
          ? 1
          : a.timeInMillisSinceEpoch > b.timeInMillisSinceEpoch
              ? -1
              : 0;
    }
  });

  return sortedWorkouts;
}

List<Food> sortFoodByDate(List<Food> _food, bool orderAscending) {
  List<Food> sortedFood = List.of(_food);

  sortedFood.sort((Food a, Food b) {
    if (orderAscending) return a.date.compareTo(b.date);

    return -a.date.compareTo(b.date);
  });

  return sortedFood;
}
