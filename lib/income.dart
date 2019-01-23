class Income {
  int id;
  String name;
  int value;
  String sourceName;
  DateTime date;
  int sourceId;
  String sourcePath;

  Income.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    sourceName = map['sourceName'];
    sourceId = map['sourceId'];
    sourcePath = map['sourcePath'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "sourceId": sourceId,
      "date": date.millisecondsSinceEpoch,
    };
  }
}
