enum GraphType { workouts, volume, calories }

class GraphTypeHelper {
  static String toValue(GraphType type) {
    switch (type) {
      case GraphType.workouts:
        return "Workouts";
      case GraphType.volume:
        return "Volume";
      case GraphType.calories:
        return "Calories";
    }
  }

  static GraphType fromValue(String? value) {
    switch (value) {
      case "Workouts":
        return GraphType.workouts;
      case "Volume":
        return GraphType.volume;
      case "Calories":
        return GraphType.calories;
    }

    return GraphType.workouts;
  }
}
