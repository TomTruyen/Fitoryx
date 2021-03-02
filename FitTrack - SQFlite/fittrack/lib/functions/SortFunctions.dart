import 'package:fittrack/models/food/Food.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/models/workout/Workout.dart';

List<UserWeight> sortUserWeightsByDate(
  List<UserWeight> userWeights,
  bool isAscending,
) {
  List<UserWeight> sortedUserWeights = List.of(userWeights);

  sortedUserWeights.sort((UserWeight a, UserWeight b) {
    if (isAscending)
      return a.timeInMilliseconds.compareTo(b.timeInMilliseconds);

    return -a.timeInMilliseconds.compareTo(b.timeInMilliseconds);
  });

  return sortedUserWeights;
}

List<Workout> sortWorkoutsByDate(
  List<Workout> workouts,
  bool isAscending,
) {
  List<Workout> sortWorkoutsByDate = List.of(workouts);

  sortWorkoutsByDate.sort((Workout a, Workout b) {
    if (isAscending)
      return a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);

    return -a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);
  });

  return sortWorkoutsByDate;
}

List<Food> sortFoodByDate(List<Food> _food, bool orderAscending) {
  List<Food> sortedFood = List.of(_food);

  sortedFood.sort((Food a, Food b) {
    DateTime aDate = DateTime(int.parse(a.date.split('-')[2]),
        int.parse(a.date.split('-')[1]), int.parse(a.date.split('-')[0]));

    DateTime bDate = DateTime(int.parse(b.date.split('-')[2]),
        int.parse(b.date.split('-')[1]), int.parse(b.date.split('-')[0]));

    if (orderAscending) return aDate.compareTo(bDate);

    return -aDate.compareTo(bDate);
  });

  return sortedFood;
}
