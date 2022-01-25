import 'package:fitoryx/models/exercise_set.dart';

class Exercise {
  int? id;
  String name;
  String category;
  String equipment;
  bool userCreated = false;
  String notes = "";
  bool restEnabled = true;
  int restSeconds = 60;
  List<ExerciseSet> sets = [ExerciseSet()];
  String type;

  Exercise(
      {this.name = "",
      this.category = "",
      this.equipment = "",
      this.type = "weight"});
}
