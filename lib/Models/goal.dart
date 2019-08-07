class Goal {
  int id;
  String name;
  int value;
  int target;

  Goal (this.name,this.value,this.target);

  Goal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    target = map['target'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "target": target,
    };
  }
} 