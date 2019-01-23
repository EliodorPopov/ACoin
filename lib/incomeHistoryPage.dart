import 'package:acoin/addIncomePage.dart';
import 'package:acoin/income.dart';
import 'package:acoin/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:acoin/editIncomePage.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flushbar/flushbar.dart';

class IncomeHistoryPage extends StatefulWidget {
  IncomeHistoryPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IncomeHistoryPageState createState() => new _IncomeHistoryPageState();
}

class _IncomeHistoryPageState extends State<IncomeHistoryPage> {
  DbContext _context;
  List<Income> _incomes = new List<Income>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  String _period = 'Today';

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
    _context.readIncome(_period).then((list) {
      setState(() {
        _incomes = list;
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
                      _context.readIncome(_period).then((list) {
                        setState(() {
                          _incomes = list;
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
          children: _incomes.map(
            (i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: EditIncomePage(
                            title: "edit expense",
                            dbId: i.id,
                            dbDate: i.date,
                            dbSourceName: i.sourceName,
                            dbSourcePath: i.sourcePath,
                            dbSourceId: i.sourceId,
                            dbName: i.name,
                            dbValue: i.value,
                            isRecurrent: false,
                          ),
                        )).then((isSuccessful) {
                      if (isSuccessful)
                        _showSuccessSnackBar("Deleted!", true);
                      else
                        _showSuccessSnackBar("Saved!", false);
                    }).then((e) => _context.readIncome("All time").then((list) {
                          setState(() {
                            _incomes = list;
                          });
                        })),
                child: ListTile(
                  title: Text(
                    i.name,
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
                    builder: (c) => AddIncomePage(
                          title: "Add Income", isRecurrent: false,
                        ))).then((isSuccessful) async {
              if (isSuccessful) {
                await _context.readIncome(_period).then((list) {
                  setState(() {
                    _incomes = list;
                  });
                });
                _showSuccessSnackBar("Added", false);
              }
            }),
      ),
    );
  }
}
