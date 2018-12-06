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
    _context.readIncome().then((list) {
      setState(() {
        _incomes = list;
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
                            dbSource: i.source,
                            dbName: i.name,
                            dbValue: i.value,
                            isRecurrent: false,
                          ),
                        )).then((isSuccessful) {
                      if (isSuccessful)
                        _showSuccessSnackBar("Deleted!", true);
                      else
                        _showSuccessSnackBar("Saved!", false);
                    }).then((e) => _context.readIncome().then((list) {
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
    );
  }
}
