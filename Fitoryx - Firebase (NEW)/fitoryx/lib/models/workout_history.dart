import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/models/workout.dart';

class WorkoutHistory {
  String? id;
  final Workout workout;
  final String duration;
  final String note;
  final DateTime date;

  WorkoutHistory({
    this.id,
    required this.workout,
    this.duration = "00:00",
    this.note = "",
    required this.date,
  });

  WorkoutHistory clone({UnitType? newUnit}) {
    var clone = workout.clone(fullClone: true);

    if (newUnit != null) {
      clone.changeUnit(newUnit);
    }

    return WorkoutHistory(
      id: id,
      workout: clone,
      duration: duration,
      note: note,
      date: date,
    );
  }

  static WorkoutHistory fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      workout: Workout.fromJson(json['workout']),
      duration: json['duration'],
      note: json['note'],
      date: json['date']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "workout": workout.toJson(),
      "duration": duration,
      "note": note,
      "date": date,
    };
  }
}
