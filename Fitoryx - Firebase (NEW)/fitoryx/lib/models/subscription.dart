import 'package:fitoryx/graphs/models/exercise_graph_type.dart';
import 'package:fitoryx/models/graph_type.dart';

abstract class Subscription {
  // Limit of workouts (null = no limit)
  int? workoutLimit;
  // Limit of exercises (null = no limit)
  int? exerciseLimit;
  // Graphs to allow on profile page
  List<GraphType> allowedProfileGraphs = [];
  // Graphs to allow on exercise detail page
  List<ExerciseGraphType> allowedExerciseGraphs = [];
  // Allow measurement graphs
  bool allowMeasurementGraphs;
  // Expiration of subscription (null = no expiration)
  DateTime? expiration;

  Subscription({
    this.workoutLimit,
    this.exerciseLimit,
    this.allowedProfileGraphs = const [],
    this.allowedExerciseGraphs = const [],
    this.allowMeasurementGraphs = false,
    this.expiration,
  });

  Map<String, dynamic> toJson();
}

class FreeSubscription extends Subscription {
  FreeSubscription()
      : super(
          workoutLimit: 2,
          exerciseLimit: 3,
          allowMeasurementGraphs: false,
          allowedExerciseGraphs: [],
          allowedProfileGraphs: [GraphType.workouts],
          expiration: null,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "free",
      "expiration": expiration,
    };
  }
}

class ProSubscription extends Subscription {
  ProSubscription({DateTime? expiration})
      : super(
          workoutLimit: null,
          exerciseLimit: null,
          allowMeasurementGraphs: true,
          allowedExerciseGraphs: [
            ExerciseGraphType.reps,
            ExerciseGraphType.volume,
            ExerciseGraphType.weight
          ],
          allowedProfileGraphs: [
            GraphType.workouts,
            GraphType.calories,
            GraphType.volume
          ],
          expiration: expiration,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "pro",
      "expiration": expiration,
    };
  }
}
