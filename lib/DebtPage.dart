import 'package:acoin/addDebtPage.dart';
import 'package:acoin/db_context.dart';
import 'package:acoin/debt.dart';
import 'package:acoin/editDebtPage.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtPage extends StatefulWidget {
  DebtPage({Key key}) : super(key: key);
  final String title = "Your Debts";
  @override
  _DebtPageState createState() => new _DebtPageState();
}

class _DebtPageState extends State<DebtPage> {
  DbContext _context;
  List<Debt> _debts = new List<Debt>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

  void _showSuccessSnackBar(String message, bool color) {
    Flushbar(flushbarPosition: FlushbarPosition.TOP)
      ..message = message
      ..icon = Icon(
        Icons.done,
        size: 28.0,
        color: color ? Colors.red : Colors.green,
      )
      ..isDismissible = false
      ..duration = Duration(seconds: 2)
      ..leftBarIndicatorColor = color ? Colors.red : Colors.green
      ..show(context);
  }

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readDebts().then((list) {
      setState(() {
        _debts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          children: _debts.map(
            (i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: EditDebtPage(
                            title: "Edit Debt",
                            dbId: i.id,
                            dbPName: i.pname,
                            dbDebtValue: i.debtvalue,
                            dbDate: i.date,
                            dbDeadlineDate: i.deadlinedate,
                          ),
                        )).then((isSuccessful) {
                      if (isSuccessful == true)
                        _showSuccessSnackBar("Deleted!", true);
                      else if (isSuccessful == false)
                        _showSuccessSnackBar("Saved!", false);
                    }).then(
                      (e) => _context.readDebts().then((list) {
                            setState(() {
                              _debts = list;
                            });
                          }),
                    ),
                child: ListTile(
                  title: Text(
                    i.pname + " " + i.debtvalue.toString() + " MDL ",
                    textScaleFactor: 3.0,
                  ),
                  subtitle:
                      Text("deadline:" + dateFormat.format(i.deadlinedate)),
                ),
              );
            },
          ).toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddDebtPage(
                        title: "Add Debt",
                      ))).then((isSuccessful) async {
            if (isSuccessful) {
              await _context.readDebts().then((list) {
                setState(() {
                  _debts = list;
                });
              });
              _showSuccessSnackBar("Added", false);
            }
          });
        },
        icon: Icon(Icons.local_atm),
        label: Text("Add Debt"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
