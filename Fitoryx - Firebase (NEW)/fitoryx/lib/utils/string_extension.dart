extension StringExtension on String? {
  int? toInt() {
    try {
      if (this == null) return null;

      return int.parse(this!);
    } catch (e) {
      return null;
    }
  }
}
