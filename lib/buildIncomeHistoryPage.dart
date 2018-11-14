import 'package:firstflut/RecurrentIncome.dart';
import 'package:firstflut/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildIncomeHistoryPage extends StatefulWidget {
  BuildIncomeHistoryPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuildIncomeHistoryPageState createState() =>
      new _BuildIncomeHistoryPageState();
}

class _BuildIncomeHistoryPageState extends State<BuildIncomeHistoryPage> {
  DbContext _context;
  List<RecurrentIncome> _incomes = new List<RecurrentIncome>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

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
          children: _incomes.map((i) {
            print(i.isEnabled);
            return ListTile(
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
            );
            //}
          }).toList(),
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
