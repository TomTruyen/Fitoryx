import 'package:fitoryx/models/exercise_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseType', () {
    test('toValue should return string from enum', () {
      expect(ExerciseTypeHelper.toValue(ExerciseType.weight), "Weight");
      expect(ExerciseTypeHelper.toValue(ExerciseType.time), "Time");
    });

    test('fromValue should return enum from string', () {
      expect(ExerciseTypeHelper.fromValue("Time"), ExerciseType.time);
      expect(ExerciseTypeHelper.fromValue("Weight"), ExerciseType.weight);
      expect(ExerciseTypeHelper.fromValue(null), ExerciseType.weight);
    });
  });
}
