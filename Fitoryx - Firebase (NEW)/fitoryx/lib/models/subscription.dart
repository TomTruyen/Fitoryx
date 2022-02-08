import 'package:fitoryx/graphs/models/exercise_graph_type.dart';
import 'package:fitoryx/models/graph_type.dart';

enum SubscriptionType { free, pro }

class SubscriptionTypeHelper {
  Subscription getSubscription(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.free:
        return FreeSubscription();
      case SubscriptionType.pro:
        return ProSubscription();
    }
  }

  String toValue(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.free:
        return "free";
      case SubscriptionType.pro:
        return "pro";
    }
  }

  static SubscriptionType fromValue(String? value) {
    switch (value) {
      case "free":
        return SubscriptionType.free;
      case "pro":
        return SubscriptionType.pro;
    }

    return SubscriptionType.free;
  }
}

class Subscription {
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

  Subscription({
    this.workoutLimit,
    this.exerciseLimit,
    this.allowedProfileGraphs = const [],
    this.allowedExerciseGraphs = const [],
    this.allowMeasurementGraphs = false,
  });
}

class FreeSubscription extends Subscription {
  FreeSubscription()
      : super(
          workoutLimit: 2,
          exerciseLimit: 5,
          allowMeasurementGraphs: false,
          allowedExerciseGraphs: [],
          allowedProfileGraphs: [GraphType.workouts],
        );
}

class ProSubscription extends Subscription {
  ProSubscription()
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
            ]);
}
