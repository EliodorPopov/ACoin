import 'package:acoin/addExpensePage.dart';
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
  String _period = 'All time';

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
    _context.readExpense("All time").then((list) {
      setState(() {
        _expenses = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Theme(
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Title(
                    child: Text(widget.title),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    style: TextStyle(fontSize: 15),
                    value: _period,
                    items: <DropdownMenuItem<String>>[
                      new DropdownMenuItem(
                        child: new Text('Today'),
                        value: 'Today',
                      ),
                      new DropdownMenuItem(
                          child: new Text('This week'), value: 'This week'),
                      new DropdownMenuItem(
                          child: new Text('This month'), value: 'This month'),
                      new DropdownMenuItem(
                          child: new Text('Last month'), value: 'Last month'),
                      new DropdownMenuItem(
                          child: new Text('This year'), value: 'This year'),
                      new DropdownMenuItem(
                          child: new Text('All time'), value: 'All time'),
                    ],
                    onChanged: (String value) {
                      _period = value;
                      _context.readExpense(_period).then((list) {
                        setState(() {
                          _expenses = list;
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          data: new ThemeData.dark(),
        ),
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
                      if (isSuccessful == true)
                        _showSuccessSnackBar("Deleted!", true);
                      else if (isSuccessful == false)
                        _showSuccessSnackBar("Saved!", false);
                    }).then(
                      (e) => _context.readExpense("All time").then((list) {
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
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => AddExpensePage(
                          title: "Add Expense",
                        ))).then((isSuccessful) async {
              if (isSuccessful) {
                await _context.readExpense(_period).then((list) {
                  setState(() {
                    _expenses = list;
                  });
                });
                _showSuccessSnackBar("Added", false);
              }
            }),
      ),
    );
  }
}
