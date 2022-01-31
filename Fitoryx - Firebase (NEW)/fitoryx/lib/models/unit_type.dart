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

  static UnitType fromValue(String value) {
    if (value == "lbs") return UnitType.imperial;

    return UnitType.metric;
  }
}
