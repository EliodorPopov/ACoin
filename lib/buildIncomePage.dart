import 'package:flutter/material.dart';
import './db_context.dart';
import './recurrent_income.dart';

class BuildIncomePage extends StatefulWidget {
  BuildIncomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuildIncomePageState createState() => new _BuildIncomePageState();
}

class _BuildIncomePageState extends State<BuildIncomePage> {
  DbContext _context;
  List<RecurrentIncome> _incomes = new List<RecurrentIncome>();

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

  var increment = 0;

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
              subtitle: Text(i.value.toString()+" Date: "+i.date.toString()),
              trailing: Switch(
                value: i.isEnabled,
                onChanged: (v) => toggleIncome(v, i),
              ),
            );
            //}
          }).toList(), 
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {addIncome();},
        tooltip: 'Increment',
        child: new Icon(Icons.add), 
      ),
    );
  }

  addIncome() {
    increment++;
    this._context.updateIncomeTable("test "+increment.toString(), 10*increment, "source", DateTime.now(), true);
    _context.readIncome().then((list) {
      setState(() {
        _incomes = list;
      });
    });

  }
  toggleIncome(bool value, RecurrentIncome item) {
    this._context.toggle(item);
    setState(() {
      item.isEnabled = value;
    });
    
  }

}
