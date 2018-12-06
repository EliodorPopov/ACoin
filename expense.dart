class Expense {
  int id;
  String name;
  int value;
  DateTime date;
  String category;

  Expense.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
    category = map["category"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch,
      "category": category
    };
  }
}
