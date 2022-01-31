extension IntExtension on int {
  String withZeroPadding({int amount = 2}) {
    return toString().padLeft(amount, "0");
  }

  String toMinutesAndSeconds() {
    int minutes = (this % 3600) ~/ 60;
    int seconds = this % 60;

    if (minutes >= 1) {
      if (seconds > 0) {
        return '${minutes}m ${seconds}s';
      } else {
        return '${minutes}m';
      }
    }

    return "${seconds}s";
  }
}
