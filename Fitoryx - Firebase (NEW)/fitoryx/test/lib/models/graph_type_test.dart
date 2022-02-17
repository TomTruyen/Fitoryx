import 'package:fitoryx/models/graph_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseType', () {
    test('toValue should return string from enum', () {
      expect(GraphTypeHelper.toValue(GraphType.workouts), "Workouts");
      expect(GraphTypeHelper.toValue(GraphType.volume), "Volume");
      expect(GraphTypeHelper.toValue(GraphType.calories), "Calories");
    });

    test('fromValue should return enum from string', () {
      expect(GraphTypeHelper.fromValue("Workout"), GraphType.workouts);
      expect(GraphTypeHelper.fromValue("Volume"), GraphType.volume);
      expect(GraphTypeHelper.fromValue("Calories"), GraphType.calories);
      expect(GraphTypeHelper.fromValue(null), GraphType.workouts);
    });
  });
}
