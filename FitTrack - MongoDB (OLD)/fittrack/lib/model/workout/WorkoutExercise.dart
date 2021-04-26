import 'package:fittrack/model/workout/WorkoutExerciseSet.dart';

class WorkoutExercise {
  String exerciseId;
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
    this.exerciseId = "",
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

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> _buildSets() {
      List<Map<String, dynamic>> _sets = [];

      sets.forEach((_set) {
        _sets.add(_set.toJSON());
      });

      return _sets;
    }

    return {
      'exercise_id': exerciseId,
      'exerciseName': name,
      'exerciseCategory': category,
      'exerciseEquipment': equipment,
      'isCompound': isCompound,
      'sets': _buildSets(),
      'restEnabled': restEnabled,
      'restSeconds': restSeconds,
      'hasNotes': hasNotes,
      'notes': notes,
    };
  }
}
