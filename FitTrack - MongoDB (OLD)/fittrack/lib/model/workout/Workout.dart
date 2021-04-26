// My Packages
import 'package:fittrack/model/workout/WorkoutExercise.dart';

class Workout {
  String id;
  String name;
  String workoutNote;
  String weightUnit;
  List<WorkoutExercise> exercises;

  Workout({
    this.id = "",
    this.name = "",
    this.weightUnit = 'kg',
    this.workoutNote = "",
    this.exercises,
  });

  Map<String, dynamic> toJSON() {
    List _getExerciseList() {
      List<Map<String, dynamic>> _exercises = [];

      exercises.forEach((WorkoutExercise _exercise) {
        _exercises.add(_exercise.toJSON());
      });

      return _exercises;
    }

    Map<String, dynamic> workoutMap = {
      'workout_id': id,
      'workoutName': name,
      'workoutNote': workoutNote,
      'weightUnit': weightUnit,
      'time': DateTime.now(),
      'exercises': _getExerciseList()
    };

    return workoutMap;
  }
}
