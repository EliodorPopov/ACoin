class Debt {
  int id;
  String pname;
  int debtvalue;
  DateTime date, deadlinedate;

  Debt.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    pname = map['pname'];
    debtvalue = map['debtvalue'];
    date = new DateTime.fromMillisecondsSinceEpoch(map['date']);
    deadlinedate = new DateTime.fromMillisecondsSinceEpoch(map['deadlinedate']);
  }

  Map<String, dynamic> toMap() {
    return {
      "pname": pname,
      "debtvalue": debtvalue,
      "date": date.millisecondsSinceEpoch,
      "deadlinedate": deadlinedate.millisecondsSinceEpoch,
    };
  }
}
