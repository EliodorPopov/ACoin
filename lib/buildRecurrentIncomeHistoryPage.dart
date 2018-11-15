import 'package:firstflut/RecurrentIncome.dart';
import 'package:firstflut/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildRecurrentIncomeHistoryPage extends StatefulWidget {
  BuildRecurrentIncomeHistoryPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuildRecurrentIncomeHistoryPageState createState() =>
      new _BuildRecurrentIncomeHistoryPageState();
}

class _BuildRecurrentIncomeHistoryPageState extends State<BuildRecurrentIncomeHistoryPage> {
  DbContext _context;
  List<RecurrentIncome> _recurrentIncomes = new List<RecurrentIncome>();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

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
          children: _recurrentIncomes.map((i) {
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
