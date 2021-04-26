import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/models/workout/WorkoutExerciseSet.dart';

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
    this.weightUnit = 'metric',
    this.workoutTime,
    this.workoutDuration = '0:00',
    this.exercises,
  });

  Map<String, dynamic> toJson() {
    List _getSetList(List<WorkoutExerciseSet> sets) {
      List<Map<String, dynamic>> setList = [];

      for (int i = 0; i < sets.length; i++) {
        setList.add({
          'weight': sets[i].weight,
          'reps': sets[i].reps,
        });
      }

      return setList;
    }

    List _getExerciseList() {
      List<Map<String, dynamic>> exerciseList = [];

      for (int i = 0; i < exercises.length; i++) {
        exerciseList.add({
          'exerciseName': exercises[i].name,
          'exerciseCategory': exercises[i].category,
          'exerciseEquipment': exercises[i].equipment,
          'isCompound': exercises[i].isCompound,
          'sets': _getSetList(exercises[i].sets),
          'restEnabled': exercises[i].restEnabled,
          'restSeconds': exercises[i].restSeconds,
          'hasNotes':
              exercises[i].hasNotes && exercises[i].notes != "" ? true : false,
          'notes': exercises[i].notes,
        });
      }

      return exerciseList;
    }

    Map<String, dynamic> workoutMap = {
      'id': id,
      'workoutName': name,
      'workoutNote': workoutNote,
      'weightUnit': weightUnit,
      'time': DateTime.now(),
      'exercises': _getExerciseList()
    };

    return workoutMap;
  }
}
