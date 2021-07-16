import 'package:Fitoryx/models/food/Food.dart';
import 'package:Fitoryx/models/settings/UserWeight.dart';
import 'package:Fitoryx/models/workout/Workout.dart';

List<dynamic> sortByDate(
  List<dynamic> list,
  bool isAscending,
) {
  List<dynamic> sortListByDate = List.of(list);

  if (list is List<Workout>) sortListByDate = sortListByDate.cast<Workout>();
  if (list is List<UserWeight>)
    sortListByDate = sortListByDate.cast<UserWeight>();

  sortListByDate.sort((a, b) {
    if (isAscending)
      return a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);

    return -a.timeInMillisSinceEpoch.compareTo(b.timeInMillisSinceEpoch);
  });

  return sortListByDate;
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
