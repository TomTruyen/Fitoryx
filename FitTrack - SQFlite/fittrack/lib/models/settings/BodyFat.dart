class BodyFat {
  int id;
  double percentage;
  int timeInMillisSinceEpoch;

  BodyFat({this.id, this.percentage = 0, this.timeInMillisSinceEpoch}) {
    if (this.timeInMillisSinceEpoch == null) {
      this.timeInMillisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    }
  }

  BodyFat clone() {
    return new BodyFat(
      id: id,
      percentage: percentage,
      timeInMillisSinceEpoch: timeInMillisSinceEpoch,
    );
  }

  static fromJSON(Map<String, dynamic> json) {
    return new BodyFat(
      id: json['id'],
      percentage: json['percentage'] ?? 0.0,
      timeInMillisSinceEpoch: json['timeInMillisSinceEpoch'] ?? 0,
    );
  }
}

List<BodyFat> getBodyFatListFromJson(Map<String, dynamic> settings) {
  List<BodyFat> _bodyFatList = [];

  List<dynamic> _bodyFatJsonList = [];
  if (settings['bodyFat'] != null) {
    _bodyFatJsonList = settings['bodyFat'] ?? [];
  }

  for (int i = 0; i < _bodyFatJsonList.length; i++) {
    BodyFat bodyFat = BodyFat.fromJSON(_bodyFatJsonList[i]);

    _bodyFatList.add(bodyFat);
  }

  if (_bodyFatList.isEmpty) {
    _bodyFatList.add(
      new BodyFat(
        timeInMillisSinceEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  return _bodyFatList;
}
