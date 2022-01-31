import 'dart:math';

extension DoubleExtension on double? {
  double toDecimalPlaces(int places) {
    num mod = pow(10.0, places);
    return ((this! * mod).round().toDouble() / mod);
  }

  String? toIntString() {
    if (this == null || this! % 1 != 0) {
      return this?.toString();
    }

    return this?.toInt().toString();
  }
}
