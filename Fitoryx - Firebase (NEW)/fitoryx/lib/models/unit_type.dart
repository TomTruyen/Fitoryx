enum UnitType { metric, imperial }

class UnitTypeHelper {
  static String toValue(UnitType type) {
    switch (type) {
      case UnitType.metric:
        return "kg";
      case UnitType.imperial:
        return "lbs";
    }
  }

  static UnitType fromValue(String? value) {
    if (value == "lbs") return UnitType.imperial;

    return UnitType.metric;
  }

  // Used by settings
  static String toSubtitle(UnitType type) {
    switch (type) {
      case UnitType.metric:
        return "Metric (kg)";
      case UnitType.imperial:
        return "Imperial (lbs)";
    }
  }
}
