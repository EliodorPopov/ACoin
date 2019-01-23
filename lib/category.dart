class Category {
  int id;
  String name;
  int total;
  String path;
  int categoryStatus;

  Category(){
    name = '';
    total = 0;
  }

  Category.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    total = map['total'];
    path = map['path'];
    categoryStatus = map['categoryStatus'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "total": total,
      "path": path,
      "categoryStatus": categoryStatus,
    };
  }
}
