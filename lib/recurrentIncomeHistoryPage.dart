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
    _context.readRecurrentIncome().then((list) {
      setState(() {
        _recurrentIncomes = list;
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
                            dbSource: i.source,
                            dbName: i.name,
                            dbValue: i.value,
                            isRecurrent: true,
                          ),
                        )).then((isSuccessful) {
                      if (isSuccessful)
                        _showSuccessSnackBar("Deleted!", true);
                      else
                        _showSuccessSnackBar("Saved!", false);
                    }).then((e) => _context.readRecurrentIncome().then((list) {
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
    );
  }

  toggleIncome(bool value, RecurrentIncome item) {
    this._context.toggle(item);
    setState(() {
      item.isEnabled = value;
    });
  }
}
