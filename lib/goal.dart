class Goal {
  int id;
  String name;
  int value;

  Goal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
    };
  }
}
