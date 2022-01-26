class ExerciseSet {
  int? reps;
  double? weight;
  int? time; //time in seconds
  bool completed;

  ExerciseSet({this.reps, this.weight, this.time, this.completed = false});

  String getTime() {
    if (time == null || time == 0) {
      return '0:00';
    }

    int minutes = (time! % 3600) ~/ 60;
    int seconds = time! % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
