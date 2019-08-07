class Expense {
  int id;
  String name;
  int value;
  DateTime date;
  int categoryId;
  String categoryName;
  String categoryIconPath;

  Expense.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
    categoryId = map["categoryId"];
    categoryName = map["categoryName"];
    categoryIconPath = map["categoryIconPath"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch,
      "categoryId": categoryId
    };
  }
}
