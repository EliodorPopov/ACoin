class RecurrentIncome {
  int id;
  String name;
  int value;
  String sourceName;
  DateTime date;
  int sourceId;
  String sourcePath;
  bool isEnabled;

  RecurrentIncome.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    sourceName = map['sourceName'];
    sourceId = map['sourceId'];
    sourcePath = map['sourcePath'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
    isEnabled = map['isEnabled'] == 1;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "sourceId": sourceId,
      "date": date.millisecondsSinceEpoch,
      "isEnabled": isEnabled
    };
  }
}
