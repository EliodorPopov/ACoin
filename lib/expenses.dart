class Expense {
  int id;
  String name;
  int value;
  DateTime date;

  Expense.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch
    };
  }
}
