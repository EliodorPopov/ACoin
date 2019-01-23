import 'package:acoin/addIncomePage.dart';
import 'package:acoin/editIncomePage.dart';
import 'package:acoin/recurrentIncome.dart';
import 'package:acoin/db_context.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecurrentIncomeHistoryPage extends StatefulWidget {
  RecurrentIncomeHistoryPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RecurrentIncomeHistoryPageState createState() =>
      new _RecurrentIncomeHistoryPageState();
}

class _RecurrentIncomeHistoryPageState
    extends State<RecurrentIncomeHistoryPage> {
  DbContext _context;
  List<RecurrentIncome> _recurrentIncomes = new List<RecurrentIncome>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  String _period = 'Today', sort = 'Descending';

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
    _context.readRecurrentIncome(_period).then((list) {
      setState(() {
        _recurrentIncomes = list;
        _recurrentIncomes
          ..sort((a, b) => b.date.millisecondsSinceEpoch
              .compareTo(a.date.millisecondsSinceEpoch));
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
                      new DropdownMenuItem(
                          child: new Text(
                              sort == 'Ascending' ? 'Descending' : 'Ascending',
                              style: TextStyle(color: Colors.green)),
                          value: 'sort')
                    ],
                    onChanged: (String value) {
                      if (value != 'sort') {
                        _period = value;
                        _context.readRecurrentIncome(_period).then((list) {
                          setState(() {
                            _recurrentIncomes = list;
                          });
                        });
                      } else {
                        if (sort == 'Ascending') {
                          setState(() {
                            _recurrentIncomes.sort((a, b) => b
                                .date.millisecondsSinceEpoch
                                .compareTo(a.date.millisecondsSinceEpoch));
                            sort = 'Descending';
                          });
                        } else {
                          setState(() {
                            _recurrentIncomes.sort((a, b) => a
                                .date.millisecondsSinceEpoch
                                .compareTo(b.date.millisecondsSinceEpoch));
                            sort = 'Ascending';
                          });
                        }
                      }
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
          children: _recurrentIncomes.map(
            (i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: EditIncomePage(
                            title: "edit expense",
                            dbId: i.id,
                            dbDate: i.date,
                            dbSourceId: i.sourceId,
                            dbSourceName: i.sourceName,
                            dbSourcePath: i.sourcePath,
                            dbName: i.name,
                            dbValue: i.value,
                            isRecurrent: true,
                          ),
                        )).then((isSuccessful) {
                      if (isSuccessful)
                        _showSuccessSnackBar("Deleted!", true);
                      else
                        _showSuccessSnackBar("Saved!", false);
                    }).then((e) =>
                        _context.readRecurrentIncome("All time").then((list) {
                          setState(() {
                            _recurrentIncomes = list;
                          });
                        })),
                child: ListTile(
                  title: Text(
                    i.name,
                    textScaleFactor: 3.0,
                  ),
                  subtitle: Text(
                      i.value.toString() + " MDL " + dateFormat.format(i.date)),
                  trailing: Switch(
                    value: i.isEnabled,
                    onChanged: (v) => toggleIncome(v, i),
                  ),
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
                          title: "Add Recurrent Income",
                          isRecurrent: true,
                        ))).then((isSuccessful) async {
              if (isSuccessful) {
                await _context.readRecurrentIncome(_period).then((list) {
                  setState(() {
                    _recurrentIncomes = list;
                  });
                });
                _showSuccessSnackBar("Added", false);
              }
            }),
      ),
    );
  }

  toggleIncome(bool value, RecurrentIncome item) {
    _context.toggle(item);
    setState(() {
      item.isEnabled = value;
    });
  }
}
