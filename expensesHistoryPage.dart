import 'package:acoin/db_context.dart';
import 'package:acoin/expense.dart';
import 'package:acoin/editExpensePage.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesHistoryPage extends StatefulWidget {
  ExpensesHistoryPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExpensesHistoryPageState createState() => new _ExpensesHistoryPageState();
}

class _ExpensesHistoryPageState extends State<ExpensesHistoryPage> {
  DbContext _context;
  List<Expense> _expenses = new List<Expense>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

  void _showSuccessSnackBar(String message, bool color) {
    Flushbar(flushbarPosition: FlushbarPosition.TOP)
      ..message = message
      ..icon = Icon(
        Icons.done,
        size: 28.0,
        color: color ? Colors.red : Colors.green,
      )
      ..duration = Duration(seconds: 2)
      ..leftBarIndicatorColor = color ? Colors.red : Colors.green
      ..show(context);
  }

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readExpense().then((list) {
      setState(() {
        _expenses = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          children: _expenses.map(
            (i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      SlideLeftRoute(
                        widget: EditExpensePage(
                          title: "edit expense",
                          dbId: i.id,
                          dbCategory: i.category,
                          dbDate: i.date,
                          dbName: i.name,
                          dbValue: i.value,
                        ),
                      ),
                    ).then((isSuccessful) {
                      if (isSuccessful)
                        _showSuccessSnackBar("Deleted!", true);
                      else
                        _showSuccessSnackBar("Saved!", false);
                    }).then(
                      (e) => _context.readExpense().then((list) {
                            setState(() {
                              _expenses = list;
                            });
                          }),
                    ),
                child: ListTile(
                  title: Text(
                    i.name + " [" + i.category + "]",
                    textScaleFactor: 3.0,
                  ),
                  subtitle: Text(
                      i.value.toString() + " MDL " + dateFormat.format(i.date)),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
