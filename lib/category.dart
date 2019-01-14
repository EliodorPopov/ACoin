class Category {
  int id;
  String name;
  int total;

  set setName(String newname){
    name = newname;
  }

  Category(){
    name = '';
    total = 0;
  }

  Category.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    total = map['total'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "total": total,
    };
  }
}
