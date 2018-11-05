import 'package:flutter/material.dart';
import './db_context.dart';
import './expenses.dart';

class BuildExpensesPage extends StatefulWidget {
  BuildExpensesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuildExpensesPageState createState() => new _BuildExpensesPageState();
}

class _BuildExpensesPageState extends State<BuildExpensesPage> {
  DbContext _context;
  List<Expense> _expenses = new List<Expense>();

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

  var increment=0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          children: _expenses.map((i) {
            print(i.name);
            
            return ListTile(
              title: Text(
                i.name,
                textScaleFactor: 3.0,
              ),
              subtitle: Text(i.value.toString() + "  " + i.date.toString()),
            );
            //}
          }).toList(), 
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {addExpense();},
        tooltip: 'Increment',
        child: new Icon(Icons.add), 
      ),
    );
  }

  addExpense() {
    this._context.updateTableRaw("test "+increment.toString(), 800, DateTime.now());
    _context.readExpense().then((list) {
      setState(() {
        _expenses = list;
        increment++;
      });
    }); 
  }
}
