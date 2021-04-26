import 'package:fitness_app/models/workout/WorkoutExerciseSet.dart';

class WorkoutExercise {
  String name;
  String category;
  String equipment;
  bool isCompound;
  List<WorkoutExerciseSet> sets;
  bool restEnabled;
  int restSeconds;
  bool hasNotes;
  String notes;

  WorkoutExercise({
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.isCompound = false,
    this.sets,
    this.restEnabled = true,
    this.restSeconds = 60,
    this.hasNotes = false,
    this.notes = "",
  });

  void updateNotes(String value) {
    notes = value;
  }
}
