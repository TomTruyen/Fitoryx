import 'package:fittrack/model/workout/WorkoutExercise.dart';

class WorkoutHistory {
  String id;
  String name;
  String workoutNote;
  String weightUnit;
  DateTime workoutTime;
  String workoutDuration;
  List<WorkoutExercise> exercises;

  WorkoutHistory({
    this.id = '',
    this.name = '',
    this.workoutNote = '',
    this.weightUnit = 'kg',
    this.workoutTime,
    this.workoutDuration = '0:00',
    this.exercises,
  });

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> _getExerciseList() {
      List<Map<String, dynamic>> _exercises = [];

      exercises.forEach((WorkoutExercise _exercise) {
        _exercises.add(_exercise.toJSON());
      });

      return _exercises;
    }

    return {
      'workout_id': id,
      'workoutName': name,
      'workoutNote': workoutNote,
      'weightUnit': weightUnit,
      'time': DateTime.now(),
      'workoutDuration': workoutDuration,
      'exercises': _getExerciseList(),
    };
  }
}
