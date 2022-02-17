import 'package:fitoryx/models/graph_goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GraphGoal', () {
    test('toString should return json string from GraphGoal', () {
      var expected = "{\"workoutGoal\":5}";

      var graphGoal = GraphGoal(workoutGoal: 5);

      expect(graphGoal.toString(), expected);
    });

    test('fromString should return GraphGoal from json string', () {
      var str = "{\"workoutGoal\":5}";

      expect(GraphGoal.fromString(str).workoutGoal, 5);
      expect(GraphGoal.fromString(null).workoutGoal, GraphGoal().workoutGoal);
    });
  });
}
