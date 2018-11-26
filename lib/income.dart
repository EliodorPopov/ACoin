class Income {
  int id;
  String name;
  int value;
  String source;
  DateTime date;

  Income.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    source = map['source'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "source": source,
      "date": date.millisecondsSinceEpoch,
    };
  }
}
