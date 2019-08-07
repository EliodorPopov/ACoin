class GoalTransaction {
  int id;
  int id_transaction;
  int value;
  String details;

  GoalTransaction.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    id_transaction = map['id_trasnaction'];
    value = map['value'];
    details = map['details'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id_transaction" : id_transaction,
      "value": value,
      "details": details,
    };
  }
}
