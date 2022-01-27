import 'package:fitoryx/models/workout.dart';

class WorkoutHistory {
  String? id;
  final Workout workout;
  final String duration;
  final String note;

  WorkoutHistory({
    this.id,
    required this.workout,
    this.duration = "00:00",
    this.note = "",
  });

  static WorkoutHistory fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      workout: Workout.fromJson(json['workout']),
      duration: json['duration'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "workout": workout.toJson(),
      "duration": duration,
      "note": note,
    };
  }
}
