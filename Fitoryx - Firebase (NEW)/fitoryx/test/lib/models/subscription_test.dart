import 'package:fitoryx/graphs/models/exercise_graph_type.dart';
import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/models/subscription.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Subscription', () {
    test('FreeSubscription should set correct super constructor values', () {
      var subscription = FreeSubscription();

      expect(subscription.workoutLimit, 2);
      expect(subscription.exerciseLimit, 3);
      expect(subscription.allowMeasurementGraphs, false);
      expect(subscription.allowedExerciseGraphs.length, 0);
      expect(subscription.allowedProfileGraphs.length, 1);
      expect(
        subscription.allowedProfileGraphs.contains(GraphType.workouts),
        true,
      );
      expect(subscription.expiration, null);
    });

    test('FreeSubscription toJson should return json Map', () {
      var expected = {
        "type": "free",
        "expiration": null,
      };

      var subscription = FreeSubscription();

      expect(subscription.toJson(), expected);
    });

    test('ProSubscription should set correct super constructor values', () {
      var expiration = DateTime.now();

      var subscription = ProSubscription(expiration: expiration);

      expect(subscription.workoutLimit, null);
      expect(subscription.exerciseLimit, null);
      expect(subscription.allowMeasurementGraphs, true);
      expect(subscription.allowedExerciseGraphs.length, 3);
      expect(
        subscription.allowedExerciseGraphs.contains(ExerciseGraphType.reps),
        true,
      );
      expect(
        subscription.allowedExerciseGraphs.contains(ExerciseGraphType.volume),
        true,
      );
      expect(
        subscription.allowedExerciseGraphs.contains(ExerciseGraphType.weight),
        true,
      );
      expect(subscription.allowedProfileGraphs.length, 3);
      expect(
        subscription.allowedProfileGraphs.contains(GraphType.workouts),
        true,
      );
      expect(
        subscription.allowedProfileGraphs.contains(GraphType.calories),
        true,
      );
      expect(
        subscription.allowedProfileGraphs.contains(GraphType.volume),
        true,
      );
      expect(subscription.expiration, expiration);
    });

    test('ProSubscription toJson should return json Map', () {
      var expiration = DateTime.now();

      var expected = {
        "type": "pro",
        "expiration": expiration,
      };

      var subscription = ProSubscription(expiration: expiration);

      expect(subscription.toJson(), expected);
    });
  });
}
