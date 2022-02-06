class FatPercentage {
  String? id;
  double percentage;
  DateTime date = DateTime.now();

  FatPercentage({this.id, this.percentage = 0});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "percentage": percentage,
      "date": date,
    };
  }

  static FatPercentage fromJson(Map<String, dynamic> json) {
    var percentage = FatPercentage(
      id: json['id'],
      percentage: json['percentage'],
    );

    percentage.date = json['date']?.toDate();

    return percentage;
  }
}
