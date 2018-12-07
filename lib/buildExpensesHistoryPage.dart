import 'package:acoin/db_context.dart';
import 'package:acoin/expense.dart';
import 'package:acoin/editEarningPage.dart';
import 'package:acoin/editExpensePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO remove build from name of class
class BuildExpensesHistoryPage extends StatefulWidget {
  BuildExpensesHistoryPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuildExpensesHistoryPageState createState() =>
      new _BuildExpensesHistoryPageState();
}

// TODO remove build from name of class
class _BuildExpensesHistoryPageState extends State<BuildExpensesHistoryPage> {
  DbContext _context;
  List<Expense> _expenses = new List<Expense>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    //_context.editExpense(1, 'test2', 999, DateTime.now(), 'testcat');
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
          children: _expenses.map((i) {
            return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => EditExpensePage(
                              title: "edit expense",
                              dbId: i.id,
                              dbCategory: i.category,
                              dbDate: i.date,
                              dbName: i.name,
                              dbValue: i.value,
                            )),
                  ),
              child: ListTile(
                title: Text(
                  i.name + " [" + i.category + "]",
                  textScaleFactor: 2.0,
                ),
                subtitle: Text(
                    i.value.toString() + " MDL " + dateFormat.format(i.date)),
              ),
            );
            //}
          }).toList(),
        ),
      ),
    );
  }
}
