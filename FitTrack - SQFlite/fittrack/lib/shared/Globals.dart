import 'package:fittrack/services/SQLDatabase.dart';

SQLDatabase sqlDatabase;

enum PageEnum {
  // globals.PageEnum.workout.index to get the index value for the 'changePage' function
  profile,
  history,
  workout,
  exercises,
  food,
}
