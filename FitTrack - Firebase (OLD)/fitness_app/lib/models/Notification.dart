class Notification {
  final String title;
  final String description;
  DateTime time = DateTime.now();

  Notification({this.title = "", this.description = "", this.time});
}
