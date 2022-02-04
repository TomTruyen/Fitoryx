import 'dart:convert' as convert;

class GraphGoal {
  int workoutGoal;

  GraphGoal({this.workoutGoal = 7});

  @override
  String toString() {
    Map<String, dynamic> map = {
      "workoutGoal": workoutGoal,
    };

    return convert.json.encode(map);
  }

  static GraphGoal fromString(String? map) {
    if (map == null) return GraphGoal();

    Map<String, dynamic> json = convert.json.decode(map);

    return GraphGoal(workoutGoal: json["workoutGoal"] ?? 7);
  }
}
